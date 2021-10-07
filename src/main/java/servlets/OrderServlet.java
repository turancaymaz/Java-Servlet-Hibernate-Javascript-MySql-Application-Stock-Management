package servlets;

import com.google.gson.Gson;
import entities.Customer;
import entities.Orders;
import entities.OrdersProductCustomer;
import entities.Products;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import utils.DBUtil;
import utils.HibernateUtil;

import javax.persistence.criteria.Order;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "orderServlet", value = { "/order-post" , "/order-get", "/order-delete"})
public class OrderServlet extends HttpServlet {
    SessionFactory sf = HibernateUtil.getSessionFactory();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int cid = Integer.parseInt(req.getParameter("cid"));
        Gson gson = new Gson();
        Session sesi = sf.openSession();
        List<OrdersProductCustomer> ls = sesi.createNativeQuery("Select * From Orders as o \n" +
                "INNER JOIN customer as cu \n" +
                "On o.order_customer_id= cu.cu_id\n" +
                "INNER JOIN products as pro \n" +
                "On pro.p_id = o.order_product_id\n" +
                "WHERE o.customer_cu_id = ?1 and o.order_status = ?2")
                .setParameter(1,cid)
                .setParameter(2,0)
                .addEntity(OrdersProductCustomer.class)
                .getResultList();


        sesi.close();
        String stJson = gson.toJson(ls);
        resp.setContentType("application/json");
        resp.getWriter().write(stJson);




    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int bid = 0;
        Session sesi = sf.openSession();
        Transaction tr = sesi.beginTransaction();
        try{
            String obj = req.getParameter("obj");
            Gson gson = new Gson();
            Orders order = gson.fromJson(obj, Orders.class);

            DBUtil dbUtil = new DBUtil();
            Products pro = dbUtil.singleProduct( order.getOrder_product_id() );
            Customer cus = dbUtil.singleCustomer( order.getOrder_customer_id() );
            order.setProduct(pro);
            order.setCustomer(cus);
            sesi.save(order);
            tr.commit();
            sesi.close();
            bid = 1;
        }catch (Exception ex){
            System.err.println("Save Or Update Error : " + ex);
        }finally {
            sesi.close();
        }
        resp.setContentType("application/json");
        resp.getWriter().write(""+bid);


    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int return_id = 0;
        Session sesi = sf.openSession();
        Transaction tr = sesi.beginTransaction();
        try {
            int order_id = Integer.parseInt(req.getParameter("order_id"));
            Orders orders = sesi.load(Orders.class,order_id);
            sesi.delete(orders);
            tr.commit();
            return_id = orders.getOrder_id();
        }catch (Exception ex){
            System.err.println("boxDelete Error : " + ex);
        }finally {
            sesi.close();
        }

        resp.setContentType("application/json");
        resp.getWriter().write(""+return_id);

    }
}

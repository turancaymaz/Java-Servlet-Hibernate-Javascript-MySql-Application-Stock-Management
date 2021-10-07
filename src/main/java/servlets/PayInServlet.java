package servlets;

import com.google.gson.Gson;
import entities.PayIn;
import entities.PayInTable;
import entities.Receipt;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import utils.DBUtil;
import utils.HibernateUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "payInServlet", value = {"/payIn-get","/payIn-post","/payIn-delete"})
public class PayInServlet extends HttpServlet {

    SessionFactory sf = HibernateUtil.getSessionFactory();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int pid = 0;
        Session sesi = sf.openSession();
        Transaction tr = sesi.beginTransaction();
        try{
            String obj = req.getParameter("obj");
            Gson gson = new Gson();
            PayIn payIn = gson.fromJson(obj,PayIn.class);
            payIn.setPayIn_date(LocalDateTime.now());

            DBUtil util = new DBUtil();
            Receipt r = util.singleReceipt(payIn.getReceipt_id());

            if( r.getReceipt_total() > r.getReceipt_payment()+ payIn.getPayIn_amount() ){
                r.setReceipt_payment( r.getReceipt_payment()+ payIn.getPayIn_amount());
            }else {
                r.setReceipt_payment(r.getReceipt_total());
            }
            sesi.update(r);


            sesi.save(payIn);
            tr.commit();
            pid=1;
        }catch (Exception ex){
            System.err.println("Save Or Update Error : " + ex);
        }finally {
            sesi.close();
        }
        resp.setContentType("application/json");
        resp.getWriter().write( "" +pid);

    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Gson gson = new Gson();
        Session sesi = sf.openSession();
        List<PayInTable> ls = sesi.createNativeQuery("SELECT r.receipt_id,c.cu_id,c.cu_name,c.cu_surname,r.receipt_total, p.payIn_amount, p.payIn_date,p.payment_detail,o.order_receipt FROM receipt as r INNER JOIN payin p on r.receipt_id = p.receipt_id INNER JOIN receipt_orders as ro on r.receipt_id = ro.Receipt_receipt_id INNER JOIN orders as o on ro.Orders_order_id = o.order_id INNER JOIN customer as c on o.customer_cu_id = c.cu_id GROUP BY r.receipt_id;")
                .addEntity(PayInTable.class)
                .getResultList();
        sesi.close();
        String stJson = gson.toJson(ls);
        resp.setContentType("application/json");
        resp.getWriter().write(stJson);

    }
}

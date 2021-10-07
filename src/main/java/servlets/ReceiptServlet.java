package servlets;

import ReceiptNumber.ReceiptValue;
import com.google.gson.Gson;
import entities.Orders;
import entities.Receipt;
import entities.ReceiptAll;
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

@WebServlet(name = "receiptServlet", value = {"/receipt-get","/receipt-post"})
public class ReceiptServlet extends HttpServlet {
    SessionFactory sf = HibernateUtil.getSessionFactory();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String obj = req.getParameter("obj");
        Gson gson = new Gson();
        ReceiptValue receiptValue = gson.fromJson(obj, ReceiptValue.class);

        Session sesiUpdateStatus = sf.openSession();
        Transaction tr1 = sesiUpdateStatus.beginTransaction();
        int bid = 0;

        try {
            sesiUpdateStatus.createSQLQuery("CALL orderStatusChange(?)")
                    .setParameter(1,receiptValue.getOrder_receipt())
                    .executeUpdate();
            tr1.commit();
            bid = 1;
        }catch (Exception ex){
            System.err.println("Update Statue Error : " + ex);
        }finally {
            sesiUpdateStatus.close();
        }


        if(bid == 1) {
            Session sesi = sf.openSession();
            Transaction tr = sesi.beginTransaction();
            try {
                DBUtil dbUtil = new DBUtil();

                List<Orders> orderActions = dbUtil.boxActionsList(receiptValue.getOrder_receipt());
                int total = 0;
                if (orderActions != null) {
                    for (Orders item : orderActions) {
                        total = total + (item.getProduct().getP_salesPrice() * item.getOrder_count());
                    }
                    Receipt receipt = new Receipt();

                    receipt.setReceipt_total(total);
                    receipt.setDate(LocalDateTime.now());
                    receipt.setOrders (orderActions);
                    receipt.setReceipt_payment(0);

                    bid = (int) sesi.save(receipt);

                    tr.commit();

                }

            } catch (Exception ex) {
                System.err.println("Save Or Update Error : " + ex);
            } finally {
                sesi.close();
            }
        }



        resp.setContentType("application/json");
        resp.getWriter().write(""+bid);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ReceiptAll receiptTotal = new ReceiptAll();
        Session sesi = sf.openSession();
        try {
            int cid = Integer.parseInt(req.getParameter("cid"));
            int join = Integer.parseInt(req.getParameter("join_receipt"));
            receiptTotal = (ReceiptAll) sesi.createNativeQuery(" SELECT DISTINCT order_receipt as join_receipt, receipt_total as join_receipt_total, receipt_payment  FROM receipt as r\n" +
                    "INNER JOIN receipt_orders as ro\n" +
                    "on r.receipt_id = ro.Receipt_receipt_id\n" +
                    "INNER JOIN orders as o\n" +
                    "on o.order_id = ro.Orders_order_id\n" +
                    "INNER JOIN customer as c\n" +
                    "on c.cu_id =  o.customer_cu_id\n" +
                    "WHERE cu_id = ?1 and order_receipt = ?2")
                    .setParameter(1,cid)
                    .setParameter(2,join)
                    .addEntity(ReceiptAll.class)
                    .getSingleResult();

        }catch (Exception ex){
            System.err.println("Error : " + ex);
        }finally {
            sesi.close();
        }
        Gson gson = new Gson();
        String stJson = gson.toJson(receiptTotal);
        resp.setContentType("application/json");
        resp.getWriter().write(stJson);



    }

}

package servlets;

import com.google.gson.Gson;
import entities.Customer;
import entities.PayOut;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import utils.HibernateUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "payOutServlet", value = { "/payout-post", "/payout-delete", "/payout-get" })
public class PayOutServlet extends HttpServlet {

    SessionFactory sf = HibernateUtil.getSessionFactory();

    // /customer-insert
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int pid = 0;
        Session sesi = sf.openSession();
        Transaction tr = sesi.beginTransaction();
        try {
            String obj = req.getParameter("obj");
            Gson gson = new Gson();
            PayOut payOut = gson.fromJson(obj, PayOut.class);
            sesi.saveOrUpdate(payOut);
            tr.commit();
            sesi.close();
            pid = 1;
        }catch ( Exception ex) {
            System.err.println("Save OR Update Error : " + ex);
        }finally {
            sesi.close();
        }

        resp.setContentType("application/json");
        resp.getWriter().write( "" +pid );
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Gson gson = new Gson();
        Session sesi = sf.openSession();
        List<PayOut> ls = sesi.createQuery("from PayOut ").getResultList();
        sesi.close();

        String stJson = gson.toJson(ls);
        resp.setContentType("application/json");
        resp.getWriter().write( stJson );
    }

    // /customer-remove
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int return_id = 0;
        Session sesi = sf.openSession();
        Transaction tr = sesi.beginTransaction();
        try {
            int payOut_id = Integer.parseInt( req.getParameter("payOut_id") );
            PayOut payOut = sesi.load(PayOut.class, payOut_id);
            sesi.delete(payOut);
            tr.commit();
            return_id = payOut.getPayOut_id();
        }catch (Exception ex) {
            System.err.println("Delete Error : " + ex);
        }finally {
            sesi.close();
        }

        resp.setContentType("application/json");
        resp.getWriter().write( ""+return_id );
    }






}
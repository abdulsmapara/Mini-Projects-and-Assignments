/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package package1;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.util.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.Calendar;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author abdulsmapara
 */
public class Servlet1 extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	response.setContentType("text/html;charset=UTF-8");
	try{
	    Class.forName("oracle.jdbc.driver.OracleDriver");
	    String URL = "jdbc:oracle:thin:@192.168.2.25:1521:orcl";
	    String USER = "BCS53";
	    String PASS = "BCS53";
	    java.sql.Connection conn = DriverManager.getConnection(URL, USER, PASS);
	    System.out.println("-----------------------------------------CONNECTED TO JDBC--------------------------------------------");
	    conn.setAutoCommit(false);
	    /*CallableStatement cst = null;
	    cst = conn.prepareCall("{?= call test_func(?)}");
	    cst.registerOutParameter(1, Types.INTEGER);

	    cst.setString(2,"");
	    cst.execute();
	    int b = cstetInt(1);
	    */
	    /*String dt1[] = request.getParameter("d1").split("-");
	    String dt2[] = request.getParameter("d2").split("-");
	    String pk1 = request.getParameter("pk1");
	    String n1 = request.getParameter("n1");
	    String n2 = request.getParameter("n2");
	    String c1 = request.getParameter("c1");
	    String c2 = request.getParameter("c2");
	    String d1 = dt1[2]+'-'+dt1[1]+'-'+dt1[0];
	    String d2 = dt2[2]+'-'+dt2[1]+'-'+dt2[0];
	    CallableStatement cst = conn.prepareCall("{call insertSample(?,?,?,?,?)}");
	    cst.setInt(1, Integer.parseInt(pk1));
	    cst.setInt(2,Integer.parseInt(n1));
	    cst.setInt(3,Integer.parseInt(n2));
	    cst.setString(4,c1);
	    cst.setDate(5, java.sql.Date.valueOf(dt1[0]+'-'+dt1[1]+'-'+dt1[2]));
	    cst.execute();
	    PreparedStatement ps = conn.prepareStatement("select * from sample where pk = ?");
	    ps.setInt(1, 2);
	    ResultSet rs = ps.executeQuery();
	    try (PrintWriter out = response.getWriter()) {
		rs.next();
		out.print("SUCCESS !" + rs.getDate("d1"));
	    }
	    
	    */
	    CallableStatement cst = conn.prepareCall("{? = call insertUsers(?,?,?,?)}");
	    String userid = request.getParameter("userid");
	    String name = request.getParameter("name");
	    String pin = request.getParameter("pin");
	    String mobile = request.getParameter("mobile");
	    
	    
	    cst.registerOutParameter(1, Types.VARCHAR);
	    cst.setString(2, userid);
	    cst.setString(3,name);
	    cst.setString(4,mobile);
	    cst.setString(5, pin);
	    
	    cst.execute();
	    
	    String result = cst.getString(1);
	    
	    try (PrintWriter out = response.getWriter()) {
		out.print(result);
		out.print("<a href=\"index.jsp\">BACK</a>");
	    }
	    
	    
	    
	    conn.close();

	}catch(Exception e){
	    e.printStackTrace();
	}
	
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
	return "Short description";
    }// </editor-fold>

}

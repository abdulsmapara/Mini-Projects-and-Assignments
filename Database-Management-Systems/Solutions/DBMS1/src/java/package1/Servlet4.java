/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package package1;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.DriverManager;
import java.sql.Types;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author abdulsmapara
 */
public class Servlet4 extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, IOException {
	response.setContentType("text/html;charset=UTF-8");
	try{
	response.setContentType("text/html;charset=UTF-8");
	Class.forName("oracle.jdbc.driver.OracleDriver");
	    String URL = "jdbc:oracle:thin:@192.168.2.25:1521:orcl";
	    String USER = "BCS53";
	    String PASS = "BCS53";
	    java.sql.Connection conn = DriverManager.getConnection(URL, USER, PASS);
	    System.out.println("-----------------------------------------CONNECTED TO JDBC--------------------------------------------");
	    
	/*PreparedStatement ps = conn.prepareStatement("select * from sample where d1 between ? and ?");
	  ps.setDate(1, d1);
	  ps.setDate(2,d2);
	ResultSet rs = ps.executeQuery();
	
	
	try (PrintWriter out = response.getWriter()) {
	    while(rs.next()){
		out.println(rs.getInt(1)+" " + rs.getInt(2) +" " + rs.getInt(3) + " " + rs.getString(4)+" <br />");
	    }
	
	}*/
	/*CallableStatement cst = conn.prepareCall("{?= call findBetween(?,?)}");
	cst.registerOutParameter(1,Types.VARCHAR);
	cst.setDate(2, d1);
	cst.setDate(3,d2);
	cst.execute();
	String result = cst.getString(1);
	if(result=="-1"){
	    try(PrintWriter out = response.getWriter()){
		out.println("<center>ERROR in your data</center>");
	    }
	}else{
	    try(PrintWriter out = response.getWriter()){
		out.println("<center>SUCCESSFUL ! RESULT IS " + result +"</center>");
	    }
	}*/
	
	CallableStatement cst = conn.prepareCall("{? = call withdraw(?,?,?)}");
	cst.registerOutParameter(1, Types.VARCHAR);
	cst.setString(2,request.getParameter("userid"));
	cst.setString(3,request.getParameter("pin"));
	cst.setString(4,request.getParameter("amount"));
	
	cst.execute();
	
	String result = cst.getString(1);
	
	try(PrintWriter out = response.getWriter()){
		out.println(result);
	    }
	
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

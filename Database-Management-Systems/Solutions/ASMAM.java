package package1;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.LinkedList;
import java.util.Scanner;
import java.util.StringTokenizer;

/**
 *
 * @author abdulsmapara
 * Solution for jdbc 07th March que - Comma Seperated file etc
 */
public class ASMAM {
    
    static void import_from_file(Connection con){
	try{
	    String str="";
	    char[] ch = new char[10000];
	    FileReader fr = new FileReader("file.txt");
	    BufferedReader br = new BufferedReader(fr);
	    String line;
	    while((line=br.readLine()) != null){
		//System.out.println(line);
		if(line.endsWith("\n"))
		    str = str + line.substring(0,line.length()-1)+",";
		else
		    str = str + line + ",";
	    }
	    str=str.substring(0,str.length()-1);
	    System.out.println(str);
	    if(false)
	    throw new Exception("end");
	    
	    StringTokenizer sz = new StringTokenizer(str,",",false);
	    Statement stmt = con.createStatement();
	    
	    int count1=0;
	    while(sz.hasMoreTokens()){
		String d1 = sz.nextToken();
		String d2 = sz.nextToken();
		String d3 = sz.nextToken();
		String d4 = sz.nextToken();
		String[] arr1 = d4.split("-");
		String dt1 = arr1[0]+"-"+arr1[1]+"-"+arr1[2];
		
		String d5 = sz.nextToken();
		String[] arr2 = d5.split("-");
		String dt2 = arr2[0]+"-"+arr2[1]+"-"+arr2[2];
		//System.out.println(dt2);
		stmt.execute("insert into t1 values("+Integer.parseInt(d1) +","+Integer.parseInt(d2)+",'"+d3+"',TO_DATE('"+Date.valueOf(dt1)+"','YYYY-MM-DD'),TO_DATE('"+Date.valueOf(dt2)+"','YYYY-MM-DD'))");
		stmt.execute("commit");
		String d11 = sz.nextToken();
		String d21 = sz.nextToken();
		String d31 = sz.nextToken();
		String d41 = sz.nextToken();
		String d51 = sz.nextToken();
		String[] arr3 = d51.split("-");
		String dt3 = arr3[0]+"-"+arr3[1]+"-"+arr3[2];
		
		stmt.execute("insert into t2 values("+Integer.parseInt(d11) +","+Integer.parseInt(d21)+",'"+d31+"','"+d41+"',TO_DATE('"+java.sql.Date.valueOf(dt3)+"','YYYY-MM-DD'))");
		stmt.execute("commit");
		
	    }
	    br.close();
	}catch(Exception e){
	    e.printStackTrace();
	}
    }
    static void export_to_file(Connection con){
	try{
	    PreparedStatement ps1 = con.prepareStatement("select n1,n2,c1,d1,d2 from t1");
	    PreparedStatement ps2 = con.prepareStatement("select n1,n2,c1,c2,d2 from t2");
	    FileWriter fw = new FileWriter(new File("file.txt"));
	    
	    BufferedWriter bw = new BufferedWriter(fw);
	    ResultSet rs1 = ps1.executeQuery();
	    ResultSet rs2 = ps2.executeQuery();
	    String str="";
	    //if different no. of rows selected how to standardise the file format
	    while(rs1.next() && rs2.next()){
		Integer d1 = rs1.getInt(1);
		Integer d2 = rs1.getInt(2);
		String d3 = rs1.getString(3);
		java.sql.Date d4 = rs1.getDate(4);
		java.sql.Date d5 = rs1.getDate(5);
		String str1 = d1.toString()+","+d2.toString()+","+d3+","+d4.toString()+","+d5.toString();
		d1 = rs2.getInt(1);
		d2 = rs2.getInt(2);
		d3 = rs2.getString(3);
		String d6 = rs2.getString(4);
		d5 = rs2.getDate(5);
		String str2 =d1.toString()+","+d2.toString()+","+d3+","+d6.toString()+","+d5.toString();
		if(str==""){
		    str=str1+","+str2+"\n";
		}
		else{
		    str=str+str1+","+str2+"\n";
		}
		
	    }
	    bw.write(str);
	    bw.close();
	    System.out.println(str);
	    
	}catch(Exception e){
	    System.out.println(e);
	}
    }
    
    public static void main(String[] args) {
	try{
	    Class.forName("oracle.jdbc.driver.OracleDriver");
	    String URL = "jdbc:oracle:thin:@192.168.2.25:1521:orcl";
	    String USER = "BCS53";
	    String PASS = "BCS53";
	    java.sql.Connection conn = DriverManager.getConnection(URL, USER, PASS);
	    System.out.println("-----------------------------------------CONNECTED TO DATABASE--------------------------------------------");
	    conn.setAutoCommit(false);
	    System.out.println("1. IMPORT FROM FILE");
	    System.out.println("2. EXPORT TO FILE");
	    Scanner sc = new Scanner(System.in);
	    int x;
	    x = sc.nextInt();
	    if(x == 1){
		import_from_file(conn);
	    }else{
		export_to_file(conn);
	    }
	    
	}catch(Exception e){
	    e.printStackTrace();
	}
    }
}
//WORKING CODE !!!
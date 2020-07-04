<%-- 
    Document   : loggedin
    Created on : 1 Apr, 2019, 3:16:17 PM
    Author     : abdulsmapara
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String message = request.getParameter("loggedin");
    String userid = request.getParameter("userid");
    String pin = request.getParameter("pin");
    if(message == null){
	response.sendRedirect("index.jsp");
    }else{
	
    %>
<html>
    <head>
    <meta charset="UTF-8">
    <title>DBMS</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
     
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <link href="https://fonts.googleapis.com/css?family=Droid+Sans" rel="stylesheet">

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
	<style>
	    .card {
  background: #DDD;
  border-radius: 2px;
  display: inline-block;
  margin: 1rem;
  position: relative;

}

.card-5 {
  box-shadow: 0 19px 38px rgba(0,0,0,0.30), 0 15px 12px rgba(0,0,0,0.22);
}

	    </style>
    </head>
    
    <body style="background: grey;overflow-x: hidden !important">
	<br /><br /><br /><br /><br /><br /><br />
	
	<div class="row">
	    <div class="col-sm-4"></div>
	    <div class="col-sm-4">
		<div class="card card-5" style="height:content;width:100%;background: white">
		    <form action="Servlet3" method="post" style="padding:2em">
			<center><h3>UPDATE</h3></center><br />
			<input type="text" class="form-control" name="userid" placeholder="USER ID" value="<%= userid %>" readonly><br />
			<input type="text" class="form-control" name="pin" value="<%= pin %>" placeholder="NAME" READONLY><br />
			<input type="text" class="form-control" name="name" placeholder="NAME" pattern="[a-zA-Z]{3,20}" required><br />
			<input type="text" class="form-control" name="mobile" placeholder="MOBILE" pattern="[0-9]{10}" required><br />
			
		     <br />
		     <center>
			<input type="submit" value="UPDATE" class="btn btn-success" style="background: green;color:white">
		     </center>
		</form>
	    </div>
	</div>
	</div><br />
<div class="row">
	    <div class="col-sm-4"></div>
	    <div class="col-sm-4">
		<div class="card card-5" style="height:content;width:100%;background: white">
		    <form action="Servlet4" method="post" style="padding:2em">
			<center><h3>WITHDRAW</h3></center><br />
			<input type="text" class="form-control" name="userid" placeholder="USER ID" value="<%= userid %>" readonly><br />
			<input type="text" class="form-control" name="pin" value="<%= pin %>" placeholder="NAME" READONLY><br />
			<input type="number" class="form-control" name="amount" placeholder="AMOUNT" required><br />
			
		     <br />
		     <center>
			<input type="submit" value="WITHDRAW" class="btn btn-success" style="background: green;color:white">
		     </center>
		</form>
	    </div>
	</div>
	</div>

<script src='http://code.jquery.com/jquery-latest.js'></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
      
    </body>
</html>
<% } %>

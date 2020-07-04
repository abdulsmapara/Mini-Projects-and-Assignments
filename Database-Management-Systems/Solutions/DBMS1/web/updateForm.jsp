<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    
%>
<!DOCTYPE html>
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
			<center><h3>DBMS</h3></center><br />
			<input type="text" class="form-control" name="pk" placeholder="PK VALUE" required><br />
			<input type="text" class="form-control" name="colName" placeholder="COLUMN NAME FOR UPDATE" required><br />
			<input type="text" class="form-control" name="updatedVal" placeholder="UPDATED VALUE" required><br />

		     <br />
		     <center>
			<input type="submit" value="UPDATE" class="btn btn-success" style="background: green;color:white">
		     </center>
		</form>
	    </div>
	</div>
	</div>

	
    <script src='http://code.jquery.com/jquery-latest.js'></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>

    </body>
</html>

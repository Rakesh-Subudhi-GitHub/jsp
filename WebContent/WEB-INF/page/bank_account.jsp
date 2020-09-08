<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@ page impot="java.sql.*"%>
<%@page import ="java.sql.DriverManager" %>


<%!
private Connection con;
private PreparedStatement ps1,ps2;

public void jspInit(){

	//read inputs
	ServletConfig cg=null;
	String driver=null,url=null,dbuser=null,dbpws=null;
	
	try{
		//get access ServletConfig object
		cg=getServletConfig();
		
		//read init param values from web.xml file
		driver=cg.getInitParameter("driver");
		url=cg.getInitParameter("url");
		dbuser=cg.getInitParameter("user");
		dbpws=cg.getInitParameter("password");
		
		//Load driver class
		Class.forName(driver);
		
		//establish the connection
		con=DriverManager.getConnection(url,dbuser,dbpws);
		
		//create prepared statement obj
		ps1=con.prepareStatement("INSERT INTO JSP_BANK_ACCOUNT VALUES(ACC_NO_SEQ.NEXTVAL,?,?,?)");
		ps2=con.prepareStatement("SELECT ACCNO,HOLDERNAME,ADDRES,BALANCE FROM JSP_BANK_ACCOUNT");
	
	}//try
	catch(SQLException se)
	{
		se.printStackTrace();
	}

	catch(Exception e)
	{
		e.printStackTrace();
	}
	
}//init called
%>

<%
//read  special requestparam (type) value
String type=request.getParameter("type");

if(type.equalsIgnoreCase("Submit"))
		{
	   //read inputs
	   String name=null,addr=null;
	   float bal=0.0f;
	   int count=0;
	   
	   //read form data
	   name=request.getParameter("holder");
	   addr=request.getParameter("addres");
	   bal=Float.parseFloat(request.getParameter("inamt"));
	   
	   //set querry param values
	   ps1.setString(1,name);
	   ps1.setString(2,addr);
	   ps1.setFloat(3, bal);
	   
	   //execute querry
	   count=ps1.executeUpdate();
	   
	   //prosess the result
	   if(count==1)
	   {
	   %>
		   <h1 style="color:red;text-align:center"> Account opened successfully</h1>
	   <%
	   }//if
	   else
	   {
		   %>
		   <h1 style="color:red;text-align:center"> Account not opened </h1>
		   <%
	   }//else
		   
		   
		}//if

%>

<br>
<br>
<a href="form.html">HOME</a>

<%!
public void jspDestroy(){
	
	//close jdbc obj
	try{
		if(ps1!=null)
			ps1.close();
		
	}
	catch(SQLException se){
		se.printStackTrace();
		
	}
	try{
		if(ps2!=null)
			ps2.close();
		
	}
	catch(SQLException se){
		se.printStackTrace();
		
	}
	try{
		if(con!=null)
			con.close();
		
	}
	catch(SQLException se){
		se.printStackTrace();
		
	}
}
%>
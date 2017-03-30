<?xml version="1.0" ?>
<%@ page language="java" contentType="text/xml; charset=euc-kr"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.URLDecoder"%> 

<%
request.setCharacterEncoding("utf-8");
//String name = request.getParameter("name");
String name = (String)session.getAttribute("nick");
String msg = request.getParameter("msg");
String time = request.getParameter("time");
int roomNum = Integer.parseInt(request.getParameter("roomNum"));

String Sname = URLDecoder.decode(name, "UTF-8");
String Smsg = URLDecoder.decode(msg, "UTF-8");

String err = null;

Class.forName("com.mysql.jdbc.Driver");

Connection conn = null;
PreparedStatement pstmt = null;

boolean isSuccess = true;

try	{
	String jdbcDriver = "jdbc:mysql://localhost:3306/advweb?" +
							"useUnicode=true&characterEncoding=utf8";
	String dbUser = "root";
	String dbPass = "0000";
	
	conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
	
	pstmt = conn.prepareStatement(
			   "insert into chat_Game (NickName, Register_Date, Message, leadTime, Room_Num) "+
			   "values (?, now(), ?, ?, ?)");
	pstmt.setString(1, name);
	pstmt.setString(2, msg);
	pstmt.setString(3, time);
	pstmt.setInt(4, roomNum);
	
	pstmt.executeUpdate();
	}	
catch (SQLException ex){
	err = ex.getMessage();
	  isSuccess = false;
}
finally {
	if ( pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
	if ( conn != null) try { conn.close(); } catch(SQLException ex) {}
}
%>
<result>
	<code><%= isSuccess ? "success" : "Error : "+err %></code>
	<name><%=Sname %></name>
	<msg><%=Smsg %></msg>
	<time><%=time %></time>
	<num><%=roomNum %></num>
</result>
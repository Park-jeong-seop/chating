<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.util.List" %>
<%@ page import="java.net.URLDecoder"%>

<%
	List Id = new java.util.ArrayList();
	List roomnum = new java.util.ArrayList();
	String err = null;
	boolean isRoom = false;
	int count = 0;
	
	Class.forName("com.mysql.jdbc.Driver");
	
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	boolean isSuccess = true;
	
	try	{
		String jdbcDriver = "jdbc:mysql://localhost:3306/advweb?" +
								"useUnicode=true&characterEncoding=utf8";
		String dbUser = "root";
		String dbPass = "0000";
		
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
		stmt = conn.createStatement();
	
		rs = stmt.executeQuery("select * from chat_Room");
		
		//rs.last();
		//count = rs.getRow();
		//rs.beforeFirst();
		
		while(rs.next()){
			isRoom = true;
			Id.add(rs.getString("User_ID"));
			roomnum.add(rs.getInt("Room_Num"));
		}
		
		if(!isRoom){
			%>
				<script>
					alert("열려있는 채팅방이 없습니다.");
					history.go(-1);
				</script>
			<%
		}
	}	
	catch (SQLException ex){
		err = ex.getMessage();
		  isSuccess = false;
	}
	finally {
		if ( stmt != null) try { stmt.close(); } catch(SQLException ex) {}
		if ( conn != null) try { conn.close(); } catch(SQLException ex) {}
		if ( rs != null) try { rs.close(); } catch(SQLException ex) {}
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
	boolean add = false;
	int i = 0;
%>
	<div align="center">
		<div style = "width:300px; height:500px; font-size:10mm; border-width:2px; border-style:solid;">
			<div style = "height:100px; border-width:2px; border-style:solid;">
				<font size = "20px" >
					<b>
						<p align = "center" style = "margin: 20px">
							목록
						</p>
					</b>
				</font>
				<br>
			</div>
			<div>
				<% for(i=0; i<roomnum.size(); i++){%>
					<input type="button" value = "채팅창 <%=roomnum.get(i)%>"  onClick="location.href='check_participation.jsp?roomNum=<%=roomnum.get(i)%>'"
					  style = "width:300px; height:100px; font-size:20px; border-width:2px; border-style:solid;">
				<%}%>
			</div>
		</div>
	</div>

</body>
</html>
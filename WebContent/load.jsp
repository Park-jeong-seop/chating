<?xml version="1.0" ?>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/xml; charset=euc-kr"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.util.List" %>
<%@ page import="java.net.URLDecoder"%>

<%
request.setCharacterEncoding("utf-8");
int lastMsgId = Integer.parseInt(request.getParameter("lastMsgId"));
int room_num = Integer.parseInt(request.getParameter("roomNum"));
List msgList = new java.util.ArrayList();
List nickName = new java.util.ArrayList();
int Rnum =0;
String err = null;

int count =0;


Class.forName("com.mysql.jdbc.Driver");

Connection conn = null;
Statement stmt = null;
ResultSet rs = null;

int nLastMsgId = 0;

boolean isSuccess = true;

try	{
	String jdbcDriver = "jdbc:mysql://localhost:3306/advweb?" +
							"useUnicode=true&characterEncoding=utf8";
	String dbUser = "root";
	String dbPass = "0000";
	
	conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
	stmt = conn.createStatement();

	if(lastMsgId == 0){
		rs = stmt.executeQuery("select max(Message_ID) from chat_Message");
		
		if(rs.next()){
			nLastMsgId = rs.getInt(1);
		}
	}
	else{	

		rs = stmt.executeQuery("select * from chat_Message where Message_ID > "+lastMsgId+" && Room_Num = "+room_num+" order by Message_ID asc");
		//rs = stmt.executeQuery("select * from chat_Message");
		while(rs.next()){
			nickName.add(rs.getString("NickName"));
			msgList.add(rs.getString("Message"));
			nLastMsgId = rs.getInt("Message_ID");
			Rnum = rs.getInt("Room_Num");
		}
		count++;
	}
}	
catch (SQLException ex){
	err = ex.getMessage();
	  isSuccess = false;
	  System.out.println(err);
}
finally {
	if ( stmt != null) try { stmt.close(); } catch(SQLException ex) {}
	if ( conn != null) try { conn.close(); } catch(SQLException ex) {}
	if ( rs != null) try { rs.close(); } catch(SQLException ex) {}
}
%>

<result>
	<code><%= isSuccess ? "success" : "Error : "+err %></code>
	<count><%=count%></count>
	<rNum><%=Rnum%></rNum>
	<%if(isSuccess){ %>
	<nLastMsgId><%= nLastMsgId %></nLastMsgId>
	<messages>
		<% for(int i = 0; i < msgList.size(); i++){ %>
			 <message><![CDATA[<%="["+nickName.get(i)+"]"+" : "+msgList.get(i)  %>]]></message>
		<%} %>
	</messages>
	<%} %>
</result>
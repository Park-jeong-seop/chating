<?xml version="1.0" ?>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/xml; charset=euc-kr"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.util.List" %>
<%@ page import="java.net.URLDecoder"%>

<%
request.setCharacterEncoding("utf-8");
int checkCount = (int)application.getAttribute("room"+session.getAttribute("roomNum"));
System.out.println(application.getAttribute("room"+session.getAttribute("roomNum")));
int room_num = Integer.parseInt(request.getParameter("roomNum"));
List msgList = new java.util.ArrayList();
List nickName = new java.util.ArrayList();
List time = new java.util.ArrayList();
String err = null;

int count =0;

Class.forName("com.mysql.jdbc.Driver");

Connection conn = null;
Statement stmt = null;
ResultSet rs = null;

int nCheckCount = 0;

boolean isSuccess = true;

try	{
	String jdbcDriver = "jdbc:mysql://localhost:3306/advweb?" +
							"useUnicode=true&characterEncoding=utf8";
	String dbUser = "root";
	String dbPass = "0000";
	
	conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
	stmt = conn.createStatement();

	rs = stmt.executeQuery("select max(Game_ID) from chat_Game");
		
	if(rs.next()){
		nCheckCount = rs.getInt(1);
	}
		rs = stmt.executeQuery("select * from chat_Game where Game_ID > "+(nCheckCount-checkCount)+"&& Room_Num="+room_num+" order by Game_ID asc");
		//rs = stmt.executeQuery("select * from chat_Game");
		while(rs.next()){
			nickName.add(rs.getString("NickName"));
			msgList.add(rs.getString("Message"));
			time.add(rs.getString("leadTime"));
			nCheckCount = rs.getInt("Game_ID");
		}
		count++;
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

<result>
	<code><%= isSuccess ? "success" : "Error : "+err %></code>
	<count><%=count%></count>
	<%if(isSuccess){ %>
	<nLastMsgId><%= nCheckCount %></nLastMsgId>
	<messages>
		<% for(int i = 0; i < msgList.size(); i++){ %>
			 <message><![CDATA[<%="["+nickName.get(i)+"]"+" : "+msgList.get(i)  %>]]></message>
			 <time><%=time.get(i)%></time>
		<%} %>
	</messages>
	<%} %>
</result>
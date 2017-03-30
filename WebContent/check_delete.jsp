<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import = "java.sql.*" %>

<%
	request.setCharacterEncoding("utf-8");
	
	boolean isDelete = false;
	String err;
	
	Class.forName("com.mysql.jdbc.Driver");
	
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	try	{
		String jdbcDriver = "jdbc:mysql://localhost:3306/advweb?" +
								"useUnicode=true&characterEncoding=utf8";
		String dbUser = "root";
		String dbPass = "0000";
		
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
		stmt = conn.createStatement();
	
		rs = stmt.executeQuery("select * from chat_Room where User_ID = '"+session.getAttribute("id")+"'");
		while(rs.next()){
			isDelete = true;
		}
		
		if(isDelete) {
			
	    } else {
	        // DB에 내가적은 정보가 없다면 경고창을 띄워준다
	    	 %> <script> alert("내가 생성한 채팅방이 없습니다."); history.go(-1); </script> <%             
	    }
		
	}
	catch (SQLException ex){
		err = ex.getMessage();
		out.print(err);
	}
	finally {
		if ( stmt != null) try { stmt.close(); } catch(SQLException ex) {}
		if ( conn != null) try { conn.close(); } catch(SQLException ex) {}
		if ( rs != null) try { rs.close(); } catch(SQLException ex) {}
	}
%>
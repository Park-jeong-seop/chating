<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import = "java.sql.*" %>

<%
	request.setCharacterEncoding("utf-8");
	String id = request.getParameter("input_id");
	String password = request.getParameter("input_pw");	
	String nick = null;

	boolean isLogin = false;
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
	
		rs = stmt.executeQuery("select * from Member where ID = '"+id+"' AND PW='" + password + "'");
		while(rs.next()){
			nick = rs.getString("nick");
			isLogin = true;
		}
		out.print(isLogin);
		
		if(isLogin) {
	        // ���� �α����� id�� pw�� session�� �����ϰ�
	        session.setAttribute("id", id); 
	        session.setAttribute("pw", password);
	        session.setAttribute("nick", nick);
	        
	        response.sendRedirect("/Chat/Main.jsp");
	    } else {
	        // DB�� �������� ������ ���ٸ� ���â�� ����ش�
	    	 %> <script> alert("�α��� ����"); history.go(-1); </script> <%             
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
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*" %>

    <%
        // JOIN.jsp input 에서 입력한 회원가입에 필요한 값들을 변수에 담아준다
        request.setCharacterEncoding("utf-8");
		String ID = request.getParameter("JOIN_id");
		String PW = request.getParameter("JOIN_pw");
		String nick = request.getParameter("JOIN_nick");
		
		String err;
        
		Class.forName("com.mysql.jdbc.Driver");

		Connection conn = null;
		PreparedStatement pstmt = null;

		try	{
			String jdbcDriver = "jdbc:mysql://localhost:3306/advweb?" +
									"useUnicode=true&characterEncoding=utf8";
			String dbUser = "root";
			String dbPass = "0000";
			
			conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
			
			pstmt = conn.prepareStatement(
					   "insert into Member (ID, PW, nick) "+
					   "values (?, ?, ?)");
			pstmt.setString(1, ID);
			pstmt.setString(2, PW);
			pstmt.setString(3, URLEncoder.encode(nick,"UTF-8"));
			
			pstmt.executeUpdate();
			
			response.sendRedirect("login.jsp");
			}	
		catch (SQLException ex){
			err = ex.getMessage();
			out.print(err);
		}
		finally {
			if ( pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
			if ( conn != null) try { conn.close(); } catch(SQLException ex) {}
		}
		%>

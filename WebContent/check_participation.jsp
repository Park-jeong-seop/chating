<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import = "java.sql.*" %>

<%
	request.setCharacterEncoding("utf-8");
	String name = (String)session.getAttribute("nick");
	String msg	= URLEncoder.encode("참여했습니다.","UTF-8");
	int roomNum = Integer.parseInt(request.getParameter("roomNum"));
	
	System.out.println(msg);
	
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
				   "insert into chat_Message (NickName, Register_Date, Message, Room_Num) "+
				   "values (?, now(), ?, ?)");
		pstmt.setString(1, name);
		pstmt.setString(2, msg);
		pstmt.setInt(3, roomNum);
		
		pstmt.executeUpdate();
		}	
	catch (SQLException ex){
		err = ex.getMessage();
		System.out.println(err);
	}
	finally {
		if ( pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
		if ( conn != null) try { conn.close(); } catch(SQLException ex) {}
	}
	
	//채팅방 참가 처리
	request.setCharacterEncoding("utf-8");
	String roomnum = request.getParameter("roomNum");
	
	boolean isJoin = false;
	//String err;
	
	Class.forName("com.mysql.jdbc.Driver");
	
	//Connection conn = null;
	conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	try	{
		String jdbcDriver = "jdbc:mysql://localhost:3306/advweb?" +
								"useUnicode=true&characterEncoding=utf8";
		String dbUser = "root";
		String dbPass = "0000";
		
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
		stmt = conn.createStatement();
	
		rs = stmt.executeQuery("select * from chat_Room where Room_Num = '"+roomnum+"'");
		while(rs.next()){
			isJoin = true;
		}
		
		if(isJoin) {
			response.sendRedirect("/Chat/client.jsp?roomNum="+roomnum);
	    } else {
	        // DB에 내가적은 정보가 없다면 경고창을 띄워준다
	    	 %> <script> alert("채팅방이 존재하지 않습니다."); history.go(-2); </script> <%             
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
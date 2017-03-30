<%@page import="java.net.URLDecoder"%>
<%@page import="javax.print.URIException"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*" %>

	<%
		//나갔다는 메세지 보냄
		request.setCharacterEncoding("utf-8");
		String name = request.getParameter("name");
		String msg	= request.getParameter("msg");
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
			pstmt.setString(2, URLEncoder.encode(msg, "UTF-8"));
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
		//roomout 처리
		int room_count;
		int chat_room;
		room_count =  (int)application.getAttribute("room"+session.getAttribute("roomNum"));
		System.out.println("ID : "+session.getAttribute("id")+", room"+session.getAttribute("roomNum"));
		application.setAttribute("room"+session.getAttribute("roomNum"), (room_count -1));
		
		if((int)application.getAttribute("room"+session.getAttribute("roomNum")) == 0){
			chat_room =  (int)session.getAttribute("roomNum");
			
			//DB에서 채팅방 삭제
			//String err;
			Class.forName("com.mysql.jdbc.Driver");

			//Connection conn = null;
			conn = null;
			//PreparedStatement pstmt = null;
			pstmt = null;

			try	{
				String jdbcDriver = "jdbc:mysql://localhost:3306/advweb?" +
										"useUnicode=true&characterEncoding=utf8";
				String dbUser = "root";
				String dbPass = "0000";
				
				conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
				
				pstmt = conn.prepareStatement(
						   "delete from chat_Room where Room_Num="+chat_room);
				pstmt.executeUpdate();
				}	
			catch (SQLException ex){
				err = ex.getMessage();
				out.print(err);
			}
			finally {
				if ( pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
				if ( conn != null) try { conn.close(); } catch(SQLException ex) {}
			}
		}
		
		session.setAttribute("roomNum",null);
		
		response.sendRedirect("/Chat/Main.jsp");
	%>
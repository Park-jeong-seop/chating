<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*" %>

	<%
			int chat_room;
			String err;
			
			if(application.getAttribute("Room_Num") == null){
				application.setAttribute("Room_Num", 1);
				chat_room = 1;
			}
			else{
				chat_room =  (int)application.getAttribute("Room_Num") + 1;
				application.setAttribute("Room_Num", chat_room);
			}
			
	        request.setCharacterEncoding("utf-8");
	    	int room_num = (int)application.getAttribute("Room_Num");
			String user_id = (String)session.getAttribute("id");
			
	        
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
						   "insert into chat_room (Room_Num, User_ID) "+
						   "values (?, ?)");
				pstmt.setInt(1, room_num);
				pstmt.setString(2, user_id);
				
				pstmt.executeUpdate();
				
				response.sendRedirect("/Chat/client.jsp?roomNum="+room_num);
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
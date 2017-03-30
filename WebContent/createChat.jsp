<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
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
			<form action="/Chat/check_client.jsp" method="post">
			<input type="submit" value = "채팅창 생성 +" 
						style = "width:300px; height:100px; font-size:20px; border-width:2px; border-style:solid;">
			</form>
		</div>
		
	</div>
<% %>
</body>
</html>
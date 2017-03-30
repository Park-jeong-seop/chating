<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- <%@ include file="Center.jsp" %> -->
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
  <title>Document</title>
 </head>
 <body>
	<div>
		<input type = "Button" value="채팅창 생성" onClick = "top.location.href = '/Chat/check_client.jsp'" 
		style="font-size:10mm; width:100%; height:40mm">
	</div>
	</br>
	<div>
		<INPUT type="button" value="채팅창 참가"  onClick = "top.location.href = 'joinChat.jsp'"
		style="font-size:10mm; width:100%; height:40mm" />	
	 </div>
	 <br/>
	 <input type="button"  value="로그아웃" onclick="location.href='logout.jsp'" style="font-size:3mm; width:50%; height:10mm; margin-left:25%;">
 </body>
</html>

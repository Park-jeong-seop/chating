<%@ page language="java"  contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%
    request.setCharacterEncoding("euc-kr");
	System.out.println(session.getId());	
	if(session.getAttribute("id") == null && session.getAttribute("pw") == null){
		System.out.println("새로운 세션");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title> Login </title>
</head>
<body>
	<h1 align="center"> 로그인 페이지 </h1> 
	<br/><br/><br/><br/>
	<div align="center">
		<form action="/Chat/check_login.jsp" method="post" >
			<input name="input_id" type="text"> <br/><br/>
			<input name="input_pw" type="password"> <br/><br/>
			<input type="submit" value="로그인">&nbsp; <input type="button" value="회원가입" onClick="location.href='join.jsp'">
		</form>
		     
	</div>
</body>
</html>
<%}
	else{
		response.sendRedirect("/Chat/Main.jsp");
	}
%>

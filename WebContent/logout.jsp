<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%
	session.invalidate();
	%>
		<script>
			alert("�α׾ƿ� �Ǿ����ϴ�.");
			top.location.href = 'login.jsp';
		</script>
	<%
%>
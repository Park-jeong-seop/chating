<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%
    request.setCharacterEncoding("euc-kr");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title> Join </title>
</head>
<body>
    <h1 align="center"> ȸ������ </h1>
    <form action="check_join.jsp" method="post" onsubmit="return input_check_func()">
	    <table border="1" align="center">
	        <tr>
	            <th> ID </th> <td> <input type="text" id="JOIN_id" name="JOIN_id"> </td>
	        </tr>
	        <tr>
	            <th> PW </th> <td> <input type="text" id="JOIN_pw" name="JOIN_pw"> </td>
	        </tr>
	        <tr>
	            <th> Nick </th> <td> <input type="text" id="JOIN_nick" name="JOIN_nick"> </td>
	        </tr>
	    </table>
	    <br/>
	    <div align="center">
	    	<input type="submit" value="ȸ������" > 
	    </div>
    </form>
    
    <script>
    // input_check_func�� ȸ�����Կ� �ʿ��� 3���� ������ ���δ� ä�� �־����� check ���ش�
    function input_check_func() {
        var id = document.getElementById('JOIN_id').value;
        var pw = document.getElementById('JOIN_pw').value;
        var nick = document.getElementById('JOIN_nick').value;
        
        if(id == null || pw == null || nick == null || id == ""   || pw == "" || nick == "") {
            alert("�Է����� ���� �κ��� �ֽ��ϴ�.");
            return false;
        } else {
            // ��������� �����Ǹ� true�� ��ȯ�Ѵ� �̴� ���� �������� ������ action= ��ǥ�� �ѱ�ٴ°��� �ǹ�
            return true;
        }
    }    
    </script>
 
</body>
</html>

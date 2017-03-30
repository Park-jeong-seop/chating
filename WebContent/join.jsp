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
    <h1 align="center"> 회원가입 </h1>
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
	    	<input type="submit" value="회원가입" > 
	    </div>
    </form>
    
    <script>
    // input_check_func는 회원가입에 필요한 3가지 문항을 전부다 채워 넣었는지 check 해준다
    function input_check_func() {
        var id = document.getElementById('JOIN_id').value;
        var pw = document.getElementById('JOIN_pw').value;
        var nick = document.getElementById('JOIN_nick').value;
        
        if(id == null || pw == null || nick == null || id == ""   || pw == "" || nick == "") {
            alert("입력하지 않은 부분이 있습니다.");
            return false;
        } else {
            // 모든조건이 충족되면 true를 반환한다 이는 현재 페이지의 정보를 action= 좌표로 넘긴다는것을 의미
            return true;
        }
    }    
    </script>
 
</body>
</html>

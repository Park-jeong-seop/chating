<%@page import="java.util.Random"%>
<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import = "java.util.List" %>

	<%
		System.out.println("roomNum : "+request.getParameter("roomNum"));
		int room_num = Integer.parseInt(request.getParameter("roomNum"));
		int room_count;
		int count;

		session.setAttribute("roomNum", room_num);

		if(application.getAttribute("room"+session.getAttribute("roomNum")) == null){
			application.setAttribute("room"+session.getAttribute("roomNum"), 1);
			room_count = 1;
		}
		else{
			room_count =  (int)application.getAttribute("room"+session.getAttribute("roomNum")) + 1;
			application.setAttribute("room"+session.getAttribute("roomNum"), room_count);
		}
		
	%>
	
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title><%=session.getAttribute("roomNum")%> 번 채팅방</title>
<style>
</style>
<script type="text/javascript">
	var startInterval;				//로드 자동 인터벌 값
	//var SintervalFlag = false;
	var Gameflag = false;		//게임 실행 유무
	var GameSendflag = true;
	var xhr = null;					//ajax
	var LastMessageId = 0;		//마지막 메세지 ID 값
	//var LastGameId = 0;
	var timer = 0;					//타이머 지속 시간
	var countTime = 0;			//타이머 현재 시간
	var setTime = null;				//DB 저장할 타이머 값(사용자 입력시 기록)
	var checkTime;
	var cnt = 0;					//게임 진행중인 사람 수
	
	var z = 0;
	var GameText = new Array();
	GameText[0] = "호랑이를 그리려다 강아지를 그린다.";
	GameText[1] = "낫 놓고 기역자도 모른다.";
	GameText[2] = "하룻 강아지 범 무서운줄 모른다.";
	
	//ajax
	if (window.ActiveXObject)
		xhr = new ActiveXObject("Microsoft.XMLHTTP");  
	else if (window.XMLHttpRequest) {
		xhr = new XMLHttpRequest();  
		xhr.overrideMimeType("text/xml");
	}

	//메세지 전송
	function requestHello(URL){
		//게임중일 때
		if(Gameflag){
			//한번만 입력 받음
			if(GameSendflag){
				param=f.name.value;
				param2 = f.msg.value;
				URL = URL + "?name=" +  encodeURIComponent(encodeURIComponent(param))+"&msg="
						+ encodeURIComponent(encodeURIComponent(param2))+"&time="+encodeURIComponent(encodeURIComponent(setTime))+
						"&roomNum="+<%=session.getAttribute("roomNum") %>;
				
				xhr.onreadystatechange = responseHello;
				xhr.open("POST", URL, true);
				xhr.send(null);
				GameSendflag = false;
			}
		}
		//일반 채팅시 송신
		else{
			<%System.out.println("ID : "+session.getAttribute("id")+", room"+session.getAttribute("roomNum"));%>
			param=f.name.value;
			param2 = f.msg.value;
			URL = URL + "?name=" + encodeURIComponent(encodeURIComponent(param))+"&msg="
					+ encodeURIComponent(encodeURIComponent(param2))+"&roomNum="+<%=session.getAttribute("roomNum") %>;
		
			xhr.onreadystatechange = responseHello;
			xhr.open("POST", URL, true);
			xhr.send(null);
		}
	}
	
	//메세지 전송 변화 감지
	function responseHello(){
		if(xhr.readyState==4){
	  		if(xhr.status == 200){
	   			var xmlDoc = xhr.responseXML;
	   			var code = xmlDoc.getElementsByTagName("code").item(0).firstChild.nodeValue;
	   			if(code == 'success'){
	   				document.getElementById("msg").value = "";
	   			}
	   			else{
	   				alert("Send error");
	   			}
	   		}
	  		else{
	   			alert("Fail code : " + xhr.status+", message : "+xhr.responseText );
	  		}
	 	}
	}
	
	//메세지 로드
	function  loadMessage(URL) {
		URL = URL + "?lastMsgId="+LastMessageId+"&roomNum="+<%=session.getAttribute("roomNum") %>;
		xhr.open("POST", URL, true);
		xhr.onreadystatechange = loadedMessage;
		xhr.send(null);
	}
	
	//메시지 로드 변화 감지
	function loadedMessage() {
		if (xhr.readyState == 4) {
			if (xhr.status == 200) {
				var xmlDoc = xhr.responseXML;
				var code = xmlDoc.getElementsByTagName("code").item(0).firstChild.nodeValue;
				var count = xmlDoc.getElementsByTagName("count").item(0).firstChild.nodeValue;
				//document.getElementById("msgID").innerHTML = count;
				//DB select 성공시
				if(code == 'success'){
					var lastMsgId = parseInt(xmlDoc.getElementsByTagName("nLastMsgId").item(0).firstChild.nodeValue);
					
					//마지막 메세지 ID값 변경
					if (lastMsgId != 0){
						LastMessageId = lastMsgId;
					}
					var msgs = new Array();
					var messageTags = xmlDoc.getElementsByTagName("message");
					
					//메세지 값 개수 만큼 반복
					for(var j = 0; j< messageTags.length; j++){
						// ':' 기준으로 메세지 자르기
						var str = decodeURIComponent(messageTags.item(j).firstChild.nodeValue).split(':');
						// Game 을 사용자가 입력했으면
						if(str[1] == " Game"){
							//메세지 로드 중지
							clearInterval(startInterval);
							Gameflag = true;					//게임 플래그 온
							document.getElementById("msg").value = "";
							dailyMissionTimer(1/2);
							break;
						}
						//아니면 메세지 화면에 출력
						else{
							document.getElementById("message").innerHTML += decodeURIComponent(messageTags.item(j).firstChild.nodeValue)+"<br/>";
							document.getElementById("message").scrollTop = document.getElementById("message").scrollHeight;
						}
					}
				}
				else{
					document.getElementById("message").innerHTML = code;
				}
			}
			else{
				alert("Fail code : " + xhr.status+", message : "+xhr.responseText);
			}
		}	
	}
	
	//메시지 내용에 따라 전송 처리
	function checkSend(){
		var check = true;
		if(Gameflag){
			if(check){
				setTime = checkTime+"초 걸렸습니다.";
				requestHello('sendGame.jsp');
				check = false;
			}
			
		}
		//아니면 전송 후 DB에 저장
		else{
			requestHello('send.jsp');
		}
	}
	
	function gameLoad(URL){
		URL = URL + "?count="+<%=application.getAttribute("room"+session.getAttribute("roomNum"))%>+"&roomNum="+<%=session.getAttribute("roomNum")%>;
		xhr.open("POST", URL, true);
		xhr.onreadystatechange = gameLoaded;
		xhr.send(null);
	}
	
	function gameLoaded(){
		if (xhr.readyState == 4) {
			if (xhr.status == 200) {
				var xmlDoc = xhr.responseXML;
				var code = xmlDoc.getElementsByTagName("code").item(0).firstChild.nodeValue;
				
				if(code == 'success'){
					var lastgameid = parseInt(xmlDoc.getElementsByTagName("nLastMsgId").item(0).firstChild.nodeValue);
					
					var GmessageTags = xmlDoc.getElementsByTagName("message");
					var timeTags = xmlDoc.getElementsByTagName("time");
					
					//메세지 값 개수 만큼 반복
					for(var j = 0; j< GmessageTags.length; j++){
						document.getElementById("message").innerHTML += decodeURIComponent(GmessageTags.item(j).firstChild.nodeValue)+"<br/>"+
						decodeURIComponent(timeTags.item(j).firstChild.nodeValue)+"<br/>";
					}
					//chat_Game 테이블 초기화
					GameSendflag = true;
					start();
					
				}
				else{
					document.getElementById("message").innerHTML = code;
				}
			}
			else{
				alert("Fail code : " + xhr.status+", message : "+xhr.responseText);
			}
		}
	}
	
	//타이머 기능
	function dailyMissionTimer(duration) {
	    timer = duration * 20;
	    var hours, minutes, seconds, finTime = 0;
	    
	    var interval = setInterval(function(){
	        hours	= parseInt(timer / 3600, 10);
	        minutes = parseInt(timer / 60 % 60, 10);
	        seconds = parseInt(timer % 60, 10);
			
	        hours 	= hours < 10 ? "0" + hours : hours;
	        minutes = minutes < 10 ? "0" + minutes : minutes;
	        seconds = seconds < 10 ? "0" + seconds : seconds;

	        checkTime = 10-(seconds*1);
	        
	        countTime = hours+":"+minutes+":"+seconds;
	        
	        document.getElementById("time").innerHTML = countTime;
	        document.getElementById("message").innerHTML = GameText[z];
	        
	        if (--timer < 0) {
	        	z++;
	        	if(z >2){
	        		z = 0;
	        	}
	        	document.getElementById("time").innerHTML = "";
		        document.getElementById("message").innerHTML = "";
		        document.getElementById("msg").innerHTML = "";
	            timer = 0;
	            Gameflag = false;
	            clearInterval(interval);          
	            gameLoad('loadGame.jsp');
	        }
	    }, 1000);
	}
	
	//Enter 누를 시에 메시지 전송
	function doClickOnBtn1(e) {
		var event = window.event || e;
		if(event.keyCode == 13){
			checkSend();
		}
	}
	
	//자동 채팅 내역 로드
	function start(){
		startInterval = setInterval("loadMessage('load.jsp')", 1000);
	}
	
	window.onload = function(){
		var btn1 = document.getElementById("msg");
		btn1.addEventListener("keydown", doClickOnBtn1);
		start();
	}
	</script>
</head>
<body>
	<div align="center">
		<div style = "width:350px; height:50px; border-width:2px; border-style:solid; background-color: #7998b6;">
			<b align="center" id = "time" style="width: 150px; height: 100px; font-size:6mm;"> </b>
			<input type="image" src="icon_setting.png"  align="left" style="width: 40px; height: 40px; margin-top: 5px; margin-left: 5px;">
			<input type="image" src="icon_back.png" align="right" style="width: 40px; height: 40px; margin-top: 5px; margin-right: 5px;"
			 id="exit" value="나가기" onclick="location.href='room_out.jsp?name=<%=session.getAttribute("nick")%>&roomNum=<%=session.getAttribute("roomNum")%>&msg=<%=URLEncoder.encode("나갔습니다.","UTF-8")%>'">
		</div>
		<div id="message" style = "width:350px; height:500px; font-size:5mm; border-width:2px; border-style:solid; 
						 overflow-y:scroll; position: relative; text-align:left; background-color: #9bbad8;"></div>
		<form name="f" onsubmit="return false">	<!-- form 한개 있으면 enter 입력시 refresh -->
			<!--<input type="text" name="name" style = "width: 50px;"> -->
			<div style="width:350px; border-width:2px; border-style:solid; margin: 0px" align="left">
				<input type="text" value=""  id="msg" style="width:290px; height:50px; padding: 0px;">
				<input type="button"  id="btn" value="전송" onclick="checkSend()" 
									style="width:50px; height:50px; background-color: #ffec42;"><!--  "requestHello('send.jsp')"> -->
			</div>
			<br/>
			
		</form>
		<!-- 
		room_num : <%=session.getAttribute("roomNum") %> ,&nbsp; room_count : <%=application.getAttribute("room"+session.getAttribute("roomNum")) %>
		<div id="msgID" style = "width:350px; height:500px; font-size:5mm; border-width:2px; border-style:solid;"></div>
		 -->
	</div>
</body>
</html>
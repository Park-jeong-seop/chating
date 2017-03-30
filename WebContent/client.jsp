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
<title><%=session.getAttribute("roomNum")%> �� ä�ù�</title>
<style>
</style>
<script type="text/javascript">
	var startInterval;				//�ε� �ڵ� ���͹� ��
	//var SintervalFlag = false;
	var Gameflag = false;		//���� ���� ����
	var GameSendflag = true;
	var xhr = null;					//ajax
	var LastMessageId = 0;		//������ �޼��� ID ��
	//var LastGameId = 0;
	var timer = 0;					//Ÿ�̸� ���� �ð�
	var countTime = 0;			//Ÿ�̸� ���� �ð�
	var setTime = null;				//DB ������ Ÿ�̸� ��(����� �Է½� ���)
	var checkTime;
	var cnt = 0;					//���� �������� ��� ��
	
	var z = 0;
	var GameText = new Array();
	GameText[0] = "ȣ���̸� �׸����� �������� �׸���.";
	GameText[1] = "�� ���� �⿪�ڵ� �𸥴�.";
	GameText[2] = "�Ϸ� ������ �� �������� �𸥴�.";
	
	//ajax
	if (window.ActiveXObject)
		xhr = new ActiveXObject("Microsoft.XMLHTTP");  
	else if (window.XMLHttpRequest) {
		xhr = new XMLHttpRequest();  
		xhr.overrideMimeType("text/xml");
	}

	//�޼��� ����
	function requestHello(URL){
		//�������� ��
		if(Gameflag){
			//�ѹ��� �Է� ����
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
		//�Ϲ� ä�ý� �۽�
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
	
	//�޼��� ���� ��ȭ ����
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
	
	//�޼��� �ε�
	function  loadMessage(URL) {
		URL = URL + "?lastMsgId="+LastMessageId+"&roomNum="+<%=session.getAttribute("roomNum") %>;
		xhr.open("POST", URL, true);
		xhr.onreadystatechange = loadedMessage;
		xhr.send(null);
	}
	
	//�޽��� �ε� ��ȭ ����
	function loadedMessage() {
		if (xhr.readyState == 4) {
			if (xhr.status == 200) {
				var xmlDoc = xhr.responseXML;
				var code = xmlDoc.getElementsByTagName("code").item(0).firstChild.nodeValue;
				var count = xmlDoc.getElementsByTagName("count").item(0).firstChild.nodeValue;
				//document.getElementById("msgID").innerHTML = count;
				//DB select ������
				if(code == 'success'){
					var lastMsgId = parseInt(xmlDoc.getElementsByTagName("nLastMsgId").item(0).firstChild.nodeValue);
					
					//������ �޼��� ID�� ����
					if (lastMsgId != 0){
						LastMessageId = lastMsgId;
					}
					var msgs = new Array();
					var messageTags = xmlDoc.getElementsByTagName("message");
					
					//�޼��� �� ���� ��ŭ �ݺ�
					for(var j = 0; j< messageTags.length; j++){
						// ':' �������� �޼��� �ڸ���
						var str = decodeURIComponent(messageTags.item(j).firstChild.nodeValue).split(':');
						// Game �� ����ڰ� �Է�������
						if(str[1] == " Game"){
							//�޼��� �ε� ����
							clearInterval(startInterval);
							Gameflag = true;					//���� �÷��� ��
							document.getElementById("msg").value = "";
							dailyMissionTimer(1/2);
							break;
						}
						//�ƴϸ� �޼��� ȭ�鿡 ���
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
	
	//�޽��� ���뿡 ���� ���� ó��
	function checkSend(){
		var check = true;
		if(Gameflag){
			if(check){
				setTime = checkTime+"�� �ɷȽ��ϴ�.";
				requestHello('sendGame.jsp');
				check = false;
			}
			
		}
		//�ƴϸ� ���� �� DB�� ����
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
					
					//�޼��� �� ���� ��ŭ �ݺ�
					for(var j = 0; j< GmessageTags.length; j++){
						document.getElementById("message").innerHTML += decodeURIComponent(GmessageTags.item(j).firstChild.nodeValue)+"<br/>"+
						decodeURIComponent(timeTags.item(j).firstChild.nodeValue)+"<br/>";
					}
					//chat_Game ���̺� �ʱ�ȭ
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
	
	//Ÿ�̸� ���
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
	
	//Enter ���� �ÿ� �޽��� ����
	function doClickOnBtn1(e) {
		var event = window.event || e;
		if(event.keyCode == 13){
			checkSend();
		}
	}
	
	//�ڵ� ä�� ���� �ε�
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
			 id="exit" value="������" onclick="location.href='room_out.jsp?name=<%=session.getAttribute("nick")%>&roomNum=<%=session.getAttribute("roomNum")%>&msg=<%=URLEncoder.encode("�������ϴ�.","UTF-8")%>'">
		</div>
		<div id="message" style = "width:350px; height:500px; font-size:5mm; border-width:2px; border-style:solid; 
						 overflow-y:scroll; position: relative; text-align:left; background-color: #9bbad8;"></div>
		<form name="f" onsubmit="return false">	<!-- form �Ѱ� ������ enter �Է½� refresh -->
			<!--<input type="text" name="name" style = "width: 50px;"> -->
			<div style="width:350px; border-width:2px; border-style:solid; margin: 0px" align="left">
				<input type="text" value=""  id="msg" style="width:290px; height:50px; padding: 0px;">
				<input type="button"  id="btn" value="����" onclick="checkSend()" 
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
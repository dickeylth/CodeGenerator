<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>欢迎登录<s:text name="sysname" />系统
</title>
<style type="text/css">
body {
	font: normal 13px "微软雅黑", 'Microsoft Yahei', Arial, Tahoma;
	color: #666;
}

#main {
	margin: 50px 240px 0px 240px;
}

#banner {
	width: 540px;
	height: 400px;
	position: relative;
}

#banner,form {
	margin: 0 auto;
}

#bg {
	background: url(img/login.jpg) no-repeat center top #FFF;
	width: 100%;
	height: 100%;
	opacity: 0.5;
	filter: alpha(opacity =   50);
}

#banner h2 {
	background-color: #E0E0E0;
	opacity: 0.7;
	filter: alpha(opacity =   70);
	color: black;
	text-shadow: 0 2px 2px #B0B0B0;
	-moz-text-shadow: 0 2px 2px #B0B0B0;
	-webkit-text-shadow: 0 2px 2px #B0B0B0;
	box-shadow: 5px 5px 5px rgba(0, 0, 0, .4);
	position: absolute;
	bottom: 30px;
	padding: 10px;
	width: 520px;
}

form table {
	margin: 0 auto;
}

.button {
	font-family: "微软雅黑", 'Microsoft Yahei', Arial, Tahoma;
	border: 1px solid #789;
	background-color: #FFF;
	color: #0072DB;
	padding: 4px 12px;
}

.button:hover {
	background-color: #0072DB;
	color: #FFF;
	cursor: pointer;
}

.tip {
	color: red;
	text-align: right;
	width: 270px;
}
</style>
</head>
<body>
	<div id="main">
		<div id="banner">
			<div id="bg"></div>
			<h2>
				<s:text name="sysname" />
			</h2>
		</div>
		<s:form action="login" method="post" id="loginForm">
			<s:textfield name="username" key="username" />
			<s:password name="password" key="password" />
			<s:checkbox name="rememberMe" key="rememberMe" />
			<s:submit key="login" id="login" cssClass="button" />
		</s:form>
		<input type="hidden" id="tip" value="${sessionScope.tip}" />
		<script type="text/javascript"
			src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
		<script>
			$(document).ready(function(){
				$('#login').before($('<span>').addClass('tip').text($('#tip').val()));
			});
		</script>
	</div>
</body>
</html>
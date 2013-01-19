<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登录系统默认初始化页面</title>
<style type="text/css">
h3,h4 {
	font: normal 13px "微软雅黑", 'Microsoft Yahei', Arial, Tahoma;
	color: #666;
	font-weight: 500;
	font-size: 14px;
	padding-top: 30px;
	padding-left: 40px;
}
</style>
</head>
<body>
	<% Date now = new Date();pageContext.setAttribute("now", now);%>
	<h3>您好，欢迎您登录员工请假管理系统！</h3>
	<h4>
		今天是
		<s:date name="#attr.now" format="yyyy年MM月dd日" />
	</h4>
</body>
</html>
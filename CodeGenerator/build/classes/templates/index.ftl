<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>欢迎登录<s:text name="sysname" /></title>
	<link rel="stylesheet" href="css/common.css" />
	<link rel="stylesheet" href="css/index.css" />
</head>
<body>
	<div id="top">
		<h1>
			<s:text name="sysname"/>
		</h1>
	</div>
	<nav>
		<ul>
			<li><a href="<s:url action="default"/>" target="main" class="on">首页</a></li>
			
			<#list domains as domain>
				<#-- 如果不为系统管理（用户/角色/权限） -->
				<#if !(domain.name = "User" || domain.name = "Role" || domain.name = "Permission")>
			<shiro:hasPermission name="${domain.name}:manage">
				<li><a href="<s:url action="${domain.name}_queryAction"/>"
					target="main"><s:text name="${domain.name?uncap_first}"/>管理</a></li>
			</shiro:hasPermission>	
				</#if>
			</#list>
			<shiro:hasPermission name="System:manage">
				<li class="adminli"><a href="javascript:;">系统管理</a>
					<ul class="sysadmin">
						<shiro:hasPermission name="User:manage">
							<li><a href="<s:url action="User_queryAction"/>"
								target="main"><s:text name="user" />管理</a></li>
						</shiro:hasPermission>
						<shiro:hasPermission name="Role:manage">
							<li><a href="<s:url action="Role_queryAction"/>"
								target="main"><s:text name="role" />管理</a></li>
						</shiro:hasPermission>
						<shiro:hasPermission name="Permission:manage">
							<li><a href="<s:url action="Permission_queryAction"/>"
								target="main"><s:text name="permission" />管理</a></li>
						</shiro:hasPermission>
					</ul>
				</li>
			</shiro:hasPermission>
			
			<li id="account"><a href="<s:url value="logout"/>" id="logout"><s:text
						name="logout" /></a></li>
		</ul>
		<span class="greet">你好！<shiro:principal /></span>
	</nav>
	<iframe src="default.jsp" name="main" id="main"></iframe>
	<script type="text/javascript"
		src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
	<script>
		$(document).ready(function(){
			$('nav a').click(function(){
				$('nav .on').removeClass('on');
				$(this).addClass('on');
			});
			
		});
	</script>
</body>
</html>
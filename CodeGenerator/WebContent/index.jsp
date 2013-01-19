<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>欢迎使用Java EE程序代码生成器</title>
</head>
<body>
	<section id="main">
		<header>
			<h4>第1步：基本配置信息</h4>
		</header>
		<form action="dbConfig.do" method="post">
			<ul>
				<li>
					<label for="sysName">系统全称：</label>
					<input type="text" name="sysName"/>
				</li>
				<li>
					<label for="sysPackage">系统英文简称：</label>
					<input type="text" name="sysPackage"/>
				</li>
				<li>
					<label for="dbType">数据库类型：</label>
					<select name="dbType">
						<option value="mysql">MySQL</option>
						<option value="oracle">Oracle</option>
						<option value="sqlserver">Microsoft SQL Server</option>
					</select>
				</li>
				<li>
					<label for="dbUrl">数据库URL：</label>
					<input type="text" name="dbUrl"/>
				</li>
				<li>
					<label for="dbUsername">数据库用户名：</label>
					<input type="text" name="dbUsername"/>
				</li>
				<li>
					<label for="dbPassword">数据库密码：</label>
					<input type="password" name="dbPassword"/>
				</li>
				<li>
					<input type="submit" value="提交"/>
				</li>
			</ul>
		</form>
	</section>
	<s:debug></s:debug>
</body>
</html>
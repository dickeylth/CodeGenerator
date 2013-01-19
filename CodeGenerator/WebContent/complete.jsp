<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>配置完成</title>
</head>
<body>
	<h2>代码生成成功！</h2>
	<h3>下载打包文件，请点击<a href="target/${sessionScope.sysConfig.sysPackage}.zip">这里</a>。</h3>
	<h4>访问示例，请点击<a href="/${sessionScope.sysConfig.sysPackage}">${sessionScope.sysConfig.sysName}</a>。</h4>
	<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
	<script type="text/javascript">
	$(document).ready(function(){
		
	]});
	</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>第二步：数据库设计</title>
</head>
<body>
	<section id="main">
		<header>
			<h4>第2步：数据库设计文件</h4>
		</header>
		<form action="domainXmlUpload.do" enctype="multipart/form-data" method="post">
			<ul>
				<li>
					<label for="upload">选择XML文件</label>
					<input type="file" name="upload" />
				</li>
			</ul>
			<ul>
				<li>
					<input type="submit" value="提交"/>
				</li>
			</ul>
		</form>
	</section>
</body>
</html>
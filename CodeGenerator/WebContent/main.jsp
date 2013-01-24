<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML>
<html>
<head>
	<meta charset="UTF-8">
	<title>SSH2 + Shiro 程序代码生成器</title>
	<link rel="shortcut icon" href="img/favicon.ico">
	<link rel="stylesheet" type="text/css" href="css/standalone.css"/>
	<link rel="stylesheet" type="text/css" href="css/scrollable-wizard.css"/>
	<!-- a little more standalone page styling 
	<style>
	  body {
	  background-color:#234;
	  padding-top:5%;
	  }
	</style>
	-->
	<script src="js/jquery.tools.min.js"></script>
	<script src="js/ajaxfileupload.js"></script>
</head>
<body>
<div id="drawer">
  请输入<samp style="color:red">红框</samp>内的内容！
</div>

 <div id="wizard">
   <ul id="status">
     <li class="active"><strong>1.</strong> 项目&amp;环境信息</li>
     <li><strong>2.</strong> 业务模型</li>
     <li><strong>3.</strong> 完成</li>
   </ul>
   <div class="items">
     <!-- page1 -->
     <div class="page">
     	<h2>
		  <strong>第一步: </strong> 配置项目与数据库基本信息
		</h2>
		<form action="#" method="post">
			<ul>
			  <!-- sysName -->
			  <li class="required">
			    <label>
			      <strong>1.</strong> 系统全称 <br />
			      <input type="text" class="text" name="config.sysName" />
			      <em>您希望创建的系统全名</em>
			    </label>
			  </li>
	
			  <!-- dbType -->
			  <li class="required">
			    <label>
			      <strong>2.</strong> 数据库类型 <br />
			      <select name="config.dbType">
			      	<option value="">---请选择---</option>
			      	<option value="mysql">MySQL</option>
			      	<option value="oracle">Oracle</option>
			      	<option value="sqlserver">Microsoft SQL Server</option>
			      </select>
			    </label>
			  </li>
			  
			  <!-- dbUrl -->
			  <li class="required">
			    <label>
			      <strong>3.</strong> 数据库URL <br />
			      <input type="text" class="text" name="config.dbUrl" />
			    </label>
			  </li>
			  
			  <!-- dbUsername -->
			  <li class="required">
			    <label>
			      <strong>4.</strong> 数据库用户名 <br />
			      <input type="text" class="text" name="config.dbUsername" />
			    </label>
			  </li>
			  
			  <!-- dbPassword -->
			  <li class="required">
			    <label>
			      <strong>5.</strong> 数据库密码 <br />
			      <input type="text" class="text" name="config.dbPassword" />
			    </label>
			  </li>
	
			  <li class="clearfix">
			    <button type="button" class="next right" data-action="sysConfig.do" id="sysConfigSubmit">下一步 &raquo;</button>
			  </li>
			</ul>
		</form>
    </div>
    <!-- page2 -->
    <div class="page">
	<h2>
	  <strong>第二步: </strong> 导入业务模型定义文档 <b></b>
	</h2>
	<form action="#" enctype="multipart/form-data" method="post">
		<ul>
		  <!-- domain.xml -->
		  <li class="required">
		    <label>上传模型定义xml文件 <span>*</span><br />
		      <input type="file" class="file" name="upload" id="upload"/>
		    </label>
		  </li>
	
		  <li class="clearfix">
		    <button type="button" class="prev" style="float:left">
	              &laquo; 上一步
	            </button>
		    <button type="button" class="next right" data-action="xmlUpload.do" id="xmlUploadSubmit">
	              下一步 &raquo;
	            </button>
		  </li>
		</ul>
	</form>
    </div>

    <!-- page3 -->
    <div class="page">
		<h2>
		  <strong>第三步: </strong> 系统创建 <b></b>
		</h2>
		<div id="wrap">
			<div id="display">
				<div id="progress"></div>
				<div id="finish">
					<h3><a class="target" href=";">立即访问系统</a></h3>
					<h4>您也可以<a class="targetFile" href=";">下载系统打包文件</a></h4>
				</div>
			</div>
		</div>		
	
     </div>

   </div><!--items-->

 </div><!--wizard-->
<s:debug></s:debug>
<script>
$(function() {
	var root = $("#wizard").scrollable();
  
    // some variables that we need
    var api = root.scrollable(), drawer = $("#drawer");

    // validation logic is done inside the onBeforeSeek callback
    api.onBeforeSeek(function(event, i) {
    	
	    // we are going 1 step backwards so no need for validation
	    if (api.getIndex() < i) {
	    	// 1. get current page
	    	var page = root.find(".page").eq(api.getIndex()),
	    	// 2. .. and all required fields inside the page
	    	inputs = page.find(".required :input").removeClass("error"),
	    	// 3. .. which are empty
			empty = inputs.filter(function() {
				 return $(this).val().replace(/\s*/g, '') == '';
			});
	    	// if there are empty fields, then
	    	if (empty.length) {
	    		// slide down the drawer
	    		drawer.slideDown(function() {
	    		// colored flash effect
	    		drawer.css("backgroundColor", "#229").data('state', 'error');
	    		setTimeout(function() { 
	    			drawer.css("backgroundColor", "#fff"); }, 1000);
				});
	    		// add a CSS class name "error" for empty & required fields
	    		empty.addClass("error");
	    		// cancel seeking of the scrollable by returning false
	    		return false;
	    		// everything is good
	    	} else {
	    		// hide the drawer
				drawer.slideUp().data('state', 'success');
	    	}
		}
	    // update status bar
	    $("#status li").removeClass("active").eq(i).addClass("active");
	});
                         
	// if tab is pressed on the next button seek to next page
	root.find("button.next").keydown(function(e) {
	    if (e.keyCode == 9) {
		    // seeks to next tab by executing our validation routine
		    api.next();
		    e.preventDefault();
		    $(this).click();
		}
    });
	
	$('#sysConfigSubmit').click(function(e){
		if(drawer.data('state') == 'success'){
			$.post(
				$(this).data('action'),
				$(this).closest('form').serialize(),
				function(msg){
					console.log(msg);
					$('.target').attr('href', '/' + msg.config.sysPackage);
					$('.targetFile').attr('href', 'target/' + msg.config.sysPackage + ".zip");
				}
			);
		}
	});
	
	$('#xmlUploadSubmit').click(function(e){
		if(drawer.data('state') == 'success'){
			$.ajaxFileUpload({
			  url:$(this).data('action'),			//服务器端程序
			  secureuri:false,
			  fileElementId:'upload',					//input框的ID
			  dataType: 'json',//返回数据类型
			  success: function (ret, status){ 	//服务器成功响应处理函数
                  console.log(ret);				//从服务器返回的json中取出message中的数据, 其中message为在struts2中action中定义的成员变量
                  if(ret.message != ''){
                	  alert(ret.message);
                  }else{
                	  callback();
                  }
              },
              error: function (data, status, e){//服务器响应失败处理函数
                  alert(e);
              }
			});		
		}
	});
	
	function query(){
		$.getJSON(
			'queryProgress.do',
			'',
			function(msg){
				if(msg.status != 1){
					if($.trim(msg.content) != $.trim($('#progress h4:last').text())){
						$('#progress').html($('#progress').html() + "<h4>" + msg.content + "</h4>");
					}
					setTimeout(query, 500);
				}
			}
		);	
	}
	
	function callback(){
		$.ajax(
			'codeGen.do',
			{
				data: '',
				beforeSend: function(xhr, settings){
					query(xhr);
				},
				success: function(data, textStatus, jqXHR){
					setTimeout("$('#display').animate({left:'-=500'}, 'slow');", 10000);
					return;
				}
			}
		);
	}

});
</script>
</body>
</html>
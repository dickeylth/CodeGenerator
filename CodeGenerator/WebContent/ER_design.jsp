<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>第二步：数据库设计</title>
	<script src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
	<script src="js/dot.js"></script>
</head>
<body>
	<section id="main">
		<header>
			<h4>第2步：数据库设计</h4>
		</header>
		<nav>
			<ul class="ctrls">
				<li><input type="button" id="add_table" value="新建表"/></li>
				<li><input type="button" id="edit_table" value="编辑表" disabled="disabled"/></li>
				<li><input type="file" id="import_table" value="从XML文件导入"/></li>
			</ul>
		</nav>
		<div id="table_div">
			<ul class="tablelist">
				<li>users</li>
			</ul>
		</div>
	</section>
	<input type="hidden" id="domain_json" value="${session.domain }"/>
	<input type="hidden" id="tables_info" value=""/>
	<script type="text/html" id="table_info">
	<table>
		<thead>
			<h4><input type="text" id="{{=it.tablename}}.name" value="{{=it.tablename}}"/></h4>
			<tr>
				<td>列名</td>
				<td>类型</td>
				<td>可为空</td>
				<td>主键</td>
				<td>关联外键</td>
			</tr>
		</thead>
		<tbody>
			{{~it.columns:col}}
			<tr data-id="col.name">
				<td><input type="text" id="{{=col.name}}.name" value="{{=col.name}}"/></td>
				<td>
					<select id="{{=col.name}}.type">
						{{~it.columtypes:type}}
						<option {{? col.type == type}}selected="selected"{{?}}>{{=type}}</option>
						{{~}}
					</select>
				</td>
				<td>
					<input type="checkbox" {{? col.empty}}checked="checked"{{?}}/>
				</td>
				<td {{? col.pk}}class="pk"{{?}}>
				</td>
				<td>
					<select id="{{=col.name}}.ref">
						{{? !col.ref_table}}
						<option selected="selected"></option>
						{{?}}
						{{~it.curtables:table}}
						<option {{? col.ref_table == table}}selected="selected"{{?}}>{{=table}}</option>
						{{~}}
					</select>
					<select id="{{=col.name}}.ref">
						{{? !col.ref_table_col}}
						<option selected="selected">{{=col.ref_table_col}}</option>
						{{?}}
					</select>
					<select id="{{=col.name}}.ref">
						{{? !col.ref_type}}
						<option selected="selected">{{=col.ref_type}}</option>
						{{?}}
					</select>
				</td>
			</tr>
			{{~}}
		</tbody>
		<tfoot>
			<tr>
				<td><input type="button" id="add_col" value="添加列"/></td>
				<td><input type="button" id="del_col" value="删除列"/></td>
				
<td><input type="button" id="insert_col" value="当前列后插入列"/></td>
			</tr>
		</tfoot>
	</table>
	</script>
	<script src="js/domain.js"></script>
</body>
</html>
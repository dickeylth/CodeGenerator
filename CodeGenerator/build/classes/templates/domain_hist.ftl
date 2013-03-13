<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="css/iframe.css" />
</head>
<body>
	<div class="breadcrumb">
		<div class="adminli"><a href="javascript:;">${domain.cnName}管理</a>
			<ul class="sysadmin">
				<li><a href="<s:url action="${domain.name}_queryAction"/>" target="main">我的申请</a></li>
				<li><a href="<s:url action="${domain.name}_queryTaskAction"/>" target="main">我的任务</a></li>
				<li><a href="<s:url action="${domain.name}_queryHistAction"/>" target="main">历史任务</a></li>
			</ul>
		</div>
		<img src="img/seperator.png" style="float:left;width:13px;height:33px">
		<span class="breaditem">历史任务</span>
	</div>
	<form id="options" method="post">
		<table>
			<thead>
				<tr>
					<td></td>
					<td><s:text name="${domain.name?uncap_first}.id"/></td>
					<#list domain.displayProps as property>
						<#if property.refDomainPo??>
					<td><s:text name="${property.name}.${property.refDomainPo.refDisplayProp}"/></td>
						<#else>
					<td><s:text name="${domain.name?uncap_first}.${property.name}" /></td>
						</#if>
					</#list>
					<td>状态</td>
				</tr>
			</thead>
			<tbody>
				<s:iterator value="models" id="model">
					<tr>
						<td><input type="checkbox" name="checkItems" class="check"
							value="<s:property value="#model.id"/>" /></td>
						<td><a
							href="<s:url action='${domain.name}_editAction'><s:param name='id' value='#model.id'/></s:url>"><s:property
									value="#model.id" /></a></td>
						<#list domain.displayProps as property>
							<#if property.refDomainPo??>
						<td><s:property value="#model.${property.name}.${property.refDomainPo.refDisplayProp}"/></td>
							<#elseif property.type = "Date">
						<td><s:date name="#model.${property.name}" format="yyyy-MM-dd"/></td>
							<#else>
						<td><s:property value="#model.${property.name}"/></td>
							</#if>
						</#list>
						<td><s:property value="#model.bizWorkflow.status" /></td>
					</tr>
				</s:iterator>
			</tbody>
		</table>
	</form>
	<script type="text/javascript"
		src="js/jquery-1.8.3.min.js"></script>
	<script>
		$(document).ready(function(){

		});
	</script>
</body>
</html>
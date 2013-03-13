<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="css/iframe.css" />
</head>
<body>
	<#assign sysDomains = ["User", "Role", "Permission"]/>
	<#if sysDomains?seq_contains(domain.name)>
	<div class="breadcrumb">
		<shiro:hasPermission name="system:manage">
			<div class="adminli"><a href="javascript:;">系统管理</a>
				<ul class="sysadmin">
					<shiro:hasPermission name="user:manage">
						<li><a href="<s:url action="User_queryAction"/>"
							target="main"><s:text name="user" />管理</a></li>
					</shiro:hasPermission>
					<shiro:hasPermission name="role:manage">
						<li><a href="<s:url action="Role_queryAction"/>"
							target="main"><s:text name="role" />管理</a></li>
					</shiro:hasPermission>
					<shiro:hasPermission name="permission:manage">
						<li><a href="<s:url action="Permission_queryAction"/>"
							target="main"><s:text name="permission" />管理</a></li>
					</shiro:hasPermission>
				</ul>
			</div>
		</shiro:hasPermission>
		<img src="img/seperator.png" style="float:left;width:13px;height:33px">
		<span class="breaditem"><s:text name="permission" />管理</span>
	</div>
	</#if>
	<#if domain.processName??>
	<div class="breadcrumb">
		<div class="adminli"><a href="javascript:;">${domain.cnName}管理</a>
			<ul class="sysadmin">
				<li><a href="<s:url action="${domain.name}_queryAction"/>" target="main">我的申请</a></li>
				<li><a href="<s:url action="${domain.name}_queryTaskAction"/>" target="main">我的任务</a></li>
				<li><a href="<s:url action="${domain.name}_queryHistAction"/>" target="main">历史任务</a></li>
			</ul>
		</div>
		<img src="img/seperator.png" style="float:left;width:13px;height:33px">
		<span class="breaditem">我的申请</span>
	</div>
	</#if>
	
	<form id="search" method="post" action="${domain.name}_queryByPropAction.do">
		<s:select list="properties" id="property" name="property" headerKey=""
			headerValue="--选择搜索字段--" value="property" />
		<input type="text" name="keyword" id="keyword" value="<#noparse>${keyword}</#noparse>"/>
		<input type="submit" id="search_btn" class="button" value="<s:text name='search'/>" />
	</form>
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
					<#if domain.processName??>
					<td>状态</td>
					<td>操作</td>
					</#if>
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
						<#if domain.processName??>
						<td><s:property value="#model.bizWorkflow.status" /></td>
						<td>
							<s:if test="%{#model.bizWorkflow.step == 0}">
								<a href="<s:url action='${domain.name}_applyAction'><s:param name='id' value='#model.id'/></s:url>">申请</a>
							</s:if>
						</td>
						</#if>
					</tr>
				</s:iterator>
			</tbody>
		</table>
		<ul>
			<shiro:hasPermission name="${domain.name?uncap_first}:add">
				<li><input type="submit" value="新增" id="add"
					data-action="${domain.name}_addAction.do?<#noparse>refClass=${refClass}&refId=${refId}</#noparse>"
					class="ctrl button" /></li>
			</shiro:hasPermission>
			<shiro:hasPermission name="${domain.name?uncap_first}:delete">
				<li><input type="submit" value="删除" id="delete"
					data-action="${domain.name}_deleteAction.do?<#noparse>refClass=${refClass}&refId=${refId}</#noparse>"
					class="ctrl button" /></li>
			</shiro:hasPermission>
		</ul>
	</form>
	<script type="text/javascript"
		src="js/jquery-1.8.3.min.js"></script>
	<script>
		$(document).ready(function(){
			$('.ctrl').click(function(){
				//删除确认
				if($(this).attr('id') == "delete"){
					if(!confirm("您确定要删除选中记录吗？")){
						return;
					}
				}
				$(this).closest('form').attr('action',$(this).data('action')).submit();
			});
			
		});
	</script>
</body>
</html>
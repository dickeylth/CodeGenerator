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
							<#else>
						<td><s:property value="#model.${property.name}"/></td>
							</#if>
						</#list>
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
				$('form').attr('action',$(this).data('action')).submit();
			});
			
		});
	</script>
</body>
</html>
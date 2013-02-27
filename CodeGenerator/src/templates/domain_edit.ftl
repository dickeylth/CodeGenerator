<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>编辑</title>
	<link rel="stylesheet" href="css/iframe.css" />
</head>
<body style="display: none">
	<div class="breadcrumb">
		<div class="adminli">
			<a href="javascript:history.go(-1);" class="back">返回</a>
		</div>
	</div>
	<h3>
		<#noparse>${title}</#noparse><s:text name="${domain.name?uncap_first}"/>
	</h3>
	<s:form action="${domain.name}_editSubmitAction" method="post" id="editForm">
		<s:hidden name="refClass" value="%{refClass}" />
		<s:hidden name="refId" value="%{refId}" />
		<s:hidden name="model.id" id="model_id" value="%{model.id}" />
		
		<#list domain.properties as property>
			<#-- 处理关联关系 -->
			<#if property.refDomainPo??>
				<#assign refType = property.refDomainPo.refType/>
				<#if refType = "many-to-one" && property.refDomainPo.refDomain != "User">
		
		<!-- 多对一 -->
		<s:bean name="${package}.dao.impl.${property.refDomainPo.refDomain}DaoImpl" id="${property.name}Dao"/>
		<s:select list="#${property.name}Dao.all" name="model.${property.name}.id" value="%{model.${property.name}.id}" 
			listKey="id" listValue="${property.refDomainPo.refDisplayProp}" 
			key="${domain.name?uncap_first}.${property.name}" <#if property.nullable = "true"> headerKey="" headerValue="--请选择--" </#if>/>
			
				<#elseif refType = "many-to-many">
		
		<!-- 多对多 -->	
		<s:bean name="${package}.dao.impl.${property.refDomainPo.refDomain}DaoImpl" id="${property.name}Dao"/>
		<s:checkboxlist list="#${property.name}Dao.all" name="model.${property.name}" value="model.${property.name}.{id}" 
			listKey="id" listValue="${property.refDomainPo.refDisplayProp}" 
			key="${domain.name?uncap_first}.${property.name}" cssClass="checkboxlist"/>	
				
				<#elseif refType = "one-to-one" || refType = "one-to-many">
				
		<!-- 一对一/一对多 -->
		<s:if test="model.id != null">
			<s:url id="${property.name}_url" 
				<#if refType = "one-to-one">
				action="${property.refDomainPo.refDomain}_editAction"
				<#else>
				action="${property.refDomainPo.refDomain}_queryByRefAction" 
				</#if>
				escapeAmp="false">
				<s:param name="refClass">${domain.name}</s:param>
				<s:param name="refId"><#noparse>${model.id}</#noparse></s:param>
			</s:url>
			<s:textfield cssClass="text_url" value="%{${property.name}_url}"
				key="${domain.name?uncap_first}.${property.name}" />
		</s:if>
				</#if>
				
			<#else>
				<#if property.plural = true>
		<!-- 集合类型 -->
		<s:hidden name="model.${property.name}" value="%{model.${property.name}}" cssClass="collections"/>
		<s:label key="${domain.name?uncap_first}.${property.name}"/>
		
				<#elseif property.pk = false>
		<!-- 基本类型 -->
		<s:textfield name="model.${property.name}" value="%{model.${property.name}}"
			key="${domain.name?uncap_first}.${property.name}" />
		
				</#if>
			</#if>
		</#list>
		<#if domain.processName??>
		<s:if test="model.id == null || model.bizWorkflow.step == 0">
			<s:submit id="submit" key="submit" cssClass="button" />
		</s:if>
		<#else>
		<s:submit id="submit" key="submit" cssClass="button" />
		</#if>
	</s:form>
	<iframe src="" name="view" id="view"></iframe>
	<a id="close">×</a>
	<script src="js/jquery-1.8.3.min.js"></script>
	<script src="js/edit.js"></script>
</body>
</html>
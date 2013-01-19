<?xml version="1.0" encoding="UTF-8"?>
<!-- 指定Struts2配置文件的DTD信息 -->
<!DOCTYPE struts PUBLIC
	"-//Apache Software Foundation//DTD Struts Configuration 2.1.7//EN"
	"http://struts.apache.org/dtds/struts-2.1.7.dtd">
<!-- Struts2配置文件的根元素 -->
<struts>
	<!-- 配置了系列常量 -->
	<constant name="struts.custom.i18n.resources" value="resource" />
	<constant name="struts.i18n.encoding" value="UTF-8" />
	<constant name="struts.action.extension" value="do"/>
	
	
	<package name="default" extends="struts-default" namespace="/">

		<!-- 定义全局结果 -->
		<global-results>
			<result name="unauthorized">/unauthorized.jsp</result>
			<result name="unauthenticated">/unauthenticated.jsp</result>
		</global-results>
		<!-- 定义全局异常映射 -->
		<global-exception-mappings>
			<exception-mapping result="unauthorized"
				exception="org.apache.shiro.authz.UnauthorizedException" />
			<exception-mapping result="unauthenticated"
				exception="org.apache.shiro.authz.UnauthenticatedException" />
		</global-exception-mappings>

		<action name="*_*Action" class="${package}.action.{1}Action"
			method="{2}">
			<result name="input">{1}/edit.jsp</result>
			<result>{1}/index.jsp</result>
		</action>

		<!-- 默认的action处理 -->
		<action name="*">
			<result>/{1}.jsp</result>
		</action>
	</package>
</struts>
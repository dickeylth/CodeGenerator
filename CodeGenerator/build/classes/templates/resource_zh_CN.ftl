sysname=${sysConfig.sysName}

username=用户名
password=密码
login=登录
rememberMe=记住我
submit=提交
logout=登出
search=搜索

<#list domains as domain>

${domain.name?uncap_first}=${domain.cnName}
	<#list domain.properties as property>
${domain.name?uncap_first}.${property.name}=${property.cnName}
	</#list>

</#list>
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:aop="http://www.springframework.org/schema/aop"
	xmlns:p="http://www.springframework.org/schema/p" xmlns:tx="http://www.springframework.org/schema/tx"
	xsi:schemaLocation="http://www.springframework.org/schema/beans 
	http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
	http://www.springframework.org/schema/tx
	http://www.springframework.org/schema/tx/spring-tx-3.0.xsd
	http://www.springframework.org/schema/aop
	http://www.springframework.org/schema/aop/spring-aop-3.0.xsd">

	<!-- 配置Hibernate的信息 -->
	<!-- 定义数据源Bean，使用C3P0数据源实现 -->
	<!-- 设置连接数据库的驱动、URL、用户名、密码 连接池最大连接数、最小连接数、初始连接数等参数 -->
	<bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource"
		destroy-method="close" 
		p:driverClass="${sysConfig.dbDriver}"
		p:jdbcUrl="${sysConfig.dbUrl}" 
		p:user="${sysConfig.dbUsername}"
		p:password="${sysConfig.dbPassword}" 
		p:maxPoolSize="40" 
		p:minPoolSize="1"
		p:initialPoolSize="1" 
		p:maxIdleTime="20" />

	<!-- 定义Hibernate的SessionFactory -->
	<!-- 依赖注入数据源，注入正是上面定义的dataSource -->
	<bean id="sessionFactory"
		class="org.springframework.orm.hibernate3.annotation.AnnotationSessionFactoryBean"
		p:dataSource-ref="dataSource">
		<!-- packagesToScan属性用来列出需要映射的注解类所在的包 -->
		<property name="packagesToScan" value="${package}.domain" />
		<!-- 定义Hibernate的SessionFactory的属性 -->
		<property name="hibernateProperties">
			<!-- 指定数据库方言、是否自动建表、是否生成SQL语句等 -->
			<value>
				hibernate.dialect=${sysConfig.dbDialect}
				hibernate.hbm2ddl.auto=update
				hibernate.show_sql=false
			</value>
		</property>
		<!-- 映射JBPM中的资源 -->
		<property name="mappingResources">
			<list>
				<value>jbpm.repository.hbm.xml</value>
	            <value>jbpm.execution.hbm.xml</value>
	            <value>jbpm.history.hbm.xml</value>
	            <value>jbpm.task.hbm.xml</value>
	            <value>jbpm.identity.hbm.xml</value>
			</list>
		</property>
	</bean>

	<!-- 配置Hibernate的局部事务管理器，使用HibernateTransactionManager类 -->
	<!-- 该类实现PlatformTransactionManager接口，是针对Hibernate的特定实现 -->
	<!-- 并注入SessionFactory的引用 -->
	<bean id="transactionManager"
		class="org.springframework.orm.hibernate3.HibernateTransactionManager"
		p:sessionFactory-ref="sessionFactory" />
	<tx:advice id="txAdvice" transaction-manager="transactionManager">
		<tx:attributes>
			<!-- 以find开头的方法使用只读事务 -->
			<tx:method name="find*" read-only="true" />
			<!-- 其他方法可读写 -->
			<tx:method name="*" />
		</tx:attributes>
	</tx:advice>
	<aop:config>
		<aop:pointcut expression="bean(userService)" id="pointCut" />
		<aop:advisor advice-ref="txAdvice" pointcut-ref="pointCut" />
	</aop:config>



	<bean id="daoTemplate" abstract="true" p:sessionFactory-ref="sessionFactory" />
	<#list domains as domain>
	<bean id="${domain.name?uncap_first}Dao" class="${package}.dao.impl.${domain.name}DaoImpl" parent="daoTemplate" />
	</#list>
	<bean id="userService" class="${package}.service.impl.UserServiceImpl"
		<#list domains as domain>
		p:${domain.name?uncap_first}Dao-ref="${domain.name?uncap_first}Dao" 
		</#list>
		p:repositoryService-ref="repositoryService"
		p:executionService-ref="executionService"
		p:taskService-ref="taskService"
		p:historyService-ref="historyService"
	/>
	<bean id="userSession" class="${package}.jbpm.UserSession" p:userDao-ref="userDao"/>

	<!-- Shiro的配置信息 -->
	<bean id="securityManager" class="org.apache.shiro.web.mgt.DefaultWebSecurityManager">
		<!-- 单realm应用。如果有多个realm，使用‘realms’属性代替 -->
		<property name="realm" ref="sampleRealm" />
		<property name="cacheManager" ref="cacheManager" />
	</bean>
	<bean id="shiroAuthFilter" class="${package}.security.ShiroAuthFilter">
		<property name="userService" ref="userService"></property>
	</bean>
	<bean id="shiroFilter" class="org.apache.shiro.spring.web.ShiroFilterFactoryBean">
		<property name="securityManager" ref="securityManager" />
		<property name="loginUrl" value="/login.do" />
		<property name="unauthorizedUrl" value="/unauth.jsp" />
		<property name="filters">
			<map>
				<entry key="authc" value-ref="shiroAuthFilter" />
			</map>
		</property>
		<property name="filterChainDefinitions">
			<value>
				/login.jsp = anon
				/login* = authc
				/logout = logout
				/js/* = anon
				/css/* = anon
				/img/* = anon
				/** = authc
			</value>
		</property>
	</bean>
	<bean id="cacheManager" class="org.apache.shiro.cache.ehcache.EhCacheManager" />
	<bean id="sampleRealm" class="org.apache.shiro.realm.jdbc.JdbcRealm">
		<property name="dataSource" ref="dataSource" />
		<property name="authenticationQuery" value="select password from user where username = ?" />
		<property name="userRolesQuery"
			value="select r.name from user_role ur left join role r on ur.role_id = r.id left join user u on ur.user_id = u.id where u.username = ? " />
		<property name="permissionsQuery"
			value="select p.name from role r left join role_permission rp on rp.role_id = r.id left join permission p on rp.permission_id = p.id where r.name = ? " />
		<property name="permissionsLookupEnabled" value="true" />
		<property name="saltStyle" value="NO_SALT" />
		<property name="credentialsMatcher" ref="hashedCredentialsMatcher" />
	</bean>
	<bean id="hashedCredentialsMatcher"
		class="org.apache.shiro.authc.credential.HashedCredentialsMatcher">
		<property name="hashAlgorithmName" value="MD5" />
		<property name="storedCredentialsHexEncoded" value="true" />
		<property name="hashIterations" value="1" />
	</bean>
	<bean id="lifecycleBeanPostProcessor" class="org.apache.shiro.spring.LifecycleBeanPostProcessor" />

	<!-- 开启Shiro注解的Spring配置方式的beans。在lifecycleBeanPostProcessor之后运行 -->
	<bean
		class="org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator"
		depends-on="lifecycleBeanPostProcessor" />
	<bean
		class="org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor">
		<property name="securityManager" ref="securityManager" />
	</bean>

	<!--jbpm4.4工作流  -->
	<bean id="springHelper" class="org.jbpm.pvm.internal.processengine.SpringHelper" lazy-init="default" autowire="default">
		<property name="jbpmCfg" value="jbpm.cfg.xml" />
	</bean>
	<bean id="processEngine" factory-bean="springHelper"  factory-method="createProcessEngine" />
	<bean id="repositoryService" factory-bean="processEngine" factory-method="getRepositoryService"/>
	<bean id="executionService" factory-bean="processEngine" factory-method="getExecutionService" />
	<bean id="taskService" factory-bean="processEngine" factory-method="getTaskService" />
	<bean id="historyService" factory-bean="processEngine" factory-method="getHistoryService" />

</beans>
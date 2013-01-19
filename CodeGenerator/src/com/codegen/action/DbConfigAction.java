package com.codegen.action;

import java.util.Map;

import org.apache.struts2.interceptor.SessionAware;

import com.codegen.domain.SysConfig;
import com.opensymphony.xwork2.Action;
import com.opensymphony.xwork2.ModelDriven;

public class DbConfigAction implements Action, ModelDriven<SysConfig>, SessionAware{
	
	//定义用于处理封装请求参数和处理结果的模型
	private SysConfig config = new SysConfig();
	//定义用于缓存数据的Session
	private Map<String, Object> session;
	
	public String execute() throws Exception{
		System.out.println(config);
		switch (config.getDbType()) {
		case "mysql":
			config.setDbDriver("com.mysql.jdbc.Driver");
			config.setDbDialect("org.hibernate.dialect.MySQL5InnoDBDialect");
			break;
		case "oracle":
			config.setDbDriver("oracle.jdbc.driver.OracleDriver");
			config.setDbDialect("org.hibernate.dialect.OracleDialect");
			break;
		case "sqlserver":
			config.setDbDriver("com.microsoft.jdbc.sqlserver.SQLServerDriver");
			config.setDbDialect("org.hibernate.dialect.SQLServerDialect");
			break;
		default:
			break;
		}
		session.put("sysConfig", config);
		return SUCCESS;
	}

	@Override
	public SysConfig getModel() {
		return config;
	}

	@Override
	public void setSession(Map<String, Object> session) {
		this.session = session;
	}
	
}

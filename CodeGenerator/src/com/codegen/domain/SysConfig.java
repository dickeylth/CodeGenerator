package com.codegen.domain;

public class SysConfig {
	//系统中文名
	private String sysName;
	//系统英文名
	private String sysPackage;
	//数据库类型
	private String dbType;
	//数据库URL
	private String dbUrl;
	//数据库用户名
	private String dbUsername;
	//数据库密码
	private String dbPassword;
	//数据库driver
	private String dbDriver;
	//数据库方言
	private String dbDialect;
	
	public String getSysName() {
		return sysName;
	}

	public void setSysName(String sysName) {
		this.sysName = sysName;
	}

	public String getSysPackage() {
		return sysPackage;
	}

	public void setSysPackage(String sysPackage) {
		this.sysPackage = sysPackage;
	}

	public String getDbType() {
		return dbType;
	}

	public void setDbType(String dbType) {
		this.dbType = dbType;
	}

	public String getDbUrl() {
		return dbUrl;
	}

	public void setDbUrl(String dbUrl) {
		this.dbUrl = dbUrl;
	}

	public String getDbUsername() {
		return dbUsername;
	}

	public void setDbUsername(String dbUsername) {
		this.dbUsername = dbUsername;
	}

	public String getDbPassword() {
		return dbPassword;
	}

	public void setDbPassword(String dbPassword) {
		this.dbPassword = dbPassword;
	}

	public String getDbDriver() {
		return dbDriver;
	}

	public void setDbDriver(String dbDriver) {
		this.dbDriver = dbDriver;
	}

	public String getDbDialect() {
		return dbDialect;
	}

	public void setDbDialect(String dbDialect) {
		this.dbDialect = dbDialect;
	}

	@Override
	public String toString() {
		return "SysConfig [sysName=" + sysName + ", sysPackage=" + sysPackage
				+ ", dbType=" + dbType + ", dbUrl=" + dbUrl + ", dbUsername="
				+ dbUsername + ", dbPassword=" + dbPassword + ", dbDriver="
				+ dbDriver + ", dbDialect=" + dbDialect + "]";
	}


}

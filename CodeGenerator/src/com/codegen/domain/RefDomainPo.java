/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.codegen.domain;

/**
 *
 * @author 铁行
 */
public class RefDomainPo{

	//关联类
	private String refDomain;
	//关联类型（一对一/一对多/多对多）
    private String refType;
    //关联类显示字段
    private String refDisplayProp;
    //连接表名（只对一对一 & 多对多）
    private String joinTable;
    //连接列（只对一对一 & 多对多）
    private String joinColumn;
    //连接对端列（只对一对一 & 多对多）
    private String inverseJoinColumn;
    
    public String getRefDomain() {
		return refDomain;
	}
	public void setRefDomain(String refDomain) {
		this.refDomain = refDomain;
	}	
	public String getRefType() {
		return refType;
	}
	public void setRefType(String refType) {
		this.refType = refType;
	}	
	public String getRefDisplayProp() {
		return refDisplayProp;
	}
	public void setRefDisplayProp(String refDisplayProp) {
		this.refDisplayProp = refDisplayProp;
	}
	

	public String getJoinTable() {
		return joinTable;
	}
	public void setJoinTable(String joinTable) {
		this.joinTable = joinTable;
	}
	public String getJoinColumn() {
		return joinColumn;
	}
	public void setJoinColumn(String joinColumn) {
		this.joinColumn = joinColumn;
	}
	public String getInverseJoinColumn() {
		return inverseJoinColumn;
	}
	public void setInverseJoinColumn(String inverseJoinColumn) {
		this.inverseJoinColumn = inverseJoinColumn;
	}
	
	public RefDomainPo(String refDomain, String refType, String refDisplayProp) {
		super();
		this.refDomain = refDomain;
		this.refType = refType;
		this.refDisplayProp = refDisplayProp;
	}
	
	@Override
	public String toString() {
		return "RefDomainPo [refDomain=" + refDomain + ", refType=" + refType
				+ ", refDisplayProp=" + refDisplayProp + ", joinTable="
				+ joinTable + ", joinColumn=" + joinColumn
				+ ", inverseJoinColumn=" + inverseJoinColumn + "]";
	}
	
	
}

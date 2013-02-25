/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.codegen.domain;

import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author 铁行
 */
public class DomainPo {

	//映射类名
    private String name;
    //映射类的中文名
    private String cnName;
    //映射类是否与User相关联
    private boolean userRelated = false;
    //映射类关联的流程名
    private String processName;
    //映射类的属性集合
    private List<PropertyPo> properties = new LinkedList<PropertyPo>();

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCnName() {
		return cnName;
	}

	public void setCnName(String cnName) {
		this.cnName = cnName;
	}

	public List<PropertyPo> getProperties() {
		return properties;
	}

	public void setProperties(List<PropertyPo> properties) {
		this.properties = properties;
	}

	public boolean isUserRelated() {
		return userRelated;
	}

	public void setUserRelated(boolean userRelated) {
		this.userRelated = userRelated;
	}
	
	public String getProcessName() {
		return processName;
	}

	public void setProcessName(String processName) {
		this.processName = processName;
	}

	//获取该domain下的基本类型字段&多对一&一对一映射字段（排除User），在edit页面
	public String getDisplayFields(){
		String ret = "";
		for (PropertyPo property : this.properties) {
			RefDomainPo refDomainPo = property.getRefDomainPo();
			if(!property.isPlural() && (refDomainPo == null 
					|| refDomainPo.getRefType().equals("one-to-one")
					|| refDomainPo.getRefType().equals("many-to-one")
					&& refDomainPo.getRefDomain() != "User")){
				ret += "\"" + property.getName() + "\",";
			}
		}
		return ret.substring(0, ret.length()-1);
	}
	
	//获取该domain下的基本类型字段&多对一&一对一映射字段（排除id），在index页面
	public List<PropertyPo> getDisplayProps(){
		List<PropertyPo> propList = new LinkedList<PropertyPo>();
		for (PropertyPo property : this.properties) {
			RefDomainPo refDomainPo = property.getRefDomainPo();
			if(!property.isPlural() && !property.getName().equals("id") 
					&& (refDomainPo == null 
					|| refDomainPo.getRefType().equals("one-to-one")
					|| refDomainPo.getRefType().equals("many-to-one"))){
				propList.add(property);
			}
		}
		return propList;
	}
	
	public DomainPo(String name, String cnName, String processName, List<PropertyPo> properties) {
		super();
		this.name = name;
		this.cnName = cnName;
		this.processName = processName;
		this.properties = properties;
	}

	@Override
	public String toString() {
		return "DomainPo [name=" + name + ", cnName=" + cnName
				+ ", isUserRelated=" + userRelated 
				+ ", processName=" + processName 
				+ ", properties=" + properties + "]";
	}
}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.codegen.domain;

/**
 *
 * @author 铁行
 */
public class PropertyPo {

	//属性名
    private String name;
    //属性中文名
    private String cnName;
    //属性类型
    private String type;
    //属性是否为主键，默认非主键
    private boolean pk = false;
    //属性值是否可为空，默认可为空，采用字符串便于Freemarker输出布尔值
    private String nullable = "true";
    //属性值是否唯一，默认不唯一，采用字符串便于Freemarker输出布尔值
    private String unique = "false";
    //属性值是否为集合，默认非集合
    private boolean plural = false;
    //与当前属性关联的类，默认为null
    private RefDomainPo refDomainPo = null;
    
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
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public boolean isPk() {
		return pk;
	}
	public void setPk(boolean pk) {
		this.pk = pk;
	}
	public String getNullable() {
		return nullable;
	}
	public void setNullable(String nullable) {
		this.nullable = nullable;
	}
	public String getUnique() {
		return unique;
	}
	public void setUnique(String unique) {
		this.unique = unique;
	}
	public boolean isPlural() {
		return plural;
	}
	public void setPlural(boolean plural) {
		this.plural = plural;
	}
	public RefDomainPo getRefDomainPo() {
		return refDomainPo;
	}
	public void setRefDomainPo(RefDomainPo refDomainPo) {
		this.refDomainPo = refDomainPo;
	}
	
	
	
	public PropertyPo(String name, String cnName, String type) {
		super();
		this.name = name;
		this.cnName = cnName;
		this.type = type;
	}
	
	
	@Override
	public String toString() {
		return "PropertyPo [name=" + name + ", cnName=" + cnName + ", type="
				+ type + ", pk=" + pk + ", nullable=" + nullable + ", unique="
				+ unique + ", plural=" + plural + ", refDomainPo="
				+ refDomainPo + "]";
	}    
    
}

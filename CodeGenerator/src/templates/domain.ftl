package ${package}.domain;

import java.util.List;
import java.util.LinkedList;
import java.io.Serializable;
import javax.persistence.*;

import java.util.Date;
<#if domain.name != "Role">
import org.jbpm.api.identity.Group;
</#if>

import org.hibernate.annotations.GenericGenerator;

@Entity
public class ${domain.name} implements Serializable<#if domain.name != "Role">, Group</#if> {

	/**
	 * serialVersionUID
	 */
	private static final long serialVersionUID = 1L;
	
	<#-- 定义各属性 -->
	<#list domain.properties as property>
	<#-- 如果为主键 -->
	<#if property.pk = true>
	//主键
	@Id
		<#if domain.name != "Role">
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
		</#if>
	private String id;
	<#-- 如果有关联类，表明非基本数据类型 -->
	<#elseif property.refDomainPo??>
	//${property.cnName}
		<#-- 多对一 -->
		<#if property.refDomainPo.refType = "many-to-one">
	@ManyToOne(cascade=CascadeType.MERGE)
	@JoinColumn(name="${property.type}_id", unique=${property.unique}, nullable=${property.nullable}<#if property.refDomainPo.refDomain = "User">, updatable = false</#if>)
	private ${property.type} ${property.name};
		<#-- 多对多 -->
		<#elseif property.refDomainPo.refType = "many-to-many">
	@ManyToMany(cascade = CascadeType.REFRESH)
	@JoinTable(name = "${property.refDomainPo.joinTable}",
	joinColumns = {@JoinColumn(name = "${property.refDomainPo.joinColumn}")},
	inverseJoinColumns = {@JoinColumn(name = "${property.refDomainPo.inverseJoinColumn}")})
	private List<${property.refDomainPo.refDomain}> ${property.name} = new LinkedList<${property.refDomainPo.refDomain}>();
		<#-- 一对一 -->
		<#elseif property.refDomainPo.refType = "one-to-one">
	@OneToOne(cascade = CascadeType.PERSIST)
	@JoinTable(name = "${property.refDomainPo.joinTable}",
	joinColumns = { @JoinColumn(name = "${property.refDomainPo.joinColumn}") },
	inverseJoinColumns = { @JoinColumn(name = "${property.refDomainPo.inverseJoinColumn}") })
	private ${property.refDomainPo.refDomain} ${property.name};
		<#-- 一对多 -->
		<#elseif property.refDomainPo.refType = "one-to-many">
	@OneToMany(cascade = CascadeType.PERSIST, mappedBy="${domain.name?uncap_first}")
	private List<${property.refDomainPo.refDomain}> ${property.name} = new LinkedList<${property.refDomainPo.refDomain}>();
		</#if>
	<#else>
	//${property.cnName}
		<#if property.plural = true>
	@ElementCollection
	private List<${property.type}> ${property.name} = new LinkedList<${property.type}>();
		<#else>
	@Column(unique=${property.unique}, nullable=${property.nullable})
	private ${property.type} ${property.name};
		</#if>
	</#if>
	</#list>
	
	<#if domain.processName??>
	//流程状态
	@OneToOne(cascade = CascadeType.ALL)
	private BizWorkflow bizWorkflow;
	</#if>
	
	<#-- 定义各属性Getter & Setter -->
	<#list domain.properties as property>
		<#if property.plural = false>
	public ${property.type} get${property.name?cap_first}(){
		return ${property.name};
	}
	
	public void set${property.name?cap_first}(${property.type} ${property.name}){
		this.${property.name} = ${property.name};
	}	
		<#else>
	public List<${property.type}> get${property.name?cap_first}(){
		return ${property.name};
	}
	
	public void set${property.name?cap_first}(List<${property.type}> ${property.name}){
		this.${property.name} = ${property.name};
	}	
		</#if>
	</#list>
	
	<#if domain.processName??>
	public BizWorkflow getBizWorkflow() {
		return bizWorkflow;
	}

	public void setBizWorkflow(BizWorkflow bizWorkflow) {
		this.bizWorkflow = bizWorkflow;
	}
	</#if>
	
	<#-- 由于角色需要与jbpm用户体系整合，需要对Role类进行定制 -->
	<#if domain.name == "Role">
	@Override
	public String getName() {
		return rolename;
	}

	@Override
	public String getType() {
		return "candidate";
	}
	</#if>
}
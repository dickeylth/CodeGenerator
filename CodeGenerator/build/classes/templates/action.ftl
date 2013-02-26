package ${package}.action;

import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

<#if domain.processName != null>
import org.jbpm.api.history.HistoryTask;
import org.jbpm.api.task.Task;
</#if>


import ${package}.action.base.BaseAction;
import ${package}.domain.*;
import com.opensymphony.xwork2.ActionContext;

<#if domain.name = "User">
import org.apache.shiro.crypto.hash.Md5Hash;
</#if>

public class ${domain.name}Action extends BaseAction{

	/**
	 * 默认序列化UID
	 */
	private static final long serialVersionUID = 1L;
	
	//需要编辑的model的id
	private String id = "";
	
	//模型驱动的实例
	private ${domain.name} model = new ${domain.name}();
	
	//删除时的选中项的id
	private String[] checkItems;
	
	//搜索可用的字段
	private String[] fields = {${domain.displayFields}};
	private Map<String, String> properties = new HashMap<String, String>();
	
	//搜索时的字段类别
	private String property;
	
	//搜索时的关键字
	private String keyword;
	
	//页面标题
	private String title;
	
	//当前用户
	private User user = (User) ActionContext.getContext().getSession().get("user");
	
	//关联查询的类
	private String refClass;
	
	//关联查询的类的id
	private String refId;
	
	//查询出的实例集
	private List<${domain.name}> models = new LinkedList<${domain.name}>();
	
	
	/*
	 * 按字段查询
	 */
	public String queryByProp(){
		initQuery();
		setModels(userService.find${domain.name}sByProp(property, keyword, user));
		return SUCCESS;
	}
	
	/*
	 * 查询
	 */
	public String query(){
		initQuery();
		<#if domain.userRelated = true>
		setModels(userService.find${domain.name}sByUser(user));
		<#else>
		setModels(userService.find${domain.name}s());
		</#if>
		
		return SUCCESS;
	}
	
	<#if domain.processName != null>
	/*
	 * 查询流程任务
	 */
	public String queryTask(){
		initQuery();
		//遍历业务表，为各业务entry设置taskId，以传给后续审批用
		List<${domain.name}> ${domain.name?uncap_first}s = new LinkedList<${domain.name}>();
		Map<String, Task> tasks = userService.getTaskList("${domain.name}", user);
		Iterator<Entry<String, Task>> iterator = tasks.entrySet().iterator();
		while (iterator.hasNext()) {
			Map.Entry<String, Task> entry = (Map.Entry<String, Task>) iterator.next();
			${domain.name} ${domain.name?uncap_first} = userService.find${domain.name}(entry.getKey());
			${domain.name?uncap_first}.getBizWorkflow().setTaskId(entry.getValue().getId());
			${domain.name?uncap_first}s.add(${domain.name?uncap_first});
		}
		setModels(${domain.name?uncap_first}s);
		return "task";
	}
	
	/*
	 * 查询流程历史任务
	 */
	public String queryHist(){
		initQuery();
		//遍历业务表，为各业务entry设置taskId，以传给后续审批用
		List<${domain.name}> ${domain.name?uncap_first}s = new LinkedList<${domain.name}>();
		Map<String, HistoryTask> tasks = userService.getHistTaskList(user);
		Iterator<Entry<String, HistoryTask>> iterator = tasks.entrySet().iterator();
		while (iterator.hasNext()) {
			Map.Entry<String, HistoryTask> entry = (Map.Entry<String, HistoryTask>) iterator.next();
			${domain.name} ${domain.name?uncap_first} = userService.find${domain.name}(entry.getKey());
			${domain.name?uncap_first}.getBizWorkflow().setTaskId(entry.getValue().getId());
			${domain.name?uncap_first}s.add(${domain.name?uncap_first});
		}
		setModels(${domain.name?uncap_first}s);
		return "hist";
	}
	</#if>
	
	/*
	 * 关联查询
	 */
	public String queryByRef(){
		initQuery();
		if(refClass != null && refId != null){
			setModels(userService.find${domain.name}sByRef(toLowerFirst(refClass), refId));
		}else{
			System.err.println("RefClass或RefId为空！");
		}
		
		return SUCCESS;
	}
	
	/*
	 * 加载增加页面
	 */
	public String add(){
		title = "创建新";
		
		return INPUT;
	}
	
	/*
	 * 加载修改页面
	 */
	public String edit(){
		title = "编辑";
		
		if(!id.trim().isEmpty()){
			model = userService.find${domain.name}(id);
		}else if(refClass != null && refId != null){
			refClass = refClass.trim();
			refId = refId.trim();
			if(!refClass.equals("") && !refId.equals("")){
				List<${domain.name}> list = userService.find${domain.name}sByRef(toLowerFirst(refClass), refId);
				if(!list.isEmpty()){
					model = list.get(0);
				}
			}
		}
		if(model !=null && model.getBizWorkflow() != null && model.getBizWorkflow().getStep() != 0){
			title = "查看";
		}
		
		<#if domain.name = "User">
		/**
		 * 针对密码，特殊处理，缓存当前编辑用户密码到session中供提交时比对
		 */
		ActionContext.getContext().getSession().put("pwd", model.getPassword());
		</#if>
		
		return INPUT;
	}
	
	<#if domain.processName != null>
	/*
	 * 处理流程申请
	 */
	public String apply() throws Exception{
		String processInstanceId = userService.procApply("${domain.processName}", "${domain.name}", id, user);
		updateBizStatus("申请单已提交", true, processInstanceId);
		return query();
	}
	
	/*
	 * 处理流程批准
	 */
	public String approve() throws Exception{
		updateBizStatus(userService.procApprove(taskId, user), true, null);
		return "task";
	}
	
	/*
	 * 处理流程驳回
	 */
	public String reject() throws Exception{
		updateBizStatus(userService.procReject(taskId, user), false, null);
		return "task";
	}
	
	/**
	 * 处理流程中业务数据状态更新
	 * @param String status 状态名
	 * @param boolean direction 审批通过？驳回
	 * @param String processInstanceId 流程实例id，仅在申请时绑定
	 */
	private void updateBizStatus(String status, boolean direction, String processInstanceId){
		${domain.name} ${domain.name?uncap_first} = userService.find${domain.name}(id);
		${domain.name?uncap_first}.getBizWorkflow().setStatus(status);
		if(processInstanceId != null){
			${domain.name?uncap_first}.getBizWorkflow().setProcessInstanceId(processInstanceId);
		}
		
		if(direction){
			${domain.name?uncap_first}.getBizWorkflow().stepForward();
		}else{
			${domain.name?uncap_first}.getBizWorkflow().stepBackword();
		}
		userService.update${domain.name}(${domain.name?uncap_first});
	}
	</#if>
	
	/*
	 * 处理增加/修改
	 */
	public String editSubmit(){
	
		<#if domain.name = "User">
		/*
		 * 针对密码，特殊处理，比对前后密码是否有修改，有修改时才重新加密
		 */
		Object pwd = ActionContext.getContext().getSession().get("pwd");
		if(pwd == null || !pwd.equals(model.getPassword())){
			String crypto = new Md5Hash(model.getPassword()).toHex(); 
			model.setPassword(crypto);
		}
		</#if>

		//一对一关联提交中的标识位
		boolean flag = false;
		<#list domain.properties as property>
			<#if property.refDomainPo??>
				<#assign refDomainPo = property.refDomainPo>
				<#-- 多对一 -->
				<#if refDomainPo.refType = "many-to-one">
		//处理多对一关联的${refDomainPo.refDomain}
		if(model.get${refDomainPo.refDomain}() != null){
			String id = model.get${refDomainPo.refDomain}().getId();
			if(id != null && !id.equals("")){
				model.set${refDomainPo.refDomain}(userService.find${refDomainPo.refDomain}(id));
			}
		}
				<#-- 多对多 -->
				<#elseif refDomainPo.refType = "many-to-many">
		//处理多对多关联的${refDomainPo.refDomain}绑定
		List<${refDomainPo.refDomain}> ${refDomainPo.refDomain?uncap_first}List = new LinkedList<${refDomainPo.refDomain}>();
 		for (${refDomainPo.refDomain} it : model.get${refDomainPo.refDomain}s()) {
 			if(it != null && it.getId() != null){
 				${refDomainPo.refDomain} ${refDomainPo.refDomain?uncap_first} = userService.find${refDomainPo.refDomain}(it.getId());
 				${refDomainPo.refDomain?uncap_first}List.add(${refDomainPo.refDomain?uncap_first});
 			}
 		}
 		model.set${refDomainPo.refDomain}s(${refDomainPo.refDomain?uncap_first}List);
				<#-- 一对一 -->
				<#elseif refDomainPo.refType = "one-to-one">
		//处理一对一关联的${refDomainPo.refDomain}绑定
		if(refClass != null && refId != null){
			if(refClass.trim().equals("${refDomainPo.refDomain}") && !refId.trim().equals("")){	
				model.set${refDomainPo.refDomain}(userService.find${refDomainPo.refDomain}(refId.trim()));
				flag = true;
			}
		}
				</#if>
			</#if>
		</#list>
		
		<#if domain.userRelated = true>
		//处理用户关联
		if(model.getUser() == null){
			model.setUser(user);
		}
		</#if>
		
		if(model.getId().equals("")){
			//处理新建
			<#if domain.processName != null>
			model.setBizWorkflow(new BizWorkflow());
			</#if>
			userService.add${domain.name}(model);
		}else{
			//处理更新
			<#if domain.processName != null>
			model.setBizWorkflow(userService.find${domain.name}(model.getId()).getBizWorkflow());
			</#if>
			userService.update${domain.name}(model);
		}
		return flag ? queryByRef() : query();
	}
	
	/*
	 * 处理删除
	 */
	public String delete(){
		//是否有关联类操作
		boolean flag = refClass != null && refId != null && !refClass.trim().equals("") && !refId.trim().equals("");
				
		for (String id : checkItems) {
			userService.delete${domain.name}(id);
		}
		return flag ? queryByRef() : query();
	}
	
	/*
	 * 初始化搜索字段
	 */
	private void initQuery(){
		for (String field : fields) {
			properties.put(field, getText("${domain.name?uncap_first}." + field));
		}
	}
	
	
	/*
	 * Getters 和 Setters
	 */
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public ${domain.name} getModel() {
		return model;
	}

	public void setModel(${domain.name} model) {
		this.model = model;
	}

	public String[] getCheckItems() {
		return checkItems;
	}

	public void setCheckItems(String[] checkItems) {
		this.checkItems = checkItems;
	}

	public Map<String, String> getProperties() {
		return properties;
	}

	public void setProperties(Map<String, String> properties) {
		this.properties = properties;
	}

	public String getProperty() {
		return property;
	}

	public void setProperty(String property) {
		this.property = property;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getRefClass() {
		return refClass;
	}

	public void setRefClass(String refClass) {
		this.refClass = refClass;
	}

	public String getRefId() {
		return refId;
	}

	public void setRefId(String refId) {
		this.refId = refId;
	}

	public List<${domain.name}> getModels() {
		return models;
	}

	public void setModels(List<${domain.name}> models) {
		this.models = models;
	}


}

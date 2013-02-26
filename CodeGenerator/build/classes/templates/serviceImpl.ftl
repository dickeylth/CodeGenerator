package ${package}.service.impl;

import java.io.File;
import java.io.FilenameFilter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.jbpm.api.ExecutionService;
import org.jbpm.api.HistoryService;
import org.jbpm.api.ProcessDefinition;
import org.jbpm.api.ProcessInstance;
import org.jbpm.api.RepositoryService;
import org.jbpm.api.TaskService;
import org.jbpm.api.history.HistoryTask;
import org.jbpm.api.task.Task;

import ${package}.domain.*;
import ${package}.dao.*;
import ${package}.service.UserService;


public class UserServiceImpl implements UserService {

	<#list domains as domain>
	//${domain.cnName}Dao及Getter & Setter
	private ${domain.name}Dao ${domain.name?uncap_first}Dao;
	public ${domain.name}Dao get${domain.name}Dao(){
		return ${domain.name?uncap_first}Dao;
	}
	public void set${domain.name}Dao(${domain.name}Dao ${domain.name?uncap_first}Dao){
		this.${domain.name?uncap_first}Dao = ${domain.name?uncap_first}Dao;
	}
	
	//${domain.cnName}的基本CRUD方法
	<#if domain.name = "User">
	/**
	 * 根据用户名查找用户
	 */
	@Override
	public User findUserByName(String username) {
		return userDao.findUserByName(username);
	}
	</#if>

	/**
	 * 新增${domain.cnName}
	 */
	@Override
	public String add${domain.name}(${domain.name} ${domain.name?uncap_first}){
		return ${domain.name?uncap_first}Dao.save(${domain.name?uncap_first});
	}

	/**
	 * 删除${domain.cnName}
	 */
	@Override
	public void delete${domain.name}(${domain.name} ${domain.name?uncap_first}){
		${domain.name?uncap_first}Dao.delete(${domain.name?uncap_first});
	}

	/**
	 * 删除${domain.cnName}
	 */
	@Override
	public void delete${domain.name}(String id){
		${domain.name?uncap_first}Dao.delete(id);
	}
	
	/**
	 * 更新${domain.cnName}
	 */
	@Override
	public void update${domain.name}(${domain.name} ${domain.name?uncap_first}){
		${domain.name?uncap_first}Dao.update(${domain.name?uncap_first});
	}
	
	/**
	 * 根据id查找${domain.cnName}
	 */
	@Override
	public ${domain.name} find${domain.name}(String id){
		return ${domain.name?uncap_first}Dao.get(id);
	}
	
	/**
	 * 查找出所有${domain.cnName}
	 */
	@Override
	public List<${domain.name}> find${domain.name}s(){
		return ${domain.name?uncap_first}Dao.getAll();
	}
	
	/**
	 * 根据属性值模糊查找${domain.cnName}
	 */
	@Override
	public List<${domain.name}> find${domain.name}sByProp(String property, String keyword, User user){
		return ${domain.name?uncap_first}Dao.findByProp(property, keyword, user);
	}
	
	/**
	 * 根据关联类查找${domain.cnName}
	 */
	@Override
	public List<${domain.name}> find${domain.name}sByRef(String refClass, String refId){
		return ${domain.name?uncap_first}Dao.findByRef(refClass, refId);
	}
	
	<#if domain.userRelated = true>
	/**
	 * 查找用户关联的所有${domain.cnName}
	 */
	@Override
	public List<${domain.name}> find${domain.name}sByUser(User user){
		return ${domain.name?uncap_first}Dao.findByUser(user);
	}
	
	</#if>
	</#list>
	
	
	/**
	 * JBPM相关Getters和Setters
	 */
	<#list ["RepositoryService", "ExecutionService", "TaskService", "HistoryService"] as service>
	private ${service} ${service?uncap_first};
	public void set${service}(${service} ${service?uncap_first}){
		this.${service?uncap_first} = ${service?uncap_first};
	}
	public ${service} get${service}(){
		return ${service?uncap_first};
	}
	
	</#list>
	
	/*
	 * 处理流程部署
	 */
	@Override
	public void checkProcessDeploy(){
		//获取当前系统中已部署流程
		List<ProcessDefinition> definitions = repositoryService.createProcessDefinitionQuery().list();
		List<String> processList = new LinkedList<>();
		boolean flag = false;
		if(definitions.isEmpty()){
			flag = true;
		}else{
			for (ProcessDefinition processDefinition : definitions) {
				processList.add(processDefinition.getName());
			}
		}

		//遍历jpdl目录下流程定义文件，检查每个文件是否已被部署过
		List<File> files = getProcessFiles();
		for (File file : files) {
			String name = file.getName().substring(0, file.getName().indexOf("."));
			if(flag || !processList.contains(name)){
				//未被部署，执行流程部署操作
				deployProcess(file);
			}
		}
	}
	/*
	 * 获取jpdl目录下所有流程定义xml文件
	 */
	private List<File> getProcessFiles(){
		File dir = new File(getClass().getResource("/jpdl").getFile());
		File[] files = {};
		if(dir.exists()){
			files = dir.listFiles(new FilenameFilter() {
				
				@Override
				public boolean accept(File dir, String name) {
					return name.endsWith(".jpdl.xml");
				}
			});
		}
		
		return Arrays.asList(files);
	}
	/*
	 * 执行流程定义xml文件部署到系统
	 */
	private void deployProcess(File file){
		String deployId = repositoryService.createDeployment().addResourceFromFile(file).deploy();
		System.out.println("流程定义文件" + file.getName() + "已部署，id为：" + deployId);
	}

	/**
	 * 获取当前角色任务列表
	 * @param String bizName 业务名
	 * @param User user 用户
	 * @return Map<业务id, Task>
	 */
	@Override
	public Map<String, Task> getTaskList(String bizName, User user){
		Map<String, Task> tasks = new HashMap<>();
		List<Task> taskList = taskService.findGroupTasks(user.getId());
		for (Task task : taskList) {
			String bizId = (String) taskService.getVariable(task.getId(), bizName + "Id");
			tasks.put(bizId, task);
		}
		return tasks;
	}
	
	/**
	 * 获取当前角色历史任务列表
	 * @param User user 用户
	 * @return Map<业务id, Task>
	 */
	@Override
	public Map<String, HistoryTask> getHistTaskList(User user){
		Map<String, HistoryTask> tasks = new HashMap<>();
		List<HistoryTask> taskList = historyService.createHistoryTaskQuery().assignee(user.getId()).list();
		for (HistoryTask task : taskList) {
			//要求流程设计中不可有分支，这样才能保证executionId与processInstanceId是一致的
			String bizId = historyService.createHistoryProcessInstanceQuery().processInstanceId(task.getExecutionId()).uniqueResult().getKey();
			tasks.put(bizId, task);
		}
		return tasks;
	}
	
	/**
	 * 流程-处理申请
	 * @param String processName 流程名
	 * @param String bizName 业务名
	 * @param String bizId 业务id
	 * @param User user 业务执行用户
	 * @return String 状态信息
	 */
	@Override
	public String procApply(String processName, String bizName, String bizId, User user) throws Exception{
		//流程中要用到的变量信息
		Map<String, Object> variables = new HashMap<String, Object>();
		//存放该流程实例关联的业务表id
		variables.put(bizName + "Id", bizId);
		//存放该流程实例关联的用户角色
		variables.put("role", getProperRole(user, bizName));
		
		//启动流程，通过该业务id来绑定一个流程实例
		ProcessInstance processInstance = executionService.startProcessInstanceByKey(processName, variables, bizId);
		//该表单到时候是在web页面进行申请时填写好的
		System.out.println("申请单已填写：" + processInstance.isActive("填写申请单"));
		//处理申请单填写任务，申请单填写任务在流程定义文件中要求写死为assignee="formFillin"
		String taskId = taskService.findPersonalTasks("formFillin").get(0).getId();
		taskService.completeTask(taskId);
		
		//返回申请单（业务数据）的状态以更新
		return processInstance.getId();
		
	}
	
	//根据用户和业务名返回合适的角色，处理用户-角色多对多关联与流程中角色决策路径问题
	private String getProperRole(User user, String bizName) throws Exception{
		List<Role> roles = findUser(user.getId()).getRoles();
		if(roles.size() == 1){
			return roles.get(0).getRolename();
		}else{
			for (Role role : roles) {
				List<Permission> permissions = role.getPermissions();
				for (Permission permission : permissions) {
					//如果permission中有与业务名吻合的部分，表明该permission对应的role即为所需
					if(permission.getPermission().indexOf(bizName) != -1){
						return role.getRolename();
					}
				}
			}
			throw new Exception("该角色可能与该业务流程未绑定，请确认后再执行！");
		}
		
	}
	
	/**
	 * 流程-处理批准
	 * @param String taskId 任务id
	 * @return String 业务状态
	 */
	@Override
	public String procApprove(String taskId, User user) throws Exception{
		//处理批准任务
		String activeStatus = taskService.getTask(taskId).getActivityName();
		taskService.takeTask(taskId, user.getId());
		taskService.completeTask(taskId, "批准");
		
		//修改申请单（业务数据）的状态
		return activeStatus + "已批准";
	}
	
	/**
	 * 流程-处理驳回
	 * @param String taskId 任务id
	 * @return String 业务状态
	 */
	@Override
	public String procReject(String taskId, User user) throws Exception{
		//处理批准任务
		String activeStatus = taskService.getTask(taskId).getActivityName();
		taskService.takeTask(taskId, user.getId());
		taskService.completeTask(taskId, "驳回");
		
		//修改申请单（业务数据）的状态
		return activeStatus + "已驳回";
	}
	
}

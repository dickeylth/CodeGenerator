package ${package}.service;

import java.util.List;

import ${package}.domain.*;

import org.jbpm.api.history.HistoryTask;
import org.jbpm.api.task.Task;

public interface UserService {

	/**
	 * 根据用户名查找用户
	 * @param username 用户名
	 * @return 查找到的用户实例
	 */
	User findUserByName(String username);
	
	<#list domains as domain>
	/**
	 * 新增${domain.cnName}
	 * @param ${domain.name?uncap_first} 新增${domain.cnName}的${domain.name}实例
	 * @return 新增${domain.cnName}的主键
	 */
	String add${domain.name}(${domain.name} ${domain.name?uncap_first});

	/**
	 * 删除${domain.cnName}
	 * @param ${domain.name?uncap_first} 要删除的${domain.cnName}的${domain.name?uncap_first}实例
	 */
	void delete${domain.name}(${domain.name} ${domain.name?uncap_first});

	/**
	 * 删除${domain.cnName}
	 * @param id 要删除的${domain.cnName}的${domain.name?uncap_first}实例的id
	 */
	void delete${domain.name}(String id);
	
	/**
	 * 更新${domain.cnName}
	 * @param ${domain.name?uncap_first} 要更新的用户的${domain.cnName}实例
	 */
	void update${domain.name}(${domain.name} ${domain.name?uncap_first});
	
	/**
	 * 根据id查找${domain.cnName}
	 * @param String id
	 * return 查找到的${domain.cnName}实例
	 */
	${domain.name} find${domain.name}(String id);
	
	/**
	 * 列举出所有${domain.cnName}
	 * @return List<${domain.name}> 返回所有${domain.cnName}
	 */
	List<${domain.name}> find${domain.name}s();
	
	/**
	 * 根据条件查找${domain.cnName}
	 * @param property 搜索属性
	 * @param keyword 搜索关键字
	 * @param user 当前用户
	 * @return 返回所有${domain.cnName}
	 */
	List<${domain.name}> find${domain.name}sByProp(String property, String keyword, User user);
	
	/**
	 * 根据关联类查找${domain.cnName}
	 * @param refClass 关联类名
	 * @param refId 关联类的id
	 * @return 返回所有${domain.cnName}
	 */
	List<${domain.name}> find${domain.name}sByRef(String refClass, String refId);
	
	<#if domain.userRelated = true>
	/**
	 * 根据用户列举出所有${domain.cnName}
	 * @param user 申请的用户
	 * @return 返回所有${domain.cnName}
	 */
	List<${domain.name}> find${domain.name}sByUser(User user);
	
	</#if>
	</#list>
	
	/*
	 * 系统初始化时对流程定义文件的部署
	 */
	void checkProcessDeploy();
	
	/**
	 * 获取当前角色任务列表
	 * @param String bizName 业务名
	 * @param User user 用户
	 * @return Map<业务id, Task>
	 */
	Map<String, Task> getTaskList(String bizName, User user);
	
	/**
	 * 获取当前角色历史任务列表
	 * @param User user 用户
	 * @return Map<业务id, Task>
	 */
	Map<String, HistoryTask> getHistTaskList(User user);
	
	/**
	 * 流程-处理申请
	 * @param String processName 流程名
	 * @param String bizName 业务名
	 * @param String bizId 业务id
	 * @param User user 业务执行用户
	 * @return String 状态信息
	 */
	String procApply(String processName, String bizName, String bizId, User user) throws Exception;
	
	/**
	 * 流程-处理批准
	 * @param String taskId 任务id
	 * @return String 业务状态
	 */
	String procApprove(String taskId, User user) throws Exception;
	
	/**
	 * 流程-处理驳回
	 * @param String taskId 任务id
	 * @return String 业务状态
	 */
	String procReject(String taskId, User user) throws Exception;
}

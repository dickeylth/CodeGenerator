package ${package}.service;

import java.util.List;

import ${package}.domain.*;

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
}

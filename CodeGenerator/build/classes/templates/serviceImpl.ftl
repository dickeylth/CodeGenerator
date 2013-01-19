package ${package}.service.impl;

import java.util.List;

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
}

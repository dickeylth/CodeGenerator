package ${package}.dao;

import java.util.List;

import ${package}.domain.${domain.name};
import ${package}.domain.User;

public interface ${domain.name}Dao {
	//根据id查找${domain.name}
	${domain.name} get(String id);
	
	<#if domain.name = "User">
	//根据用户名查找用户，只对User类存在
	${domain.name} findUserByName(String username);
	</#if>
	
	//保存${domain.name}
	String save(${domain.name} ${domain.name?uncap_first});
	
	//更新${domain.name}
	void update(${domain.name} ${domain.name?uncap_first});
	
	//根据${domain.name}实例删除${domain.name}
	void delete(${domain.name} ${domain.name?uncap_first});
	
	//根据id删除${domain.name}
	void delete(String id);
	
	//查找所有${domain.name}
	List<${domain.name}> getAll();
	
	<#if domain.userRelated = true>
	//与用户类关联，根据用户查找${domain.name}
	List<${domain.name}> findByUser(User user);
	</#if>
	
	//根据属性模糊查找${domain.name}
	List<${domain.name}> findByProp(String property, String keyword, User user);

	//根据关联类查找${domain.name}
	List<${domain.name}> findByRef(String refClass, String refId);
	
}

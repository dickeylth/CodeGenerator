package ${package}.dao.impl;

import java.util.List;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import ${package}.dao.${domain.name}Dao;
import ${package}.domain.${domain.name};
import ${package}.domain.User;


public class ${domain.name}DaoImpl extends HibernateDaoSupport implements ${domain.name}Dao {
	//根据id查找${domain.name}
	@Override
	public ${domain.name} get(String id) {
		return getHibernateTemplate().get(${domain.name}.class, id);
	}
	
	<#if domain.name = "User">
	//根据用户名查找用户，只对User类存在
	@Override
	public User findUserByName(String username) {
		//根据用户名查找用户
		return (User) getHibernateTemplate().find(" from User where username = ?", username).get(0);
	}
	</#if>
	
	//保存${domain.name}
	@Override
	public String save(${domain.name} ${domain.name?uncap_first}) {
		<#if domain.name = "Role">
		if(role.getId().equals("")){
			role.setId(role.getName());
		}
		</#if>
		return (String) getHibernateTemplate().save(${domain.name?uncap_first});
	}
	
	//更新${domain.name}
	@Override
	public void update(${domain.name} ${domain.name?uncap_first}) {
		<#if domain.name = "Role">
		if(role.getId().equals("")){
			role.setId(role.getName());
		}
		</#if>
		getHibernateTemplate().merge(${domain.name?uncap_first});
	}
	
	//根据${domain.name}实例删除${domain.name}
	@Override
	public void delete(${domain.name} ${domain.name?uncap_first}) {
		getHibernateTemplate().delete(${domain.name?uncap_first});
	}
	
	//根据id删除${domain.name}
	@Override
	public void delete(String id) {
		getHibernateTemplate().delete(get(id));
	}
	
	//查找所有${domain.name}
	@SuppressWarnings("unchecked")
	@Override
	public List<${domain.name}> getAll() {
		// TODO Auto-generated method stub
		return (List<${domain.name}>)getHibernateTemplate().find(" from ${domain.name}");
	}
	
	<#if domain.userRelated = true>
	//与用户类关联，根据用户查找${domain.name}
	@SuppressWarnings("unchecked")
	@Override
	public List<${domain.name}> findByUser(User user) {
		return (List<${domain.name}>)getHibernateTemplate().find(" from ${domain.name} as a where a.user = ?", user);
	}
	</#if>
	
	//根据属性模糊查找${domain.name}
	@SuppressWarnings("unchecked")
	@Override
	public List<${domain.name}> findByProp(String property, String keyword, User user) {
		String hql = " from ${domain.name} as a where a." + property + " like '%" + keyword + "%'";
		<#if domain.userRelated = true>
		return (List<${domain.name}>)getHibernateTemplate().find(hql + " and a.user = ?", user);
		<#else>
		return (List<${domain.name}>)getHibernateTemplate().find(hql);
		</#if>
	}

	//根据关联类查找${domain.name}
	@SuppressWarnings("unchecked")
	@Override
	public List<${domain.name}> findByRef(String refClass, String refId) {
		return (List<${domain.name}>)getHibernateTemplate().find(" from ${domain.name} as a where a." + refClass + ".id = ?", refId);
	}
	
}

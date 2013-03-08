package ${package}.security;

import java.util.List;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.hibernate.Hibernate;

import ${package}.domain.User;
import ${package}.domain.Role;
import ${package}.domain.Permission;
import ${package}.dao.UserDao;

public class CustomRealm extends AuthorizingRealm {

	private UserDao userDao;

	/*
	 * 鉴权
	*/
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(
			PrincipalCollection principals) {
		//获取用户名
		String username = (String) principals.fromRealm(getName()).iterator().next();
		//根据用户名查找用户
		User user = userDao.findUserByName(username);

		if (user != null) {
			SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
			//由于List<Role>是懒加载，调用Hibernate.initialize()方法加载之
			Hibernate.initialize(user.getRoles());
			for (Role role : user.getRoles()) {
				//List<Permission>懒加载
				Hibernate.initialize(role.getPermissions());
				List<Permission> permissions = role.getPermissions();
				
				//添加角色
				info.addRole(role.getName());

				for (Permission permission : permissions) {
					//遍历添加权限
					info.addStringPermission(permission.getPermission());
				}
			}
			return info;
		} else {
			return null;
		}
	}

	/*
	 * 认证
	*/
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(
			AuthenticationToken authcToken) throws AuthenticationException {
		//查找用户
		UsernamePasswordToken token = (UsernamePasswordToken) authcToken;
		User user = userDao.findUserByName(token.getUsername());
		//调用认证方法
		if (user != null) {
			return new SimpleAuthenticationInfo(
					user.getUsername(), user.getPassword(), getName());
		} else {
			return null;
		}
	}

	public UserDao getUserDao() {
		return userDao;
	}

	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}

}

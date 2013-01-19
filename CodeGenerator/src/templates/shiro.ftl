package ${package}.security;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;

import ${package}.domain.User;
import ${package}.service.UserService;

public class ShiroAuthFilter extends FormAuthenticationFilter{
	
	private UserService userService;
	
	@Override
	protected boolean onLoginSuccess(AuthenticationToken token, Subject subject,
            ServletRequest request, ServletResponse response) throws Exception {
		issueSuccessRedirect(request, response);
		
		//获取用户业务表信息，加载到Session中
		User user = userService.findUserByName((String) subject.getPrincipal());
		Session session = subject.getSession();
		session.setAttribute("user", user);
		
		return false;
	}
	
	@Override
	protected boolean onLoginFailure(AuthenticationToken token, AuthenticationException e,
            ServletRequest request, ServletResponse response) {
		setFailureAttribute(request, e);
		//返回出错信息
		String tip = "";
		if(e instanceof IncorrectCredentialsException){
			tip = "您输入的密码不对！";
		}else if(e instanceof UnknownAccountException){
			tip = "您输入的用户名不存在！";
		}else{
			tip = "您输入的用户名/密码不正确，请重新输入！";
		}
		Subject subject = SecurityUtils.getSubject();
		Session session = subject.getSession();
		session.setAttribute("tip", tip);
		return true;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}
}

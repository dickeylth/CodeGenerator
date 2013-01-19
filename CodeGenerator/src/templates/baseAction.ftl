package ${package}.action.base;


import ${package}.service.UserService;
import com.opensymphony.xwork2.ActionSupport;

public class BaseAction extends ActionSupport{
	/**
	 * 序列化UID
	 */
	private static final long serialVersionUID = 1L;
	
	//依赖的业务逻辑组件
	protected UserService userService;
	//依赖注入业务逻辑组件所必须的setter方法
	public void setUserService(UserService userService)
	{
		this.userService = userService;
	}
	
	//公用方法
	public String toLowerFirst(String origin){
		if(origin != null && !origin.trim().equals("")){
			String src = origin.trim();
			StringBuilder sb = new StringBuilder(); 
		 	sb.append(Character.toLowerCase(src.charAt(0))).append(src.substring(1)); 
		 	return sb.toString();
		}
		return "";
	}
}

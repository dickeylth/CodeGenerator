package com.codegen.action;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;


import org.apache.tools.ant.Project;
import org.apache.tools.ant.ProjectHelper;
import org.apache.tools.ant.taskdefs.Zip;
import org.apache.tools.ant.types.FileSet;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;

import com.codegen.domain.*;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

public class CodeGenAction extends ActionSupport{
	/**
	 * 默认序列化UID
	 */
	private static final long serialVersionUID = 1L;
	
	//Table元数据信息类集合
	private List<DomainPo> domainPos = new LinkedList<DomainPo>();
	//包名
	public static String pkg = "com.codegen";
	//classes路径("/D:/apache-tomcat-7.0.34/webapps/CodeGenerator/WEB-INF/classes/")
	private String relPath = getClass().getResource("/").getPath();
	//session中的SysConfig
	private SysConfig sysConfig = (SysConfig) ActionContext.getContext().getSession().get("sysConfig");
	
	public String execute() throws Exception{

		System.out.println("--------------开始代码生成！--------------");
		
		//解析domain配置文件
		parseDomainXml();
		
    	//模板组装
    	generateTemplates();
    	
    	//java文件编译&处理resource资源文件，并部署到tomcat下
    	compileCodes();
		
		//打包生成的文件，供下载使用
    	zipProject();
		
		return SUCCESS;
	}


	/**
	 * 解析domain.xml到表元数据的domain中
	 * @throws DocumentException
	 */
    public void parseDomainXml() throws DocumentException{
    	Document document = (Document) ActionContext.getContext().getSession().get("domain");
    	
    	System.out.println("---------------解析domain.xml到元数据中-------------");
        //获取根节点tables
        Element root = document.getRootElement();
        //获取子节点列表table
        @SuppressWarnings("unchecked")
		List<Element> domains = root.elements("domain");
        for (Element domain : domains) {
            String domainName = (String) domain.elementText("name");
            String domainCnName = (String) domain.elementText("name_cn");
            
            List<PropertyPo> propertyPos = new LinkedList<PropertyPo>();
            DomainPo domainPo = new DomainPo(domainName, domainCnName, propertyPos);
            boolean isRefUserflag = false;
            
            //遍历columns
            @SuppressWarnings("unchecked")
			List<Element> properties = domain.element("properties").elements("property");
            for (Element property : properties) {
            	
                String propName = property.elementText("name");
                String propCnName = property.elementText("name_cn");
                String propType = property.elementText("type");
                PropertyPo propertyPo = new PropertyPo(propName, propCnName, propType);
                
                //处理是否主键/非空/唯一/集合
                String bool = property.elementText("pk");
                if(bool != null){
                	propertyPo.setPk(Boolean.valueOf(bool));
                	propertyPo.setType("String");
                }
                bool = property.elementText("nullable");
                if(bool != null){
                	propertyPo.setNullable(bool);
                }
                bool = property.elementText("unique");
                if(bool != null){
                	propertyPo.setUnique(bool);
                }
                bool = property.elementText("plural");
                if(bool != null){
                	propertyPo.setPlural(Boolean.valueOf(bool));
                }
                       
                //处理外键关联
                Element propRef = property.element("ref");
                if(propRef != null && !propRef.getStringValue().equals("false")){
                    String refDomain = propRef.elementText("ref_domain");
                    String refType = propRef.elementText("ref_type");
                    String refDisplayProp = propRef.elementText("ref_display_property");
                    RefDomainPo refDomainPo = new RefDomainPo(refDomain, refType, refDisplayProp);
                    
                    //处理一对一&多对多连接表
                    if(refType.equals("one-to-one") || refType.equals("many-to-many")){
                    	String joinTable = (domainName.compareTo(refDomain) > 0) ? domainName + "_" + refDomain : refDomain + "_" + domainName;
                    	String joinColumn = domainName + "_id";
                    	String inverseJoinColumn = refDomain + "_id";
                    	refDomainPo.setJoinTable(joinTable);
                    	refDomainPo.setJoinColumn(joinColumn);
                    	refDomainPo.setInverseJoinColumn(inverseJoinColumn);
                    }
                    
                    //处理变量名规范，对关联类型属性变量名进行转换
                    //首字母小写
                    refDomain = refDomain.substring(0, 1).toLowerCase().concat(refDomain.substring(1));
                    if(propertyPo.isPlural()){	
                    	propertyPo.setName(refDomain + "s");
                    }else{
                    	propertyPo.setName(refDomain);
                    }
                    
                    propertyPo.setRefDomainPo(refDomainPo);
                }
                
                domainPo.getProperties().add(propertyPo);
                if(propType != null && propType.equals("User") && !propertyPo.isPlural()){
                	isRefUserflag = true;
                }
                
            }
            domainPo.setUserRelated(isRefUserflag);
            //System.out.println(domainPo);
            domainPos.add(domainPo);
        }
        System.out.println("--------------domain.xml解析完毕----------------");
    }
    
    /**
     * 合并表元数据与模板文件
     * @param args
     * @throws IOException 
     * @throws TemplateException 
     * @throws DocumentException
     */
    public void generateTemplates() throws IOException, TemplateException{
    	
    	//Freemarker初始化工作
    	Configuration conf = new Configuration();
    	File baseDir = new File(relPath + "templates");
    	System.out.println(relPath + "templates");
    	conf.setDirectoryForTemplateLoading(baseDir);
    	
    	
    	Map<String, Object> root = new HashMap<String, Object>();
    	root.put("package", pkg);
    	root.put("sysConfig", sysConfig);
    	final String srcPath = "WEB-INF/src/" + pkg.replace(".", "/") + "/";
    	
    	for (final DomainPo domainPo : this.domainPos) {
    		
    		root.put("domain", domainPo);
    		
    		Map<String, String> path_template = new HashMap<String, String>(){
    			private static final long serialVersionUID = 1L;{
    			//处理domain模板
        		put(srcPath + "domain/" + domainPo.getName() + ".java", "domain.ftl");
        		//处理dao模板
        		put(srcPath + "dao/" + domainPo.getName() + "Dao.java", "dao.ftl");
        		//处理daoImpl模板
        		put(srcPath + "dao/impl/" + domainPo.getName() + "DaoImpl.java", "daoImpl.ftl");
        		//处理action模板
        		put(srcPath + "action/" + domainPo.getName() + "Action.java", "action.ftl");
        		//处理domain_edit模板
        		put(domainPo.getName() + "/edit.jsp", "domain_edit.ftl");
        		//处理domain_index模板
        		put(domainPo.getName() + "/index.jsp", "domain_index.ftl");
        	}};
    		
        	for ( Map.Entry<String, String> entry : path_template.entrySet()) {
				String path = entry.getKey();
				String ftl = entry.getValue();
				Template template = conf.getTemplate(ftl);
				procLoopGene(path, template, root);
			}
        	System.out.println("------------处理" + domainPo.getCnName() + "-------------");
        	root.remove("domain");
		}
    	
    	root.put("domains", this.domainPos);
    	Map<String, String> path_template = new HashMap<String, String>(){
			private static final long serialVersionUID = 1L;{
			//处理service模板
    		put(srcPath + "service/UserService.java", "service.ftl");
    		//处理serviceImpl模板
    		put(srcPath + "service/impl/UserServiceImpl.java", "serviceImpl.ftl");
    		//处理BaseAction模板
    		put(srcPath + "action/base/BaseAction.java", "baseAction.ftl");
    		//处理DatabaseInit模板
    		put("WEB-INF/src/DatabaseInit.java", "DatabaseInit.ftl");
    		//处理struts.xml模板
    		put("WEB-INF/classes/struts.xml", "struts.ftl");
    		//处理resource模板
    		put("WEB-INF/src/resource_zh_CN.properties", "resource_zh_CN.ftl");
    		//处理applicationContext模板
    		put("WEB-INF/applicationContext.xml", "applicationContext.ftl");
    		//处理index.jsp模板
    		put("index.jsp", "index.ftl");
    		//处理index.jsp模板
    		put(srcPath + "security/ShiroAuthFilter.java", "shiro.ftl");
    	}};
    	for ( Map.Entry<String, String> entry : path_template.entrySet()) {
    		
			String path = entry.getKey();
			String ftl = entry.getValue();
			System.out.println("------------处理" + ftl + "-------------");
			Template template = conf.getTemplate(ftl);
			procLoopGene(path, template, root);
			
		}
    }
    
    /**
     * 生成的代码编译
     */
    public void compileCodes(){
    	
    	File buildFile = new File(relPath + "../../target/WEB-INF/build.xml");
    	Project project = new Project();
    	project.init();
    	ProjectHelper helper = ProjectHelper.getProjectHelper();
    	helper.parse(project, buildFile);
    	
    	project.setProperty("target", relPath + "../../../" + sysConfig.getSysPackage());
    	
    	try{
    		project.executeTarget(project.getDefaultTarget());
    	}catch (Exception e) {
			System.err.println(e.getLocalizedMessage());
		}
    	
    }
    
    /**
     * 打包项目文件
     */
    public void zipProject(){
    	Project project = new Project();
    	Zip zip = new Zip();
    	zip.setProject(project);
    	zip.setDestFile(new File(relPath + "../../target/" + sysConfig.getSysPackage() + ".zip"));
    	
    	FileSet fileSet = new FileSet();
    	fileSet.setProject(project);
    	fileSet.setDir(new File(relPath + "../../target"));
    	zip.addFileset(fileSet);
    	
    	try {
        	zip.execute();			
		} catch (Exception e) {
			System.err.println(e.getLocalizedMessage());
		}

    }
    
    /**
     * 处理循环生成代码
     * @param path 路径名
     * @param t 模板
     * @param root 根对象
     */
    private void procLoopGene(String path, Template t, Map<String, Object> root){
    	//根据pkg和path组装目标代码路径
    	File f = new File(relPath + "../../target/" + path);
    	System.out.println(relPath + "../../target/" + path);
		try {
			f.getParentFile().mkdirs();
			f.createNewFile();
			System.out.println("创建文件！" + f.getAbsolutePath());
			BufferedWriter writer;
			writer = new BufferedWriter(new FileWriter(f));
			t.process(root, writer);
			writer.close();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (TemplateException e) {
			e.printStackTrace();
		}
    }
    
}

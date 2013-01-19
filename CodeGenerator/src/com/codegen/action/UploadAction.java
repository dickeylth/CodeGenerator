package com.codegen.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

import org.apache.struts2.ServletActionContext;
import org.dom4j.Document;
import org.dom4j.io.SAXReader;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class UploadAction extends ActionSupport{
	/**
	 * serial uid
	 */
	private static final long serialVersionUID = 1L;
	//上传文件域
	private File upload;
	//上传文件类型
	private String uploadContentType;
	//上传文件名
	private String uploadFileName;
	//设置文件名
	private String fileName;
	//保存路径
	private String savePath;
	
	//Getters & Setters
	public File getUpload() {
		return upload;
	}

	public void setUpload(File upload) {
		this.upload = upload;
	}

	public String getUploadContentType() {
		return uploadContentType;
	}

	public void setUploadContentType(String uploadContentType) {
		this.uploadContentType = uploadContentType;
	}

	public String getUploadFileName() {
		return uploadFileName;
	}

	public void setUploadFileName(String uploadFileName) {
		this.uploadFileName = uploadFileName;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getSavePath() {
		return ServletActionContext.getServletContext().getRealPath(savePath);
	}

	public void setSavePath(String savePath) {
		this.savePath = savePath;
	}

	@Override
	public String toString() {
		return "UploadAction [upload=" + upload + ", uploadContentType="
				+ uploadContentType + ", uploadFileName=" + uploadFileName
				+ ", fileName=" + fileName + ", savePath=" + savePath + "]";
	}

	@Override
	public String execute() throws Exception{
		FileOutputStream fos = new FileOutputStream(getSavePath() + "\\" + getFileName());
		FileInputStream fis = new FileInputStream(getUpload());
		byte[] buffer = new byte[1024];
		int len = 0;
		while((len = fis.read(buffer)) > 0){
			fos.write(buffer, 0, len);
		}
		System.out.println(this);
		
		
    	SAXReader reader = new SAXReader();
        Document document = reader.read(getUpload());
        ActionContext.getContext().getSession().put("domain", document);
        
        return SUCCESS;
	}
	
}

package com.codegen.domain;

import java.io.Serializable;

public class Message implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private int status;
	
	private String content;

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	@Override
	public String toString() {
		return "Message [status=" + status + ", content=" + content + "]";
	}

	public Message(int status, String content) {
		super();
		this.status = status;
		this.content = content;
	}

	public Message() {
		super();
	}
	
}

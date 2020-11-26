package com.cc.pms.exception;

public class LoginFailException extends RuntimeException {
	
	/**
	 * 生成序列号 不是必须
	 */
	private static final long serialVersionUID = 1L;

	public LoginFailException(String message) {
		super(message);
		
	}

}

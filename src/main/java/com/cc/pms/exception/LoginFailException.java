package com.cc.pms.exception;

public class LoginFailException extends RuntimeException {
	
	/**
	 * �������к� ���Ǳ���
	 */
	private static final long serialVersionUID = 1L;

	public LoginFailException(String message) {
		super(message);
		
	}

}

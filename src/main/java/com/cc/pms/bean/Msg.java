package com.cc.pms.bean;
/**
 * 	ͨ�õķ����࣬����json����
 * @author cc
 *
 */

import java.util.HashMap;
import java.util.Map;



public class Msg {
	
	//״̬��
	private int code;
	//��ʾ��Ϣ
	private String msg;
	//�û�Ҫ���ظ������������(״̬�롢��ʾ��Ϣ������)ͳһ��װ��map
	private Map<String, Object> extend =new HashMap<String, Object>(); 
	//���崦���ɹ���ʧ�ܵķ���
	public static Msg success() {
		Msg result=new Msg();
		result.setCode(100);
		result.setMsg("�����ɹ�");
		return result;
		
	}
	public static Msg fail() {
		Msg result=new Msg();
		result.setCode(200);
		result.setMsg("����ʧ��");
		return result;
		
	}
	//����������Ϣ�ķ���
	public Msg add(String key,Object value){
		this.getExtend().put(key, value);
		return this;
	}
	
	//get set����
	public int getCode() {
		return code;
	}
	public void setCode(int code) {
		this.code = code;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public Map<String, Object> getExtend() {
		return extend;
	}
	public void setExtend(Map<String, Object> extend) {
		this.extend = extend;
	}

}
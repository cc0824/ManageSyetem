package com.cc.pms.bean;

import java.time.LocalDateTime;

public class LogMessage {
    private Integer id;
    private String operatorName;//����������
    private String operatorRole;//�����˽�ɫ
    private String operateDesc;//����˵��
    private String operateDate;//����ʱ��
    private String operateResult;//������� �ɹ�orʧ��
    private String ip;//ip��ַ
    
    private String operateMethod;//Ŀ�귽��
    private String operateParams;//Ŀ�귽������
    private String operateExpDetail;//�쳣����
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getOperatorName() {
		return operatorName;
	}
	public void setOperatorName(String operatorName) {
		this.operatorName = operatorName;
	}
	public String getOperatorRole() {
		return operatorRole;
	}
	public void setOperatorRole(String operatorRole) {
		this.operatorRole = operatorRole;
	}
	public String getOperateDesc() {
		return operateDesc;
	}
	public void setOperateDesc(String operateDesc) {
		this.operateDesc = operateDesc;
	}
	public String getOperateDate() {
		return operateDate;
	}
	public void setOperateDate(String operateDate) {
		this.operateDate = operateDate;
	}
	public String getOperateResult() {
		return operateResult;
	}
	public void setOperateResult(String operateResult) {
		this.operateResult = operateResult;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public String getOperateMethod() {
		return operateMethod;
	}
	public void setOperateMethod(String operateMethod) {
		this.operateMethod = operateMethod;
	}
	public String getOperateParams() {
		return operateParams;
	}
	public void setOperateParams(String operateParams) {
		this.operateParams = operateParams;
	}
	public String getOperateExpDetail() {
		return operateExpDetail;
	}
	public void setOperateExpDetail(String operateExpDetail) {
		this.operateExpDetail = operateExpDetail;
	}
	public LogMessage(Integer id, String operatorName, String operatorRole, String operateDesc, String operateDate,
			String operateResult, String ip, String operateMethod, String operateParams, 
			String operateExpDetail) {
		super();
		this.id = id;
		this.operatorName = operatorName;
		this.operatorRole = operatorRole;
		this.operateDesc = operateDesc;
		this.operateDate = operateDate;
		this.operateResult = operateResult;
		this.ip = ip;
		this.operateMethod = operateMethod;
		this.operateParams = operateParams;
		this.operateExpDetail = operateExpDetail;
	}
	public LogMessage() {
		super();
		// TODO Auto-generated constructor stub
	}
	@Override
	public String toString() {
		return "LogMessage [id=" + id + ", operatorName=" + operatorName + ", operatorRole=" + operatorRole
				+ ", operateDesc=" + operateDesc + ", operateDate=" + operateDate + ", operateResult=" + operateResult
				+ ", ip=" + ip + ", operateMethod=" + operateMethod + ", operateParams=" + operateParams
				+ ", operateExpDetail=" + operateExpDetail + "]";
	}
    
    
    
	
	
	
	
   
}

package com.cc.pms.bean;

import java.time.LocalDateTime;

//���ʵ��
public class MonitorInstance {
	private Integer monitorInstanceId;
	private String monitorInstanceName;//���ʵ������
	private Integer monitorItemId;
	private Integer monitorInstanceSendMsg;//�Ƿ���Ҫ���ͼ��֪ͨ
	private String monitorInstanceSendMsgAddress;//�����Ҫ������֪ͨ��ַ
	private int monitorInstanceAlertType;//��ؾ������ͣ�0��ʱ1����
	private LocalDateTime monitorInstanceAlertStartTime;//��ʱ������ʼʱ��
	private LocalDateTime monitorInstanceAlertEndTime;//��ʱ��������ʱ��
	private Integer monitorInstanceAlertInterval;//���ھ������
	private Integer monitorInstanceOpened;//���ʵ���Ƿ���
	private Integer monitorInstanceDeleted;//���ʵ���Ƿ�
	
	private MonitorItem monitorItem;
	

}

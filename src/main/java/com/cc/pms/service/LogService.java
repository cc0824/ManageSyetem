package com.cc.pms.service;

import java.util.List;

import com.cc.pms.bean.LogMessage;

public interface LogService {
	//�����־
	public void addLog(LogMessage logmsg);
	//��ѯ��־
	public List<LogMessage> getAllLogMessage();
	public List<LogMessage> getLogBySelect(LogMessage logMessage);

}

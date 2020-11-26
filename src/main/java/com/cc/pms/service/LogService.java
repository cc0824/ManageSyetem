package com.cc.pms.service;

import java.util.List;

import com.cc.pms.bean.LogMessage;

public interface LogService {
	//添加日志
	public void addLog(LogMessage logmsg);
	//查询日志
	public List<LogMessage> getAllLogMessage();
	public List<LogMessage> getLogBySelect(LogMessage logMessage);

}

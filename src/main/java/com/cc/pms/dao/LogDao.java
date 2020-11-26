package com.cc.pms.dao;

import java.util.List;

import com.cc.pms.bean.LogMessage;

public interface LogDao {
	public void addLog(LogMessage logmsg);
	public List<LogMessage> getAllLogMessage();
	public List<LogMessage> getLogBySelect(LogMessage logMessage);

}

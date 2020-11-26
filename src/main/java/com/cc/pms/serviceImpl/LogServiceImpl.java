package com.cc.pms.serviceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cc.pms.bean.LogMessage;
import com.cc.pms.dao.LogDao;
import com.cc.pms.service.LogService;

@Service("logService")
public class LogServiceImpl implements LogService{
	
	@Autowired
	private LogDao logDao;

	@Override
	public void addLog(LogMessage logmsg) {
		logDao.addLog(logmsg);
		
	}

	@Override
	public List<LogMessage> getAllLogMessage() {
		List<LogMessage> res= logDao.getAllLogMessage();
		System.out.println(res);
		return res;
	}
	@Override
	public List<LogMessage> getLogBySelect(LogMessage logMessage) {
		return logDao.getLogBySelect(logMessage);
	}
	

}

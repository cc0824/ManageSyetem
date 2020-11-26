package com.cc.pms.serviceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cc.pms.bean.MonitorInstance;
import com.cc.pms.dao.MenuDao;
import com.cc.pms.dao.MonitorDao;
import com.cc.pms.service.MonitorService;

@Service("monitorService")
public class MonitorServiceImpl implements MonitorService{
	@Autowired
	private MonitorDao monitorDao;

	@Override
	public List<MonitorInstance> getAllMonitorInstancesByMonitorItemId(int monitorItemId) {
		return monitorDao.getAllMonitorInstancesByMonitorItemId(monitorItemId);
	}

}

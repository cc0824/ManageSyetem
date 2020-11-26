package com.cc.pms.service;

import java.util.List;

import com.cc.pms.bean.MonitorInstance;

public interface MonitorService {
	public List<MonitorInstance> getAllMonitorInstancesByMonitorItemId(int monitorItemId);
	

}

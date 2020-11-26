package com.cc.pms.dao;

import java.util.List;

import com.cc.pms.bean.MonitorInstance;

public interface MonitorDao {

	public List<MonitorInstance> getAllMonitorInstancesByMonitorItemId(int monitorItemId);

}

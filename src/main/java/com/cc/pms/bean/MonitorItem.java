package com.cc.pms.bean;

import java.util.List;

//监控项——一个监控项包含多个监控实例
public class MonitorItem {
	private Integer monitorItemId;
	private String monitorItemType;//监控项类型
	private Integer monitorItemOpened;//监控项使用情况
	
	private List<MonitorInstance> monitorInstances;//一对多

}

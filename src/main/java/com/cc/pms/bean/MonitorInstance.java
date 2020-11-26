package com.cc.pms.bean;

import java.time.LocalDateTime;

//监控实例
public class MonitorInstance {
	private Integer monitorInstanceId;
	private String monitorInstanceName;//监控实例名称
	private Integer monitorItemId;
	private Integer monitorInstanceSendMsg;//是否需要发送监控通知
	private String monitorInstanceSendMsgAddress;//如果需要，发送通知地址
	private int monitorInstanceAlertType;//监控警报类型：0定时1定期
	private LocalDateTime monitorInstanceAlertStartTime;//定时警报开始时间
	private LocalDateTime monitorInstanceAlertEndTime;//定时警报结束时间
	private Integer monitorInstanceAlertInterval;//定期警报间隔
	private Integer monitorInstanceOpened;//监控实例是否开启
	private Integer monitorInstanceDeleted;//监控实例是否
	
	private MonitorItem monitorItem;
	

}

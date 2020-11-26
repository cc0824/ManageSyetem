package com.cc.pms.bean;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class TreeModelRecord {
	private Integer recordId;
	private Integer mId; //关联模型
	private LocalDateTime recordTime;//模型使用时间
	
	public TreeModelRecord(Integer mId, LocalDateTime recordTime) {
		super();
		this.mId = mId;
		this.recordTime = recordTime;
	}

	public TreeModelRecord() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Integer getRecordId() {
		return recordId;
	}

	public void setRecordId(Integer recordId) {
		this.recordId = recordId;
	}


	public Integer getmId() {
		return mId;
	}

	public void setmId(Integer mId) {
		this.mId = mId;
	}

	public LocalDateTime getRecordTime() {
		return recordTime;
	}

	public void setRecordTime(LocalDateTime recordTime) {
		this.recordTime = recordTime;
	}
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return "[modelId="+mId+",recordTime="+recordTime+"]";
	}
	
	
	
	
	
	
	
}

package com.cc.pms.bean;
/**
 * 	日志信息
 */
import java.util.Date;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

/**
 * 	日志实体
 * @author Administrator
 *
 */
public class Log {

	public final static String LOGIN_ACTION="登录操作";
	public final static String LOGOUT_ACTION="注销操作";
	public final static String SEARCH_ACTION="查询操作";
	public final static String UPDATE_ACTION="更新操作";
	public final static String ADD_ACTION="添加操作";
	public final static String DELETE_ACTION="删除操作";
	
	private Integer id; // 编号
	private String type; // 日志类型
	private User user; // 操作用户
	private String content; // 操作内容
	private Date time; // 操作日期时间
	private Date stime; // 起始时间 搜索用到
	private Date etime; // 结束时间 搜索用到
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Date getTime() {
		return time;
	}
	public void setTime(Date time) {
		this.time = time;
	}
	public Date getStime() {
		return stime;
	}
	public void setStime(Date stime) {
		this.stime = stime;
	}
	public Date getEtime() {
		return etime;
	}
	public void setEtime(Date etime) {
		this.etime = etime;
	}
	public Log(Integer id, String type, User user, String content, Date time, Date stime, Date etime) {
		super();
		this.id = id;
		this.type = type;
		this.user = user;
		this.content = content;
		this.time = time;
		this.stime = stime;
		this.etime = etime;
	}
	public Log() {
		super();
	}
	

	
	
	
}

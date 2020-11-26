package com.cc.pms.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cc.pms.bean.Inventory;
import com.cc.pms.bean.LogMessage;
import com.cc.pms.bean.Msg;
import com.cc.pms.service.LogService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
@RequestMapping("/log")
public class LogController {
	
	@Autowired
	private LogService logService;
	
	@ResponseBody
	@RequestMapping("/displayLogInformation")
	public Msg displayLogInformation(@RequestParam(value="pn",defaultValue="1")Integer pn) {
		PageHelper.startPage(pn, 10);
		List<LogMessage> logs =logService.getAllLogMessage();
		PageInfo page=new PageInfo(logs,5);
		return Msg.success().add("pageInfo", page);
	}
	
	@ResponseBody
	@RequestMapping("/getLogBySelect")
	public Msg getLogBySelect(@RequestParam(value="pn",defaultValue="1")Integer pn,LogMessage logMessage) {
		System.out.println(logMessage);
		PageHelper.startPage(pn, 10);
		List<LogMessage> logs =logService.getLogBySelect(logMessage);
		PageInfo page=new PageInfo(logs,5);
		return Msg.success().add("pageInfo", page);
	}
	
	

}

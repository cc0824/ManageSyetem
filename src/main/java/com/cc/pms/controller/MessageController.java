package com.cc.pms.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.cc.pms.bean.MyMessage;
import com.cc.pms.bean.Product;
import com.cc.pms.component.LogAnnotation;
import com.cc.pms.bean.Msg;
import com.cc.pms.service.MessageService;
import com.cc.pms.socket.SocketHandler;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

/**
 * 实现站内信功能
 * 
 * @author 18379
 *
 */
@Controller
@RequestMapping("/message")
public class MessageController {
	@Autowired
	private SocketHandler socketHandler;
	@Autowired
	private MessageService messageService;
	
	
	/**
	 * 1.当前用户定时ajax轮询是否收到新消息
	 * @param：当前用户名
	 */
	@ResponseBody
	@RequestMapping(value="/getMessageByUserName",method = RequestMethod.GET)
	@LogAnnotation(value="获取消息列表...")
	public Msg getMessageByUserName(@RequestParam(value="myname")String userName) {
		System.out.println(userName);
		List<MyMessage> myMessage=messageService.getMessageByUserName(userName);		
		System.out.println(myMessage);
		return Msg.success().add("myMessage",myMessage);
	}

	/**
	 * 提交站内信——使用ajax轮询
	 */
	@RequestMapping("/sendMessage")
	public Msg sendMessage(HttpServletRequest request,MyMessage myMessage) {
		String messageContent = request.getParameter("messageContent");
		String messageType=request.getParameter("messageType");
		String messageFromUser = request.getParameter("messageFromUser");
		String messageToUser=request.getParameter("messageToUser");
		
		System.out.println("messageType:"+messageType);
		System.out.println("myMessage:"+myMessage);

		messageService.addMessage(myMessage);
		return Msg.success();
	}

	/**
	 * 用来及时推送消息
	 * @param
	 * @throws IOException
	 */
	@ResponseBody
	@RequestMapping(value="/receiveMessage",method = RequestMethod.GET)
	public Msg receiveMessage() throws IOException {
		List<MyMessage> mymessage = messageService.getMessage();
		System.out.println("需要推送的消息："+mymessage);
		return Msg.success().add("mymessage", mymessage);

	}
	/**
	 * 用来改变显示状态
	 */
	@ResponseBody
	@RequestMapping(value="/updateDisplayState",method = RequestMethod.GET)
	public Msg updateDisplayState(Integer id) {
		System.out.println("传递过来的id是："+id);
		messageService.updateDisplayState(id);
		return Msg.success();
	}
	/**
	 * 用来查询折叠列表中前5条历史记录
	 */
	@ResponseBody
	@RequestMapping(value="getFiveInboundMessage",method=RequestMethod.GET)
	public Msg getFiveInboundMessage() {
		List<MyMessage> messageList=messageService.getAllInboundMessage();
		System.out.println("历史入库记录："+messageList);
		return Msg.success().add("messageList",messageList);
	}
	/**
	 * 用来查询所有历史记录
	 */
	@ResponseBody
	@RequestMapping(value="getAllInboundMessage",method=RequestMethod.GET)
	public Msg getAllInboundMessage(@RequestParam(value="pn",defaultValue="1")Integer pn) {
		PageHelper.startPage(pn, 5);
		List<MyMessage> messageList=messageService.getAllInboundMessage();
		System.out.println("历史入库记录："+messageList);
		PageInfo page=new PageInfo(messageList,5);
		return Msg.success().add("pageInfo", page);
		
		
	}
	/**
	 * *用来删除记录
	 */
	@ResponseBody
	@RequestMapping(value="/deleteSelectMessage",method = RequestMethod.DELETE)
	public Msg deleteSelectMessage(String messageIds) {
		System.out.println(messageIds);
		//批量删除
		if(messageIds.contains("-")){
			List<Integer> del_ids = new ArrayList();
			//使用-分割productIds,将分割结果拼装成数组
			String[] str_messageIds = messageIds.split("-");
			//遍历并组装id的集合
			for (String string : str_messageIds) {
				del_ids.add(Integer.parseInt(string));
			}
			messageService.deleteMessageByIds(del_ids);
			
		}else {
			//单个删除
			//把string类型转成integer
			Integer messageId = Integer.parseInt(messageIds);
			messageService.deleteMessageById(messageId);
		}		
		return Msg.success();
		
	}
	/**
	 * *用来查看某条记录的详细信息
	 */
	@ResponseBody
	@RequestMapping(value="getSelectMessageDetail",method=RequestMethod.GET)
	public ModelAndView getSelectMessageDetail(HttpServletRequest request,ModelAndView mv) {
		System.out.println("123");
		String messageId=request.getParameter("meId");
		Integer id=Integer.parseInt(messageId);
		MyMessage data=messageService.getSelectMessageDetail(id);
		mv.addObject("data", data);
		mv.setViewName("views/message/seeMoreMessage.jsp");
		return mv;
	}
	/**
	 * *筛选条件
	 */
	 @ResponseBody
	 @RequestMapping(value="getAllMessageByCondition",method=RequestMethod.GET)
	 public Msg getAllMessageByCondition(HttpServletRequest request) {
		 String messageFromUser=request.getParameter("inputFromUser");
		 String messageToUser=request.getParameter("toUser");
		 String startTime=request.getParameter("startTime");
		 String endTime=request.getParameter("endTime");
		 System.out.println(messageFromUser);
		 System.out.println(messageToUser);
		 System.out.println(startTime);
		 System.out.println(endTime);
		 return Msg.success();
	 }
	 
	 /**
	  * *查询message中最后一条记录的id
	  */
	 @ResponseBody
	 @RequestMapping(value="getLastMessageId",method=RequestMethod.GET)
	 public Msg getLastMessageId() throws Exception{
		 MyMessage mm=messageService.getLastMessageId();
		 return Msg.success().add("id",mm.getMessageId()+1);
		 
	 }
	
}

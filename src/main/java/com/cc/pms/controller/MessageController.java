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
 * ʵ��վ���Ź���
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
	 * 1.��ǰ�û���ʱajax��ѯ�Ƿ��յ�����Ϣ
	 * @param����ǰ�û���
	 */
	@ResponseBody
	@RequestMapping(value="/getMessageByUserName",method = RequestMethod.GET)
	@LogAnnotation(value="��ȡ��Ϣ�б�...")
	public Msg getMessageByUserName(@RequestParam(value="myname")String userName) {
		System.out.println(userName);
		List<MyMessage> myMessage=messageService.getMessageByUserName(userName);		
		System.out.println(myMessage);
		return Msg.success().add("myMessage",myMessage);
	}

	/**
	 * �ύվ���š���ʹ��ajax��ѯ
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
	 * ������ʱ������Ϣ
	 * @param
	 * @throws IOException
	 */
	@ResponseBody
	@RequestMapping(value="/receiveMessage",method = RequestMethod.GET)
	public Msg receiveMessage() throws IOException {
		List<MyMessage> mymessage = messageService.getMessage();
		System.out.println("��Ҫ���͵���Ϣ��"+mymessage);
		return Msg.success().add("mymessage", mymessage);

	}
	/**
	 * �����ı���ʾ״̬
	 */
	@ResponseBody
	@RequestMapping(value="/updateDisplayState",method = RequestMethod.GET)
	public Msg updateDisplayState(Integer id) {
		System.out.println("���ݹ�����id�ǣ�"+id);
		messageService.updateDisplayState(id);
		return Msg.success();
	}
	/**
	 * ������ѯ�۵��б���ǰ5����ʷ��¼
	 */
	@ResponseBody
	@RequestMapping(value="getFiveInboundMessage",method=RequestMethod.GET)
	public Msg getFiveInboundMessage() {
		List<MyMessage> messageList=messageService.getAllInboundMessage();
		System.out.println("��ʷ����¼��"+messageList);
		return Msg.success().add("messageList",messageList);
	}
	/**
	 * ������ѯ������ʷ��¼
	 */
	@ResponseBody
	@RequestMapping(value="getAllInboundMessage",method=RequestMethod.GET)
	public Msg getAllInboundMessage(@RequestParam(value="pn",defaultValue="1")Integer pn) {
		PageHelper.startPage(pn, 5);
		List<MyMessage> messageList=messageService.getAllInboundMessage();
		System.out.println("��ʷ����¼��"+messageList);
		PageInfo page=new PageInfo(messageList,5);
		return Msg.success().add("pageInfo", page);
		
		
	}
	/**
	 * *����ɾ����¼
	 */
	@ResponseBody
	@RequestMapping(value="/deleteSelectMessage",method = RequestMethod.DELETE)
	public Msg deleteSelectMessage(String messageIds) {
		System.out.println(messageIds);
		//����ɾ��
		if(messageIds.contains("-")){
			List<Integer> del_ids = new ArrayList();
			//ʹ��-�ָ�productIds,���ָ���ƴװ������
			String[] str_messageIds = messageIds.split("-");
			//��������װid�ļ���
			for (String string : str_messageIds) {
				del_ids.add(Integer.parseInt(string));
			}
			messageService.deleteMessageByIds(del_ids);
			
		}else {
			//����ɾ��
			//��string����ת��integer
			Integer messageId = Integer.parseInt(messageIds);
			messageService.deleteMessageById(messageId);
		}		
		return Msg.success();
		
	}
	/**
	 * *�����鿴ĳ����¼����ϸ��Ϣ
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
	 * *ɸѡ����
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
	  * *��ѯmessage�����һ����¼��id
	  */
	 @ResponseBody
	 @RequestMapping(value="getLastMessageId",method=RequestMethod.GET)
	 public Msg getLastMessageId() throws Exception{
		 MyMessage mm=messageService.getLastMessageId();
		 return Msg.success().add("id",mm.getMessageId()+1);
		 
	 }
	
}

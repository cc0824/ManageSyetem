package com.cc.pms.controller;

import static org.hamcrest.CoreMatchers.nullValue;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.junit.Test.None;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.cc.pms.bean.LogMessage;
import com.cc.pms.bean.Msg;
import com.cc.pms.bean.Product;
import com.cc.pms.bean.Role;
import com.cc.pms.bean.User;
import com.cc.pms.component.LogAnnotation;
import com.cc.pms.service.LogService;
import com.cc.pms.service.RoleService;
import com.cc.pms.service.UserService;
import com.cc.pms.utils.AjaxResult;
import com.cc.pms.utils.IPUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import net.sf.json.JSON;
import net.sf.json.JSONObject;




/**
 * user���Ʋ�
 * 
 */
@Controller
@RequestMapping("/user")
public class UserController{
	@Autowired
	private UserService userService;
	@Autowired
	private RoleService roleService;
	@Autowired
	private LogService logService;
	
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);

	/**
	 * �û�ע�᷽ʽ1 ͬ������ ����ҳ��
	 * һ��һ������������ @RequestParam(value=""Ҫ��Ӧform��input name���ԣ��ͺ����String userNameû��ϵ)
	 * ��ʹ�� @RequestParam����Ҫ��String userName��������form��input name����һ��
	 */
//	@RequestMapping("/register")
//	public String registerUser(@RequestParam(value="userName") String userName,@RequestParam(value="userPassword") String userPassword,HttpSession session) {
//		//1����ȡǰ�����ݣ���װ��map
//		Map<String,Object> map=new HashMap<String,Object>();
//		//���ָ������ Map<String,Object> ������String ��ȷ��ֵ���ַ����������� ��object
//		map.put("userName", userName);
//		map.put("userPassword", userPassword);
//		//2������service����
//		User user=userService.addUser(map);
//		session.setAttribute("user", user);
//		//3��ת����ʽ����ҳ�� ˢ����������ظ��ύ��
//		//return "login";
//		//�ض��򷵻�ҳ�� ��ֹ�ظ��ύ�� ����ע�� 
//		return "redirect:/login.jsp";		
//	}
	/**
	 * �û�ע�᷽ʽ2 �첽����
	 * @ResponseBody�����ؽ��ת��Ϊ�ַ�������JSON����������ʽ���ظ��ͻ���
	 * ���ص�resultֵ��Ҫ�����ַ���ת���� spring-mvc
	 */
//	@ResponseBody
//	@RequestMapping("/register")
//	public Object registerUser(@RequestParam(value="userName") String userName,@RequestParam(value="userPassword") String userPassword,HttpSession session) {
//		AjaxResult result=new AjaxResult();	 	
//		try {
//			Map<String,Object> map=new HashMap<String,Object>();
//			map.put("userName", userName);
//			map.put("userPassword", userPassword);	
//			User user=userService.addUser(map);
//			session.setAttribute("user", user);
//			result.setSuccess(true);
//			//{"success":true}
//		} catch (Exception e) {
//			e.printStackTrace();
//			result.setSuccess(false);
//			result.setMessage("��½ʧ��");
//			//{"success":false,"message":"��½ʧ��"}
//		}
//		return result;
//  }
	
	
	/**
	 * �û�ע�ᣬһ��һ����������form�ύ����û��ת����JSON
	 */
//	@RequestMapping("/register")
//	public String registerUser(@RequestParam(value="userName") String userName,
//			@RequestParam(value="userPassword") String userPassword,
//			HttpSession session,User user) throws Exception {
//	
////		System.out.println(userName);
////		System.out.println(userPassword);
//		user.setUserName(userName);
//		user.setUserPassword(userPassword);
//		userService.addUser(user);
//		session.setAttribute("user", user);
//		return "login";	
//	}
	/**
	 * 1.�û�ע�ᣬ�Ѳ�����װ��userʵ�壬form�ύ����û��ת����JSON
	 * 
	 */
	@RequestMapping("/register")
	public String registerUser(HttpServletRequest request,
			HttpSession session,User user) throws Exception {
		String userName=request.getParameter("userName");
		String userPassword=request.getParameter("userPassword");
//		System.out.println(userName);
//		System.out.println(userPassword);
		user.setUserName(userName);
		user.setUserPassword(userPassword);
		userService.addUser(user);
		session.setAttribute("user", user);

		return "login";

	}

	/**
	 * 2.�û���½
	 * 
	 */
	@RequestMapping("/login")
	@LogAnnotation(value="�û���½...")
	public ModelAndView loginUser(User user,
			HttpSession session,HttpServletRequest request)  {
		System.out.println("ִ��controller����......");
		ModelAndView mav = new ModelAndView();
		Map<String, Object> map = new HashMap<String, Object>();
		String userName=request.getParameter("userName");
		String userPassword=request.getParameter("userPassword");
		String rememberMe=request.getParameter("rememberMe");
		map.put("userName", userName);
		map.put("userPassword", userPassword);
		user=userService.getUser(map);
		/**
		 * �˴�mapperΪuser_name=#{userName} and user_password=#{userPassword}
		 */
//		if (user!= null ) {
//			// ��¼�ɹ�����user�������õ�HttpSession���÷�Χ����
//			session.setAttribute("user", user);
//			// ��ת��ҳ��
//			mav.setViewName("views/home");
//		} else {
//			// ��¼ʧ�ܣ�����ʧ����Ϣ������ת��loginҳ�� ��Ҫ��ǰ̨����EL���ʽ��ȡmessage��ֵ ${message}
//			System.out.println("sdfasf");
//			mav.addObject("message", "��¼���������������������!!!");
//			mav.setViewName("login");
//		}
		/**
		 * �˴�mapperΪuser_name=#{userName} 
		 */
		if(userName==null||"".equals(userName)) {
			//δ��������
			mav.addObject("message", "�������û���");
			mav.setViewName("login");
	    }else if(user==null||"".trim().equals(user)) {
			//��������������������
			mav.addObject("message", "�˻������ڣ�����ע��");
			mav.setViewName("login");
		}else if(user!=null & (userPassword==null||"".equals(userPassword))){
			//������ȷ����û����������
			mav.addObject("message", "����������");	
			mav.setViewName("login");
		}else if(user!=null &! (user.getUserPassword().equals(userPassword))){
			//������ȷ�����������
			mav.addObject("message", "������������µ�½");
			mav.setViewName("login");
		}else if(user!=null &user.getUserPassword().equals(userPassword)){
			session.setAttribute("user", user);
			System.out.println("��ǰ�û���"+user);
			Role role=roleService.getRoleByUserId(user.getUserId());
			System.out.println("��ǰ��ɫ��"+role);
			session.setAttribute("role", role);
			session.setAttribute("rememberMe", rememberMe);
			mav.setViewName("views/mainHome");
			//�����־
//			LogMessage logmsg=new LogMessage(null, user.getUserName(), role.getRoleName(),"�û���½", 
//					DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(LocalDateTime.now()), "�ɹ�", IPUtil.getIpAddress());
//			System.out.println(logmsg);
//			logService.addLog(logmsg);
			
		}
		return mav;
	}

	/**
	 * �����û����ж��û��Ƿ����
	 */
	//@ResponseBody
	@RequestMapping("/checkUser")
	public ModelAndView checkUser(@RequestParam(value="userName") String userName,
			User user,HttpServletResponse response) throws Exception{
		ModelAndView mav=new ModelAndView();
		user =userService.getByUserName(userName);
		if(user!=null) {
			System.out.println("�û����Ѵ���");
			mav.addObject("data",true);
		}else {
			System.out.println("�û���������");	
			mav.addObject("data",false);
		}
		return mav;
						
	} 
	
	/**
	 * 1.��msg.add()������ǰ̨result�в鿴�õ�������
	 * 2.ͬ����mapҲ���ԣ���Ϊmsg.add�������ǽ����ݴ浽map��
	 * model��Ȼ�̳�ModelMap�࣬��Model����������ҳ����ת��url��ַ��������������ת��ַ��������Ҫ��������return
	 * modelandview��Ҫ���÷�����ͼ
	 * @param id
	 * @return
	 * @throws IOException 
	 */	
//	@ResponseBody
//	@RequestMapping(value="/getUserWithRole",method=RequestMethod.GET)
//	public Msg getUserWithRole(Integer id ){
//		User userWithRole=userService.getUserWithRoleById(id);
//		Role findRole = userWithRole.getRole();
//		String roleName= findRole.getRoleName();
//		return Msg.success().add("roleName", roleName);
//	}
	@ResponseBody
	@RequestMapping(value="/getUserWithRole",method=RequestMethod.GET)
	public Map getUserWithRole(Integer id ){
		//����Ա��id��ѯ��ɫ��Ϣ
		Role role = roleService.getRoleByUserId(id);
		String roleName= role.getRoleName();
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("roleName", roleName);
		return map;
	}
	
	
	/**
	 * *��½��Ϣ����
	 * 1.�����û���Ϣ  ����
	 * 2.�����ɫ��Ϣ  ����
	 */
	
	
	/**
	 * *�������Ϣչʾ
	 * 1.��½�û���Ϣ
	 */
	@ResponseBody
	@RequestMapping(value="/getCurrentUserInfo",method=RequestMethod.GET)
	public Msg getCurrentUserInfo(HttpSession session) throws Exception{
		User currentUser =(User) session.getAttribute("user") ;
		Role currentRole =(Role) session.getAttribute("role");
		String currentUserName=currentUser.getUserName();
		String currentRoleName=currentRole.getRoleName();
		System.out.println("��ǰ�û���ɫsession:"+currentUserName+currentRoleName);
		Map<String, Object> currentMap=new HashMap<String, Object>();
		currentMap.put("currentUserName",currentUserName);
		currentMap.put("currentRoleName",currentRoleName);
		currentMap.put("currentState","true");
		return Msg.success().add("currentMap", currentMap);
	}
	
	/**
	 * *�������Ϣչʾ
	 * 2.�˵���Ϣ
	 */
	
	
	/**
	 * *�û�����
	 * 1.չʾ�����û���Ϣ
	 */
	@ResponseBody
	@RequestMapping(value="/getAllUserList",method=RequestMethod.GET)
	public Msg getAllUserList(@RequestParam(value="pn",defaultValue="1")Integer pn) {
		PageHelper.startPage(pn, 10);
		List<User> userList =userService.getAllUserList();
		System.out.println("��ѯ�����û��б�"+userList);
		PageInfo page=new PageInfo(userList,5);
		return Msg.success().add("pageInfo", page); 
		
	}
	/**
	 * *�û�����
	 * 2.չʾ�����û��Ľ�ɫ��Ϣ
	 */
	@ResponseBody
	@RequestMapping(value="/getAllUserWithRole",method=RequestMethod.GET)
	public Map getAllUserWithRole(@RequestParam(value="pn",defaultValue="1")Integer pn){
		PageHelper.startPage(pn, 10);
		List<User> userwithroleList =userService.getAllUserListWithRole();
		PageInfo page=new PageInfo(userwithroleList,5);
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("page", page);
		return map;
	}
	
	/**
	 * �����û�id��ѯ�û���Ϣ
	 */
	@ResponseBody
	@RequestMapping(value="/getSelectUserById",method=RequestMethod.GET)
	public User getSelectUserById(Integer id) {
		return userService.getSelectUserById(id);
	}
	
	/**
	 * �����û�����ѯ�û���Ϣ
	 */
	@ResponseBody
	@RequestMapping(value="/getDataBySearch",method=RequestMethod.GET)
	public Msg getDataBySearch(@RequestParam(value="inputData")String inputData) {
		List<User> searchDatas=userService.getDataBySearch(inputData);
		return Msg.success().add("searchDatas",searchDatas);
	}
	
	/**
	 * ��ѯip��ַ
	 */
	@ResponseBody
	@RequestMapping(value="/getIPBySearch",method=RequestMethod.GET)
	public Msg getIPBySearch(@RequestParam(value="inputData")String inputData) {
		List<String> searchDatas=userService.getIPBySearch(inputData);
		return Msg.success().add("searchDatas",searchDatas);
	}
}

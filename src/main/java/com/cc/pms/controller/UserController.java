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
 * user控制层
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
	 * 用户注册方式1 同步请求 返回页面
	 * 一个一个参数来接收 @RequestParam(value=""要对应form里input name属性，和后面的String userName没关系)
	 * 不使用 @RequestParam，就要求String userName参数名和form里input name属性一致
	 */
//	@RequestMapping("/register")
//	public String registerUser(@RequestParam(value="userName") String userName,@RequestParam(value="userPassword") String userPassword,HttpSession session) {
//		//1、获取前端数据，封装到map
//		Map<String,Object> map=new HashMap<String,Object>();
//		//最好指定泛型 Map<String,Object> 名字用String 不确定值是字符串还是整形 用object
//		map.put("userName", userName);
//		map.put("userPassword", userPassword);
//		//2、调用service方法
//		User user=userService.addUser(map);
//		session.setAttribute("user", user);
//		//3、转发方式返回页面 刷新浏览器会重复提交表单
//		//return "login";
//		//重定向返回页面 防止重复提交表单 重新注册 
//		return "redirect:/login.jsp";		
//	}
	/**
	 * 用户注册方式2 异步请求
	 * @ResponseBody将返回结果转换为字符串，将JSON串以流的形式返回给客户端
	 * 返回的result值需要配置字符串转换器 spring-mvc
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
//			result.setMessage("登陆失败");
//			//{"success":false,"message":"登陆失败"}
//		}
//		return result;
//  }
	
	
	/**
	 * 用户注册，一个一个参数传，form提交数据没有转换成JSON
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
	 * 1.用户注册，把参数封装给user实体，form提交数据没有转换成JSON
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
	 * 2.用户登陆
	 * 
	 */
	@RequestMapping("/login")
	@LogAnnotation(value="用户登陆...")
	public ModelAndView loginUser(User user,
			HttpSession session,HttpServletRequest request)  {
		System.out.println("执行controller方法......");
		ModelAndView mav = new ModelAndView();
		Map<String, Object> map = new HashMap<String, Object>();
		String userName=request.getParameter("userName");
		String userPassword=request.getParameter("userPassword");
		String rememberMe=request.getParameter("rememberMe");
		map.put("userName", userName);
		map.put("userPassword", userPassword);
		user=userService.getUser(map);
		/**
		 * 此处mapper为user_name=#{userName} and user_password=#{userPassword}
		 */
//		if (user!= null ) {
//			// 登录成功，将user对象设置到HttpSession作用范围域中
//			session.setAttribute("user", user);
//			// 跳转到页面
//			mav.setViewName("views/home");
//		} else {
//			// 登录失败，设置失败信息，并跳转到login页面 需要在前台加入EL表达式获取message的值 ${message}
//			System.out.println("sdfasf");
//			mav.addObject("message", "登录名和密码错误，请重新输入!!!");
//			mav.setViewName("login");
//		}
		/**
		 * 此处mapper为user_name=#{userName} 
		 */
		if(userName==null||"".equals(userName)) {
			//未输入姓名
			mav.addObject("message", "请输入用户名");
			mav.setViewName("login");
	    }else if(user==null||"".trim().equals(user)) {
			//输入姓名但是姓名错误
			mav.addObject("message", "账户不存在，请先注册");
			mav.setViewName("login");
		}else if(user!=null & (userPassword==null||"".equals(userPassword))){
			//姓名正确但是没有输入密码
			mav.addObject("message", "请输入密码");	
			mav.setViewName("login");
		}else if(user!=null &! (user.getUserPassword().equals(userPassword))){
			//姓名正确但是密码错误
			mav.addObject("message", "密码错误，请重新登陆");
			mav.setViewName("login");
		}else if(user!=null &user.getUserPassword().equals(userPassword)){
			session.setAttribute("user", user);
			System.out.println("当前用户："+user);
			Role role=roleService.getRoleByUserId(user.getUserId());
			System.out.println("当前角色："+role);
			session.setAttribute("role", role);
			session.setAttribute("rememberMe", rememberMe);
			mav.setViewName("views/mainHome");
			//添加日志
//			LogMessage logmsg=new LogMessage(null, user.getUserName(), role.getRoleName(),"用户登陆", 
//					DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(LocalDateTime.now()), "成功", IPUtil.getIpAddress());
//			System.out.println(logmsg);
//			logService.addLog(logmsg);
			
		}
		return mav;
	}

	/**
	 * 根据用户名判断用户是否存在
	 */
	//@ResponseBody
	@RequestMapping("/checkUser")
	public ModelAndView checkUser(@RequestParam(value="userName") String userName,
			User user,HttpServletResponse response) throws Exception{
		ModelAndView mav=new ModelAndView();
		user =userService.getByUserName(userName);
		if(user!=null) {
			System.out.println("用户名已存在");
			mav.addObject("data",true);
		}else {
			System.out.println("用户名不存在");	
			mav.addObject("data",false);
		}
		return mav;
						
	} 
	
	/**
	 * 1.用msg.add()可以在前台result中查看得到的数据
	 * 2.同理用map也可以，因为msg.add方法就是将数据存到map里
	 * model虽然继承ModelMap类，但Model本身不能设置页面跳转的url地址别名或者物理跳转地址，所以需要额外设置return
	 * modelandview需要配置返回视图
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
		//依据员工id查询角色信息
		Role role = roleService.getRoleByUserId(id);
		String roleName= role.getRoleName();
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("roleName", roleName);
		return map;
	}
	
	
	/**
	 * *登陆信息保存
	 * 1.保存用户信息  见上
	 * 2.保存角色信息  见上
	 */
	
	
	/**
	 * *侧边栏信息展示
	 * 1.登陆用户信息
	 */
	@ResponseBody
	@RequestMapping(value="/getCurrentUserInfo",method=RequestMethod.GET)
	public Msg getCurrentUserInfo(HttpSession session) throws Exception{
		User currentUser =(User) session.getAttribute("user") ;
		Role currentRole =(Role) session.getAttribute("role");
		String currentUserName=currentUser.getUserName();
		String currentRoleName=currentRole.getRoleName();
		System.out.println("当前用户角色session:"+currentUserName+currentRoleName);
		Map<String, Object> currentMap=new HashMap<String, Object>();
		currentMap.put("currentUserName",currentUserName);
		currentMap.put("currentRoleName",currentRoleName);
		currentMap.put("currentState","true");
		return Msg.success().add("currentMap", currentMap);
	}
	
	/**
	 * *侧边栏信息展示
	 * 2.菜单信息
	 */
	
	
	/**
	 * *用户管理
	 * 1.展示所有用户信息
	 */
	@ResponseBody
	@RequestMapping(value="/getAllUserList",method=RequestMethod.GET)
	public Msg getAllUserList(@RequestParam(value="pn",defaultValue="1")Integer pn) {
		PageHelper.startPage(pn, 10);
		List<User> userList =userService.getAllUserList();
		System.out.println("查询到的用户列表："+userList);
		PageInfo page=new PageInfo(userList,5);
		return Msg.success().add("pageInfo", page); 
		
	}
	/**
	 * *用户管理
	 * 2.展示所有用户的角色信息
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
	 * 依据用户id查询用户信息
	 */
	@ResponseBody
	@RequestMapping(value="/getSelectUserById",method=RequestMethod.GET)
	public User getSelectUserById(Integer id) {
		return userService.getSelectUserById(id);
	}
	
	/**
	 * 依据用户名查询用户信息
	 */
	@ResponseBody
	@RequestMapping(value="/getDataBySearch",method=RequestMethod.GET)
	public Msg getDataBySearch(@RequestParam(value="inputData")String inputData) {
		List<User> searchDatas=userService.getDataBySearch(inputData);
		return Msg.success().add("searchDatas",searchDatas);
	}
	
	/**
	 * 查询ip地址
	 */
	@ResponseBody
	@RequestMapping(value="/getIPBySearch",method=RequestMethod.GET)
	public Msg getIPBySearch(@RequestParam(value="inputData")String inputData) {
		List<String> searchDatas=userService.getIPBySearch(inputData);
		return Msg.success().add("searchDatas",searchDatas);
	}
}

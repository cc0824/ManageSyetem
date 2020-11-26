package com.cc.pms.component;


import java.lang.reflect.Method;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.websocket.Session;

import org.apache.log4j.Logger;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.cc.pms.bean.LogMessage;
import com.cc.pms.bean.Role;
import com.cc.pms.bean.User;
import com.cc.pms.service.LogService;
import com.cc.pms.utils.IPUtil;

import org.aspectj.lang.reflect.MethodSignature;

@Aspect//切面类
@Component//添加到bean
public class WebLogAspect {
	@Resource 
	private LogService logService;
    
    private final Logger logger = Logger.getLogger(WebLogAspect.class);
    
    
    //1.配置切入点签名：【*返回值任意类型】【com.cc.pms.controller包名】【..当前包及子包】【*类名】【.*(..)任何方法名，括号表示参数，两个点表示任何参数类型】
    @Pointcut("execution(* com.cc.pms.controller..*.*(..))")
    public void controllerLog(){}
    
    //2.切入点方法执行之前
    @Before("controllerLog()")
    public void logBeforeController(JoinPoint joinPoint) {
    	System.out.println("before......");
        RequestAttributes requestAttributes = RequestContextHolder.getRequestAttributes();//这个RequestContextHolder是Springmvc提供来获得请求的东西
        HttpServletRequest request = ((ServletRequestAttributes)requestAttributes).getRequest();
        //记录url
        logger.info("################URL : " + request.getRequestURL().toString());
        //记录方法
        logger.info("################HTTP_METHOD : " + request.getMethod());
        //记录地址
        logger.info("################IP : " + request.getRemoteAddr());
        //记录请求参数
        logger.info("################THE ARGS OF THE CONTROLLER : " + Arrays.toString(joinPoint.getArgs()));
        //记录包名+类名+方法名
        logger.info("################CLASS_METHOD : " + joinPoint.getSignature().getDeclaringTypeName() + "." + joinPoint.getSignature().getName());
        
        
        //logger.info("################TARGET: " + joinPoint.getTarget());//返回的是需要加强的目标类的对象
        //logger.info("################THIS: " + joinPoint.getThis());//返回的是经过加强后的代理类的对象
    }
    
    //3.切入点方法执行之后
    @AfterReturning(returning = "returnOb", pointcut = "controllerLog()")
    public void doAfterReturning(JoinPoint joinPoint, Object returnOb) {
    	System.out.println("returnning......");
    	try {
			logger.info("################The return of the method is : " + returnOb);
			String targetName = joinPoint.getTarget().getClass().getName();//com.cc.pms.controller.MessageController
			String methodName = joinPoint.getSignature().getName();//getMenu
			//System.out.println(methodName);
			//获取自定义注解
			Object[] arguments = joinPoint.getArgs();  
			Class targetClass = Class.forName(targetName);
			Method[] methods = targetClass.getMethods();
			String value = "";
			for (Method method : methods) {  
				if (method.getName().equals(methodName)) {  
					Class[] classes = method.getParameterTypes();  
					if (classes.length == arguments.length) {  
						value = method.getAnnotation(LogAnnotation.class).value();
						break;  
					}
				}
			}
			writeLogMessage(joinPoint, "成功...", null);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}  
    }
    
    //4.切入点方法抛出异常
    @AfterThrowing(pointcut = "controllerLog()", throwing = "ex")
    public void doAfterThrowing(JoinPoint joinPoint, Exception ex) {
    	System.out.println("throwing......");
        String methodName = joinPoint.getSignature().getName();
        List<Object> args = Arrays.asList(joinPoint.getArgs());
        logger.error("################PointMethod : " + methodName + ",args : " + args + ",exception : " + ex);
        writeLogMessage(joinPoint, "失败...", ex);
    } 
    
    @After("controllerLog()")
    public void doAfter(JoinPoint joinPoint) {
    	System.out.println("after......");
    }
    @Around("controllerLog()")
    public void doAround(JoinPoint joinPoint) {
    	System.out.println("around......");
    }
    

    //5.获取注解方法名称、封装bean、写入数据库
    private String getAnnotationValue(JoinPoint joinPoint) {
    	String value = "";
		try {
			String targetClassName = joinPoint.getTarget().getClass().getName();//全类名
			String targetMethodName = joinPoint.getSignature().getName();//方法名
			//获取自定义注解
			Object[] arguments = joinPoint.getArgs();  
			Class targetClass = Class.forName(targetClassName);
			Method[] methods = targetClass.getMethods();
			for (Method method : methods) {  
				if (method.getName().equals(targetMethodName)) {  
					Class[] classes = method.getParameterTypes();  
					if (classes.length == arguments.length) {  
						value = method.getAnnotation(LogAnnotation.class).value();
						break;  
					}
				}
			}
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		return value;
    	
    }
    private void writeLogMessage(JoinPoint joinPoint, String operateResult, Exception ex) {
    	HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		HttpSession session = request.getSession();
		User user = (User)session.getAttribute("user");
		String operatorName = user==null ? null : user.getUserName();
		Role role = (Role)session.getAttribute("role");
		String operatorRole = role==null ? null : role.getRoleName();
		String operateDesc = getAnnotationValue(joinPoint);
		String operateDate = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(LocalDateTime.now());
		String ip = IPUtil.getIpAddress();
		String operateMethod = request.getMethod();
		String operateParams = Arrays.toString(joinPoint.getArgs());
		String operateExpDetail = "";
		if(ex != null) {
			operateExpDetail = ex.getMessage();
		}
		LogMessage logMessage = new LogMessage(null, operatorName, operatorRole, operateDesc, 
				operateDate, operateResult, ip, operateMethod, operateParams, operateExpDetail);
		System.out.println(logMessage);
		logService.addLog(logMessage);
    }


   

}
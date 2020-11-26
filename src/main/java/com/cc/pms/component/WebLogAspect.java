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

@Aspect//������
@Component//��ӵ�bean
public class WebLogAspect {
	@Resource 
	private LogService logService;
    
    private final Logger logger = Logger.getLogger(WebLogAspect.class);
    
    
    //1.���������ǩ������*����ֵ�������͡���com.cc.pms.controller��������..��ǰ�����Ӱ�����*��������.*(..)�κη����������ű�ʾ�������������ʾ�κβ������͡�
    @Pointcut("execution(* com.cc.pms.controller..*.*(..))")
    public void controllerLog(){}
    
    //2.����㷽��ִ��֮ǰ
    @Before("controllerLog()")
    public void logBeforeController(JoinPoint joinPoint) {
    	System.out.println("before......");
        RequestAttributes requestAttributes = RequestContextHolder.getRequestAttributes();//���RequestContextHolder��Springmvc�ṩ���������Ķ���
        HttpServletRequest request = ((ServletRequestAttributes)requestAttributes).getRequest();
        //��¼url
        logger.info("################URL : " + request.getRequestURL().toString());
        //��¼����
        logger.info("################HTTP_METHOD : " + request.getMethod());
        //��¼��ַ
        logger.info("################IP : " + request.getRemoteAddr());
        //��¼�������
        logger.info("################THE ARGS OF THE CONTROLLER : " + Arrays.toString(joinPoint.getArgs()));
        //��¼����+����+������
        logger.info("################CLASS_METHOD : " + joinPoint.getSignature().getDeclaringTypeName() + "." + joinPoint.getSignature().getName());
        
        
        //logger.info("################TARGET: " + joinPoint.getTarget());//���ص�����Ҫ��ǿ��Ŀ����Ķ���
        //logger.info("################THIS: " + joinPoint.getThis());//���ص��Ǿ�����ǿ��Ĵ�����Ķ���
    }
    
    //3.����㷽��ִ��֮��
    @AfterReturning(returning = "returnOb", pointcut = "controllerLog()")
    public void doAfterReturning(JoinPoint joinPoint, Object returnOb) {
    	System.out.println("returnning......");
    	try {
			logger.info("################The return of the method is : " + returnOb);
			String targetName = joinPoint.getTarget().getClass().getName();//com.cc.pms.controller.MessageController
			String methodName = joinPoint.getSignature().getName();//getMenu
			//System.out.println(methodName);
			//��ȡ�Զ���ע��
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
			writeLogMessage(joinPoint, "�ɹ�...", null);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}  
    }
    
    //4.����㷽���׳��쳣
    @AfterThrowing(pointcut = "controllerLog()", throwing = "ex")
    public void doAfterThrowing(JoinPoint joinPoint, Exception ex) {
    	System.out.println("throwing......");
        String methodName = joinPoint.getSignature().getName();
        List<Object> args = Arrays.asList(joinPoint.getArgs());
        logger.error("################PointMethod : " + methodName + ",args : " + args + ",exception : " + ex);
        writeLogMessage(joinPoint, "ʧ��...", ex);
    } 
    
    @After("controllerLog()")
    public void doAfter(JoinPoint joinPoint) {
    	System.out.println("after......");
    }
    @Around("controllerLog()")
    public void doAround(JoinPoint joinPoint) {
    	System.out.println("around......");
    }
    

    //5.��ȡע�ⷽ�����ơ���װbean��д�����ݿ�
    private String getAnnotationValue(JoinPoint joinPoint) {
    	String value = "";
		try {
			String targetClassName = joinPoint.getTarget().getClass().getName();//ȫ����
			String targetMethodName = joinPoint.getSignature().getName();//������
			//��ȡ�Զ���ע��
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
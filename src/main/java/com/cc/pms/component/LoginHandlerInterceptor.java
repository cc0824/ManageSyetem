package com.cc.pms.component;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.cc.pms.bean.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 	登陆检查，不登录就不能访问系统内界面
 * 	只能访问index.jsp 
 * 	在springmvc.xml中注册拦截器
 * 
 * 	拦截器不拦截jsp页面的原因：需要把jsp页面放在/WEB-INF/
 * 		这样子需要更改springmvc.xml里的视图解析器
 * 		无法直接通过地址栏输入jsp页面地址访问，而是要配置controller跳转
 * 
 * 	所以重写一个filter实现登陆拦截
 * 	
 */
public class LoginHandlerInterceptor implements HandlerInterceptor {
    /**
     * 	目标方法执行之前被调用
     * 	返回true，再执行后续方法
     * 	返回false，就不再执行后续方法
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    	HttpSession session=request.getSession();
    	Object user=session.getAttribute("user");
    	if(user==null) {
    		System.out.println("未登录");
    		return false;
    	}
    	return true;

    }
    
    //这个方法在业务处理器处理完请求后，但是DispatcherServlet 向客户端返回响应前被调用
    //在该方法中对用户请求request进行处理
    //可以对请求域中的属性或者试图做出修改
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }
    
    //这个方法在 DispatcherServlet 完全处理完请求后被调用
    //可以在该方法中进行一些资源清理的操作
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
package com.cc.pms.component;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 	
 * 	在springmvc.xml中注册拦截器
 */
public class TestHandlerInterceptor implements HandlerInterceptor {
    /**
     * 	目标方法执行之前被调用
     * 	返回true，再执行后续方法
     * 	返回false，就不再执行后续方法
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
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

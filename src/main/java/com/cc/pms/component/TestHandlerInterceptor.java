package com.cc.pms.component;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 	
 * 	��springmvc.xml��ע��������
 */
public class TestHandlerInterceptor implements HandlerInterceptor {
    /**
     * 	Ŀ�귽��ִ��֮ǰ������
     * 	����true����ִ�к�������
     * 	����false���Ͳ���ִ�к�������
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    	return true;

    }
    
    //���������ҵ����������������󣬵���DispatcherServlet ��ͻ��˷�����Ӧǰ������
    //�ڸ÷����ж��û�����request���д���
    //���Զ��������е����Ի�����ͼ�����޸�
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        
    }
    
    //��������� DispatcherServlet ��ȫ����������󱻵���
    //�����ڸ÷����н���һЩ��Դ����Ĳ���
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}

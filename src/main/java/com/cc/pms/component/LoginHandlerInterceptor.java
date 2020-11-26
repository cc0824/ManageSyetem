package com.cc.pms.component;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.cc.pms.bean.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 	��½��飬����¼�Ͳ��ܷ���ϵͳ�ڽ���
 * 	ֻ�ܷ���index.jsp 
 * 	��springmvc.xml��ע��������
 * 
 * 	������������jspҳ���ԭ����Ҫ��jspҳ�����/WEB-INF/
 * 		��������Ҫ����springmvc.xml�����ͼ������
 * 		�޷�ֱ��ͨ����ַ������jspҳ���ַ���ʣ�����Ҫ����controller��ת
 * 
 * 	������дһ��filterʵ�ֵ�½����
 * 	
 */
public class LoginHandlerInterceptor implements HandlerInterceptor {
    /**
     * 	Ŀ�귽��ִ��֮ǰ������
     * 	����true����ִ�к�������
     * 	����false���Ͳ���ִ�к�������
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    	HttpSession session=request.getSession();
    	Object user=session.getAttribute("user");
    	if(user==null) {
    		System.out.println("δ��¼");
    		return false;
    	}
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
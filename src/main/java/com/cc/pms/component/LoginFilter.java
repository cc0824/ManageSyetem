package com.cc.pms.component;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.filter.OncePerRequestFilter;
//ɾ��welcome-file
//�������LoginFilter
public class LoginFilter extends OncePerRequestFilter{

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {
		HttpSession session=request.getSession();
    	Object user=session.getAttribute("user");
    	String url=request.getRequestURI();
    	System.out.println(url);
    	if(user==null) {
    		if(url.contains("login")||url.contains("register")) {
    			//����
        		filterChain.doFilter(request, response);
    		}else if(url.equals("/")){
    			request.getRequestDispatcher("/login.jsp").forward(request,response);
    		}else {
    			System.out.println("δ��¼");
        		request.setAttribute("message", "���ȵ�¼");
        		request.getRequestDispatcher("/login.jsp").forward(request,response);
    		}
    	}else {
    		filterChain.doFilter(request, response);
    	}

		
	}

}

package com.cc.pms.component;

import javax.servlet.ServletContextAttributeEvent;
import javax.servlet.ServletContextAttributeListener;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class MyApplicationListener implements ServletContextListener,
	ServletContextAttributeListener{
	
	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		System.getProperties().remove("log4jPath");
	}
 
	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		//String log4jPath=arg0.getServletContext().getRealPath("/");
		String log4jPath=MyApplicationListener.class.getResource("").getPath();
		System.setProperty("log4jPath",log4jPath);
	}

	@Override
	public void attributeAdded(ServletContextAttributeEvent scab) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void attributeRemoved(ServletContextAttributeEvent scab) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void attributeReplaced(ServletContextAttributeEvent scab) {
		// TODO Auto-generated method stub
		
	}

}

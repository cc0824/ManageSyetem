package com.cc.pms.socket;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.web.socket.server.standard.ServletServerContainerFactoryBean;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

/**
 * @Title WebSocketConfig.java
 * @description: websocket����
 * @time ����ʱ�䣺2018��4��26�� ����9:12:44
 **/
//@Configuration
//@EnableWebMvc
//@EnableWebSocket
//public class WebSocketConfig implements WebSocketConfigurer {
//
//	@Override
//	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
//		registry.addHandler(SocketHandler(), "/socketServer").addInterceptors(new HttpSessionHandshakeInterceptor());
//		registry.addHandler(SocketHandler(), "/sockjs/socketServer")
//				.addInterceptors(new HttpSessionHandshakeInterceptor()).withSockJS();
//	}
//
//	@Bean
//	public WebSocketHandler SocketHandler() {
//		return new SocketHandler();
//	}
//
//	/**
//	 * @Title: createWebSocketContainer
//	 * @Description: ����webSocket���� ����tomcat ���Բ�����
//	 * @param @return
//	 * @return ServletServerContainerFactoryBean
//	 * @date createTime��2018��4��26������11:18:28
//	 */
//	@Bean
//	public ServletServerContainerFactoryBean createWebSocketContainer() {
//		ServletServerContainerFactoryBean container = new ServletServerContainerFactoryBean();
//		container.setMaxTextMessageBufferSize(8192);
//		container.setMaxBinaryMessageBufferSize(8192);
//		return container;
//	}
//
//
//
//}

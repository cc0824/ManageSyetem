package com.cc.pms.socket;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import com.cc.pms.bean.User;

/**
 * WebSocket ÊÊÅäÆ÷ À¹½ØÆ÷
 * @author 18379
 *
 */
public class WebSocketInterceptor implements HandshakeInterceptor {

	private final static Logger log = Logger.getLogger(WebSocketInterceptor.class);

	@Override
	public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler handler,
			Exception exceptions) {
		log.info("=================Ö´ÐÐ afterHandshake £ºhandler: " + handler + "exceptions: " + exceptions);
	}

	@Override
	public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler handler,
			Map<String, Object> map) throws Exception {
		log.info("==================Ö´ÐÐ beforeHandshake £ºhandler: " + handler + "map: " + map.values());
		if (request instanceof ServerHttpRequest) {
			ServletServerHttpRequest servletRequest = (ServletServerHttpRequest) request;
			HttpSession session = servletRequest.getServletRequest().getSession();
			if (session != null) {
				User user = (User) session.getAttribute("user");
				map.put(String.valueOf(user.getUserId()), user);
			}
		}
		return true;
	}
}

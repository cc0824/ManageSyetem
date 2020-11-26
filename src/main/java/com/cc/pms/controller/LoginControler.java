package com.cc.pms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class LoginControler {
	@RequestMapping("/")
	public String toLogin() {
		return "login";
	}
	

}

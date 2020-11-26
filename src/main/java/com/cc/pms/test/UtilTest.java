package com.cc.pms.test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import com.cc.pms.bean.User;
import com.cc.pms.utils.JsonUtil;
import com.fasterxml.jackson.core.type.TypeReference;

public class UtilTest {
	public static void main(String[] args) {
		//1.����objתjson
		User user1 = new User();
        user1.setUserName("suddev");
        user1.setUserId(123);
        String s1 = JsonUtil.obj2String(user1);
        System.out.println(s1);
        //2.����������
        User user2 = new User();
        user2.setUserName("suddev");
        user2.setUserId(123);
        String s2 = JsonUtil.obj2StringPretty(user2);
        System.out.println(s2);
        //3.����jsonתobj
        String s3 = "{\"id\":123,\"username\":\"suddev\"}";
        User user3 = JsonUtil.string2Obj(s3,User.class);
		//5.����jsonת����obj����������������
        User u51 = new User();
        u51.setUserName("aaa");
        u51.setUserId(1);
        User u52 = new User();
        u52.setUserName("bbb");
        u52.setUserId(2);
        List<User> userList5 = new ArrayList<User>();
        userList5.add(u51);
        userList5.add(u52);
        String userListStr5 = JsonUtil.obj2StringPretty(userList5);
        // ���δ��뼯���Լ������ж������͵�class
        List<User> userListObj5 = JsonUtil.string2Obj(userListStr5,List.class,User.class);
        
	}

}

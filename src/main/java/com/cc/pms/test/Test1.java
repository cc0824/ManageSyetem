package com.cc.pms.test;

import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import com.alibaba.fastjson.JSONObject;


public class Test1 {
	public static void main(String[] args) {
		String result="DecisionTreeClassificationModel (uid=dtc_a428b0a52b77) of depth 2 with 5 nodes\r\n" + 
				"  If (feature 2 <= 2.5999999999999996)\r\n" + 
				"   Predict: 0.0\r\n" + 
				"  Else (feature 2 > 2.5999999999999996)\r\n" + 
				"   If (feature 3 <= 1.75)\r\n" + 
				"    Predict: 2.0\r\n" + 
				"   Else (feature 3 > 1.75)\r\n" + 
				"    Predict: 1.0\r\n" + 
				"";
		JSONObject jo = JSONObject.parseObject(new String(result));
		System.out.println(jo.toJSONString());
	}

}

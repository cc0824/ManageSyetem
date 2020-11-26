package com.cc.pms.utils;
/**
 * 0.�������ݿ��ȡ��������-->json
 * @author cc
 *
 */


import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.util.List;

public class JdbcJsonUtil {
	public static void main(String[] args) {
		String inp="[Product[productId=85,productName=ţ��2,productCost=null,productPrice=null,productArea=null]]";
	}
	/**
	 * 1.�������
	 * @param object
	 * @return
	 */
	public static String objectToJson(Object object) {   
		StringBuilder json = new StringBuilder();   
		if (object == null) {   
			json.append("\"\"");   
		} else if (object instanceof String || object instanceof Integer) { 
			json.append("\"").append(object.toString()).append("\"");  
	    } else {   
	        json.append(beanToJson(object));   
	    }   
		return json.toString();   
	}   
 
    /**
     * 2.��������һ�� javabean ��������һ��ָ�������ַ���
     * @param bean
     * @return
     */
	public static String beanToJson(Object bean) {   
        StringBuilder json = new StringBuilder();   
        json.append("{");   
        PropertyDescriptor[] props = null;   
        try {   
        	props = Introspector.getBeanInfo(bean.getClass(), Object.class)   
                    .getPropertyDescriptors();   
        } 
        catch (IntrospectionException e) {   
        }   
        if (props != null) {   
        	for (int i = 0; i < props.length; i++) {   
        		try {  
                    String name = objectToJson(props[i].getName());   
                    String value = objectToJson(props[i].getReadMethod().invoke(bean));  
                    json.append(name);   
                    json.append(":");   
                    json.append(value);   
                    json.append(",");  
                } 
        		catch (Exception e) {   
                }   
            }   
            json.setCharAt(json.length() - 1, '}');   
        } else {   
            json.append("}");   
        }   
        return json.toString();   
    }   
 
	/**
	 * 3.ͨ������һ���б����,����ָ���������б��е���������һ��JSON���ָ���ַ���
	 * @param list
	 * @return
	 */
	public static String listToJson(List<?> list) {   
        StringBuilder json = new StringBuilder();   
        json.append("[");   
        if (list != null && list.size() > 0) {   
           for (Object obj : list) {   
                json.append(objectToJson(obj));   
                json.append(",");   
            }   
            json.setCharAt(json.length() - 1, ']');   
        } else {   
        	json.append("]");   
        }   
        return json.toString();   
    }
}



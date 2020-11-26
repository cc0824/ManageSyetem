package com.cc.pms.utils.decisionTreeUtil;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import com.alibaba.fastjson.JSONArray;
import com.cc.pms.bean.TreeNode;


public class ParseJsonUtil {
	static int index=1;//str id
	static int nodeIndex=1;
	public static void main(String[] args) {
		String str="DecisionTreeClassificationModel (uid=dtc_a428b0a52b77) of depth 2 with 5 nodes\n" + 
				"  If (feature 2 <= 2.60)\n" + 
				"   Predict: 0.0\n"  + 
				"  Else (feature 2 > 2.60)\n" + 
				"   If (feature 3 <= 1.75)\n" + 
				"    Predict: 2.0\n" + 
				"   Else (feature 3 > 1.75)\n" + 
				"    Predict: 1.0\n" + 
				"";
		String res=parseTreeToJson(str);
		System.out.println(res);
	}
	public static String mainMethod() {
		
		String str="DecisionTreeClassificationModel (uid=dtc_a428b0a52b77) of depth 2 with 5 nodes\r\n" + 
				"  If (feature 2 <= 2.60)\n" + 
				"   Predict: 0.0\r\n"  + 
				"  Else (feature 2 > 2.60)\r\n" + 
				"   If (feature 3 <= 1.75)\r\n" + 
				"    Predict: 2.0\r\n" + 
				"   Else (feature 3 > 1.75)\r\n" + 
				"    Predict: 1.0\r\n" + 
				"";
		String str2="DecisionTreeClassificationModel (uid=dtc_8a8704197f32) of depth 3 with 13 nodes\r\n" + 
				"  If (feature 2 in {1.0})\r\n" + 
				"   If (feature 0 in {1.0,2.0})\r\n" + 
				"    If (feature 1 <= 9.5)\r\n" + 
				"     Predict: 1.0\r\n" + 
				"    Else (feature 1 > 9.5)\r\n" + 
				"     Predict: 0.0\r\n" + 
				"   Else (feature 0 not in {1.0,2.0})\r\n" + 
				"    If (feature 1 <= 26.5)\r\n" + 
				"     Predict: 1.0\r\n" + 
				"    Else (feature 1 > 26.5)\r\n" + 
				"     Predict: 0.0\r\n" + 
				"  Else (feature 2 not in {1.0})\r\n" + 
				"   If (feature 0 in {1.0,2.0})\r\n" + 
				"    If (feature 0 in {1.0})\r\n" + 
				"     Predict: 1.0\r\n" + 
				"    Else (feature 0 not in {1.0})\r\n" + 
				"     Predict: 0.0\r\n" + 
				"   Else (feature 0 not in {1.0,2.0})\r\n" + 
				"    Predict: 1.0";
		String[] splitStr=str.split("\\\r\n");
		String[] temp=splitStr[0].split("\\=");
		String[] temp1=temp[1].split("\\)");
		String temp2=temp1[1].replaceAll(" ","");
		int num1=Integer.parseInt(temp2.substring(7,temp2.indexOf('w')));
		int num2=Integer.parseInt( (String)Pattern.compile("[^0-9]").matcher(temp2.substring(temp2.indexOf('w'))).replaceAll("") );
		System.out.println(num1);
		System.out.println(num2);
		//决策树模型文字描述
		String treeDes="当前模型编号为"+temp1[0]+"，参与判断的属性共有"+num2+"个，最多经过"
				+num1+"次判断。";
		
		TreeNode rootNode=new TreeNode(0,-1,treeDes);
		TreeNode cur=rootNode;
		addNode(index,cur,splitStr);
		
		//打印树模型
		String s="";
		String res=printNode(rootNode,s);
		System.out.println(res);
		return res;
			
	}
	public static String parseTreeToJson(String tree) {
		String[] splitStr=tree.split("\\n");
		String[] temp=splitStr[0].split("\\=");
		String[] temp1=temp[1].split("\\)");
		String temp2=temp1[1].replaceAll(" ","");
		int num1=Integer.parseInt(temp2.substring(7,temp2.indexOf('w')));
		int num2=Integer.parseInt( (String)Pattern.compile("[^0-9]").matcher(temp2.substring(temp2.indexOf('w'))).replaceAll("") );
		System.out.println(num1);
		System.out.println(num2);
		//决策树模型文字描述
		String treeDes="当前模型编号为"+temp1[0]+"，参与判断的属性共有"+num2+"个，最多经过"
				+num1+"次判断。";
		
		TreeNode rootNode=new TreeNode(0,-1,treeDes);
		TreeNode cur=rootNode;
		addNode(index,cur,splitStr);
		
		//打印树模型
		String s="";
		String res=printNode(rootNode,s);
		System.out.println(res);
		return res;
	}
	public static String printNode(TreeNode treeNode,String s) {
		if(treeNode==null) return s;
		s+="{";
		if(s.length()-2>0&&s.charAt(s.length()-1)=='{'&&s.charAt(s.length()-2)=='}') {
			s=s.substring(0, s.length()-1)+",{";
			
		}
		s+="\"children\":[";
		if(treeNode.left!=null) {
			s=printNode(treeNode.left,s);
		}
		if(treeNode.right!=null) {
			s=printNode(treeNode.right,s);
		}
		s+="]";
		s+=",\"name\":"+"\""+treeNode.getVal()+"\""+"}";
		
		return s;
	}
	public static TreeNode addNode(int i ,TreeNode treeNode,String[] splitStr) {
		TreeNode cur=treeNode;
		if(i>splitStr.length-1) return cur;
		if(splitStr[i].trim().startsWith("If")) {
			//如果以if开头，只能是if...predict、if...if...两种情况
			StringBuilder des = new StringBuilder("判断条件：");
			des.append(splitStr[i].substring(splitStr[i].indexOf("(")+1, splitStr[i].indexOf(")")));
			cur.setLeft(new TreeNode(nodeIndex,cur.getId(),des.toString()));
			index++;
			if(splitStr[i+1].trim().startsWith("Predict")) {
				String[] temp=splitStr[i+1].split("\\: ");
				des.append("，属于类型："+temp[1]);
				cur.setLeft(new TreeNode(index-1,cur.getId(),des.toString()));
				index++;
				addNode(index,cur,splitStr);
			}else {
				addNode(index,cur.getLeft(),splitStr);
			}
			
		}
		//如果以else开头，else...if...或者else...predict
		else if(splitStr[i].trim().startsWith("Else")) {
			StringBuilder des = new StringBuilder("判断条件：");
			des.append(splitStr[i].substring(splitStr[i].indexOf("(")+1, splitStr[i].indexOf(")")));
			cur.setRight(new TreeNode(index,cur.getId(),des.toString()));
			index++;
			if(splitStr[i+1].trim().startsWith("Predict")) {
				String[] temp=splitStr[i+1].split("\\: ");
				des.append("，属于类型："+temp[1]);
				cur.setRight(new TreeNode(index-1,cur.getId(),des.toString()));
				index++;
				addNode(index,cur,splitStr);
			}else {
				addNode(index,cur.getRight(),splitStr);
			}
			
		}	
		return cur;
	}
}


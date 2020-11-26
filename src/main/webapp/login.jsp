<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备相应布局 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>登陆页面</title>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!-- web路径：
不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306)；需要加上项目名
		http://localhost:3306/crud
 -->
<!-- 引入jquery -->
<script type="text/javascript"
	src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<!-- 引入bootstrap -->
<link
	href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<script type="text/javascript">

function remember(){
	//选中记住密码触发事件，如果选中就赋值为1 ，否则赋值为0
    var remFlag = $("input:checkbox").is(':checked');
    if(remFlag){ 
        //cookie存用户名和密码,回显的是真实的用户名和密码,存在安全问题.
        var conFlag = confirm("记录密码功能不宜在公共场所使用,以防密码泄露.您确定要使用此功能吗?");
        if(conFlag){ 
            //确认标志
            $("#rememberMe").val("1");
        }else{
            $("input:checkbox").removeAttr('checked');
            $("#rememberMe").val("0");
        }
    }else{ 
        //如果没选中设置remFlag为""
        $("#rememberMe").val("0");
    }
}
$(function(){
	//判断message是否为空
	var flag="${empty message}";
	//不为空
	if (flag=="false"){
		$("#warningDiv").addClass("alert alert-warning");
	}
	
	//记住密码功能
	var userSession="<%=session.getAttribute("user")%>"; 
	var remSession="<%=session.getAttribute("rememberMe")%>"; 
	if(userSession!="null" && remSession!="null"){
		strs = userSession.split(","); //字符分割
		var mynames=strs[0].split(":");
		var myname=mynames[1];
		var mypwds=strs[1].split(":");
		var mypwd=mypwds[1];
		var remMes=strs[1].split(":");
		console.log(myname);
		console.log(mypwd);
		if(myname!=null && mypwd!=null){
			$("input[type='checkbox']").attr("checked","true");   
			$("#inputUserName").val(myname);
			$("#inputPassword").val(mypwd);
		}
		else{
			$("input[type='checkbox']").attr("checked","false");   
			$("#inputUserName").val("");
			$("#inputPassword").val("");
		}
	}
	
	
	
	//记住密码
// 	function setCookie(){
// 		var userName = $('#inputUserName').val();
// 		var passWord = $('#inputPassword').val(); 
// 		var flag = $("input[type='checkbox']").is(":checked");//获取是否选中
// 		if(flag==true){//如果选中-->记住密码登录
// 			$.cookie("userName",userName.trim(),7);//有效时间7天，也可以设置为永久，把时间去掉就好
// 			$.cookie("passWord",passWord.trim(),7);
// 			alert("记住密码");
// 		}else{//如果没选中-->不记住密码登录
// 			$.cookie("passWord", "");
// 			$.cookie("userName", "");
// 			alert("没有记住密码");
// 		}  
// 	}
// 	//自动填充密码
// 	function getCookie(){ //获取cookie    
//         var userName = $.cookie("userName"); //获取cookie中的用户名    
//         var pwd =  $.cookie("passWord"); //获取cookie中的登陆密码    
//         if(pwd){//密码存在的话，把“记住用户名和密码”复选框勾选住    
//            $("input[type='checkbox']").attr("checked","true");    
//         }    
//         if(userName!=""){//用户名存在的话把用户名填充到用户名文本框    
//            $("#inputUserName").val(userName);    
//         }else{
//        	 $("#inputUserName").val("");
//         }
//         if(pwd!=""){//密码存在的话把密码填充到密码文本框    
//        	  $("#inputPassword").val(pwd); 
//         }else{
//        	 $("#inputPassword").val(""); 
//         }
//    	} 
	//登录
// 	function tologin(){
// 		var userName = $('#inputUserName').val();
// 		var passWord = $('#inputPassword').val(); 
// 		var flag = $("input[type='checkbox']").is(":checked");//获取选中状态
// 		console.log(flag);
// 	    if(flag==true){
// 			setCookie();   //调用设置Cookie的方法 
// 	    }
		
// 	}
	
	


})
</script>
</head>
<style>

</style>
<body>
	<!-- 搭建登陆界面 -->
	<!-- 导航 -->
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#myNavbar">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="#">管理系统</a>
			</div>
			<div class="collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav">
					<li class="active"><a href="#">主页</a></li>
<!-- 					<li><a href="#">页1</a></li> -->
<!-- 					<li><a href="#">页2</a></li> -->
				</ul>
			</div>
		</div>
	</nav>
	<div class="container ">
		<!-- 标题 -->
		<div class="row">
			<div class="col-xs-offset-3 col-xs-6 text-center">
				<h3>用户登陆</h3>
				<br></br>
			</div>
		</div>
		<!-- 使用水平排列的表单 -->
		<form class="form-horizontal"
			id="loginForm" action="${pageContext.request.contextPath }/user/login.do" method="post">
			<div class="form-group">
				<label for="inputUserName" class="col-xs-3 control-label text-right">用户名</label>
				<div class="col-xs-6">
					<input type="text" class="form-control" id="inputUserName"
						name="userName" placeholder="请输入用户名">
					<span id="inputUserNameSpan"></span>
				</div>
			</div>
			<div class="form-group">
				<label for="inputPassword" class="col-xs-3 control-label text-right">密码</label>
				<div class="col-xs-6">
					<input type="password" class="form-control" id="inputPassword"
						name="userPassword" placeholder="请输入密码">
					<span id="inputPasswordLabel"></span>
				</div>
			</div>
			<div class="form-group">
				<div class="col-xs-offset-3 col-xs-6">
					<div class="checkbox">
						<label> <input type="checkbox" name="rememberMe" id="rememberMe" onclick="remember();">记住密码</label>						
					</div>
				</div>
			</div>
			<div style="text-align: center;"  id="warningDiv">
				<label >${message}</label>
			</div>
			<div class="form-group">
				<div class="col-xs-offset-3 col-xs-6">
					<button type="submit" class="btn btn-success btn-block" id="login-btn" >登陆</button>
				</div>
			</div>
			<div class="form-group">
				<div class="col-xs-offset-3 col-xs-6">
					<button type="button" class="btn btn-success btn-block"
						onclick="window.location.href= '${pageContext.request.contextPath}/views/register.jsp'">注册</button>
				</div>
			</div>
		</form>
	</div>


</body>
</html>
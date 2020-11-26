<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备相应布局 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>注册页面</title>
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
	//注册验证 同步请求
	// function doregister(){
	// 	$("#registerForm").submit();	
	// }

	$(document).ready(function() {
		//验证用户名是否输入并检验用户名是否存在
		$("#inputUserName").blur(function() {
			var userName = $("#inputUserName").val();
			if ($.trim(userName) == "") {
				//debugger;//浏览器f12，source下f10调试
				confirm("用户名不能为空，请重新输入!");
				return false;
			}
			$.ajax({
				type : "POST",
				async : false,
				url : "${pageContext.request.contextPath }/user/checkUser.do",
				//timeout:5000,
				data : userName = $("#inputUserName"),
				//data:$("#registerForm").serialize(),
				dataType : "json",
				success : function(data) {
					data = eval('('+ data+ ')');
					if (data == true) {
						$("#checkUserName").html("<font color='red'>该用户名已被使用</font>");
						return false;
					} else {
						$("#checkUserName").html("<font color='blue'>该用户名可以使用</font>");
						return true;
					}
				},
				error : function() {
					alert("获取数据失败");
				}
			})

		})
	})
			// 	//验证密码是否输入
			// 	$("#inputPassword1").blur(function(){
			// 		var userPassword1 = $("#inputPassword1").val();
			// 		if($.trim(userPassword1)=="") {
			//         	confirm("密码不能为为空，请重新输入!");
			//         	return false; //后面代码不执行
			// 		}else{
			// 			return true;
			// 		}
			// 	})
			// 	//验证两次密码是否输入输入一致
			// 	$("#inputPassword2").blur(function(){
			// 		var userPassword1 = $("#inputPassword1").val();
			// 		var userPassword2 = $("#inputPassword2").val();
			// 		if($.trim(userPassword1)!=$.trim(userPassword2)) {
			//         	confirm("两次输入密码不一致!");
			//         	return false; //后面代码不执行
			// 		}else{
			// 			return true;
			// 		}
			// 	})

			

			//    	   success : function(result){ //{"success":true}  或    {"success":false,"message":"登录失败!"}
			// 			if(result.success){    				
			// 				//跳转登陆页面.
			// 				window.location.href="${pageContext.request.contextPath}/login.jsp";
			// 			}else{
			// 				alert("not ok");
			// 			}
			// 		},
</script>
</head>
<body>
	<!-- 搭建注册界面 -->
	<!-- 导航 -->
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#myNavbar">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand"
					href="${pageContext.request.contextPath}/login.jsp">管理系统</a>
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
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-xs-offset-3 col-xs-6 text-center">
				<h3>用户注册</h3>
				<br></br>
			</div>
		</div>
		<!-- 使用水平排列的表单 -->
		<form class="form-horizontal"
			action="${pageContext.request.contextPath }/user/register.do"
			method="post" id="registerForm" name="registerForm">
			<div class="form-group">
				<label for="inputUserName" class="col-xs-3 control-label text-right">用户名</label>
				<div class="col-xs-6">
					<input type="text" class="form-control" id="inputUserName"
						name="userName" placeholder="请输入用户名""> <span
						id="checkUserName"></span>
				</div>
			</div>
			<div class="form-group">
				<label for="inputPassword1"
					class="col-xs-3 control-label text-right">密码</label>
				<div class="col-xs-6">
					<input type="password" class="form-control" id="inputPassword1"
						name="userPassword" placeholder="请输入密码">
				</div>
			</div>
			<div class="form-group">
				<label for="inputPassword2"
					class="col-xs-3 control-label text-right">确认密码</label>
				<div class="col-xs-6">
					<input type="password" class="form-control" id="inputPassword2"
						placeholder="请再次输入密码">
				</div>
			</div>
			<div class="form-group">
				<label for="email" class="col-xs-3 control-label text-right">所属角色</label>
				<div class="col-xs-6">
					<!-- Single button -->
					<!--  <select class="form-control">
						<option>1</option>
						<option>2</option>
						<option>3</option>
						<option>4</option>
						<option>5</option>
					</select>-->
					<div class="btn-group dropdown" id="dropdown">
						<button type="button" class="btn btn-default dropdown-toggle"
							data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							普通用户 <span class="caret"></span>
						</button>
						<input type="hidden" name="hidedrop_1" id="hidedrop_1"
							value="超级管理员" />
						<ul class="dropdown-menu">
							<li><a href="#">店长</a></li>
							<li role="separator" class="divider"></li>
							<li><a href="#">库管员</a></li>
							<li role="separator" class="divider"></li>
							<li><a href="#">理货员</a></li>
							<li role="separator" class="divider"></li>
							<li><a href="#">收银员</a></li>
						</ul>
					</div>

				</div>
				<div class="col-xs-4 tips"></div>
			</div>

			<div class="form-group">
				<div class=" col-xs-offset-3 col-xs-6">
					<button type="submit" class="btn btn-success btn-md btn-block"
						id="register-btn" onclick="doregister()">注册</button>
				</div>
			</div>
		</form>
	</div>

</body>
</html>
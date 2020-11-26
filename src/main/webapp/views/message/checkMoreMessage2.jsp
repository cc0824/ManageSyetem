<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备相应布局 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>商品管理页面</title>
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
	$(function() {
		
		/****************************************************************/
		/*******************调整顶部导航栏按钮的margin*******************/
		/****************************************************************/
		var width=document.body.clientWidth;
		var a=(width-232-2*10)/2;
		console.log("a="+a+'px');
		$("#topNavbarLeftButton").css({"margin-right":a+'px'});
		$("#topNavbarRightButton").css({"margin-left":a+'px'});
		//调整底部导航栏按钮的margin
		var b=(width-310-2*10)/2;
		console.log("b="+b+'px');
		$("#bottomNavbarLeftButton").css({"margin-right":b+'px'});
		$("#bottomNavbarRightButton").css({"margin-left":b+'px'});
		

		
	})
</script>
<style type="text/css">
#button2 {
	text-align: right
}

#page1 {
	text-align: center
}

#page2 {
	text-align: center
}
#label1{
	text-align: center
}

#topNavbarRightButton{
	float:none;
}
#topNavbarLeftButton{
/* 	margin-top:8px; */
/* 	margin-bottom:8px; */
	margin:0 auto;
	padding:7px 12px 7px 12px;/* 上右下左 */
}
</style>
</head>
<body>
	<!-- 搭建显示界面 -->
	<!-- 顶部导航 -->
	<nav class="navbar navbar-default navbar-fixed-top" >
	<div class="container-fluid" >
		<div class="navbar-header" style="text-align:center;">
			<button type="button" class="btn btn-default btn-lg" onclick="javascript:history.back(-1)" id="topNavbarLeftButton">
        		<span class="glyphicon glyphicon-arrow-left"></span>
    		</button>
			<a  href="#"  style="font-size:18px;font-color:rgb(51,122,183)">收件箱</a>
  			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target="#myNavbar" id="topNavbarRightButton">
				<!-- 按钮有三个横线 -->
				<span class="icon-bar"></span> 
				<span class="icon-bar"></span> 
				<span class="icon-bar"></span>
			</button>
		</div>
		<div class="collapse navbar-collapse" id="myNavbar">
			<ul class="nav navbar-nav">
				<li class="active"><a href="${pageContext.request.contextPath }/views/background/backgroundhome.jsp">后台管理</a></li>
<%-- 			<li><a href="${pageContext.request.contextPath }/login.jsp">退出登陆</a></li> --%>
				<li><a href="javascript:logout()">退出登陆</a></li>
			</ul>
		</div>
	</div>
	</nav>

	<div class="container" style="margin-bottom: 50px;margin-top: 65px">
		<!-- 页面 -->
		<div class="row ">
			<div style="text-align: center">
				<label  >信息管理</label>

				<button type="button" class="btn btn-info btn-sm col-xs-offset-7" id="searchButton">
					<span class="glyphicon glyphicon-search" aria-hidden="true"></span> 搜索
				</button>
			</div>
		</div>
		<div><label></label></div>
		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title">入库申请</h3>
		    </div>
		    <div class="panel-body">
		        申请人：b，申请时间：2020-10-08 14:30
		    </div>
		</div>
		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title">入库申请</h3>
		    </div>
		    <div class="panel-body">
		        申请人：c，申请时间：2020-10-08 14:00
		    </div>
		</div>
		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title">入库申请</h3>
		    </div>
		    <div class="panel-body">
		        申请人：b，申请时间：2020-10-05 12:00
		    </div>
		</div>
		<div class="panel panel-primary">
		    <div class="panel-heading">
		        <h3 class="panel-title">入库申请</h3>
		    </div>
		    <div class="panel-body">
		        申请人：b，申请时间：2020-09-25 16:43
		    </div>
		</div>
		<div class="panel panel-info">
		    <div class="panel-heading">
		        <h3 class="panel-title">入库申请</h3>
		    </div>
		    <div class="panel-body">
			申请人：c，申请时间：2020-09-20 13:17
		    </div>
		</div>
		<div class="panel panel-info">
		    <div class="panel-heading">
		        <h3 class="panel-title">出库申请</h3>
		    </div>
		    <div class="panel-body">
		        申请人：b，申请时间：2020-09-15 10:30
		    </div>
		</div>
		<div class="panel panel-info">
		    <div class="panel-heading">
		        <h3 class="panel-title">入库申请</h3>
		    </div>
		    <div class="panel-body">
		        申请人：b，申请时间：2020-09-05 18:50
		    </div>
		</div>

		
		

	</div>
	
	<!-- 底部导航 -->
	<nav class="navbar navbar-default navbar-fixed-bottom" role="navigation">
    <div class="container-fluid">
    <div class="row">
		<div style="display: inline;">
			<button type="button" class="btn btn-default btn-lg " 
	 			style="width: 90px;background: transparent;border: none;margin-left:20px "> 
	 			<a href="javascript:history.back(-1)">返回 </a> 
	 		</button>
	 	</div> 
		<div style="display: inline;left:35%;right:35%;position:absolute">
			<button type="button" class="btn btn-default btn-lg  "
				style="width: 90px;background:transparent;border: none;text-align: center;margin:0 auto;display:block;">
				<a href="#">首页 </a>
			</button>
		</div>
		<div style="display: inline;">
			<button type="button" class="btn btn-default btn-lg " 
 				style="width: 90px; background: transparent;border: none;margin-right:20px;position:fixed;right: 0px"> 
 				<a href="#">消息 <span class="badge" id="messageNum">4</span></a> 
			</button>
		</div> 
	</div>
    </div>
    </nav>




</body>

</html>
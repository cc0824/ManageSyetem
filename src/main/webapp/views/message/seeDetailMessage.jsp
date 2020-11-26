<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备上进行绘制和触屏缩放 -->
<meta name="viewport" content="width=device-width, initial-scale=1">



<title>系统界面</title>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!-- ========================================== -->
<!-- web路径：不以/开始的相对路径，找资源是以当前资源的路径为基准，比如index.jsp是在webapp下，src就从webapp开始，但容易出错 -->
<!-- 以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306),且需要加上项目名称
     http://localhost:3306/crudtest>
<!-- ========================================== -->
<!-- 引入jquery -->
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<!-- 引入样式Bootstrap -->
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<!-- 引入日期插件 -->
<script src="${APP_PATH }/static/laydate/laydate.js"></script>


<script type="text/javascript">
	function logout() {
		if (confirm("确定要退出登陆吗？")) {
			sessionStorage.clear();
			window.location.href = "${pageContext.request.contextPath}/login.jsp";
		}
	}
	
	$(function() {
		
		console.log(result);
		
		
	})
</script>
<style type="text/css">

.demo-input{padding-left: 10px; height: 38px; min-width: 262px; line-height: 38px; border: 1px solid #e6e6e6;  background-color: #fff;  border-radius: 2px;}
</style>
</head>
<body>
	<!-- 搭建系统主页 -->
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
				<li class="active"><a
					href="${pageContext.request.contextPath }/views/background/backgroundhome.jsp">后台管理</a></li>
				<%-- 			<li><a href="${pageContext.request.contextPath }/login.jsp">退出登陆</a></li> --%>
				<li><a href="javascript:logout()">退出登陆</a></li>
			</ul>
		</div>
	</div>
	</nav>
	<div id="inputForm">
		<form class="form-horizontal" id="productAddForm">
			<div class="form-group">
				<label for="inputRole" class="col-xs-4 control-label" style="text-align: right">申请人名称</label>
				<div class="col-xs-5">
					<input type="text" class="form-control" id="inputFromUser"
						placeholder="申请人">
				</div>
			</div>
			<div class="form-group">
				<label for="inputToRole" class="col-xs-4 control-label" style="text-align: right">审批人名称</label>
				<div class="col-xs-5">
					<input type="text" class="form-control" id="inputToUser"
						placeholder="审批人"></input>
				</div>
			</div>
			<div class="form-group">
				<label for="inputToRole" class="col-xs-4 control-label" style="text-align: right">开始时间</label>
				<div class="col-xs-5">
					<input type="text" class="form-control" 
						class="demo-input" placeholder="请选择日期" id="test1"></input>
				</div>
			</div>
			<div class="form-group">
				<label for="inputToRole" class="col-xs-4 control-label" style="text-align: right">结束时间</label>
				<div class="col-xs-5">
					<input type="text" class="form-control" 
						class="demo-input" placeholder="请选择日期" id="test2"></input>
				</div>
			</div>
		
			
			<div class="form-group">
				<div class="col-xs-offset-8 ">
					<button class="btn btn-success" id="message_select_btn">筛选</button>
				</div>
			</div>
		</form>
	</div>
	<div class="container">
		<!-- 页面 -->
		<div class="row ">
			<div style="text-align: center">
				<label  >历史记录</label>
			</div>
		</div>
		<div><label></label></div>
		<!-- 商品信息展示 -->
		<!-- 响应式表格 -->
		<div class="row">
			<div class="col-xs-12">
				<div class="table-responsive">
					<table class="table" id="message_table">					
						<thead>
							<tr>
								<!-- 表头th -->
								<th>
									<input type="checkbox" id="check_all"/>
								</th>
								<th>编号</th>
								<th>申请人</th>
								<th>审批人</th>
								<th>时间</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<!--按钮显示  -->
		<div class="col-xs-offset-7 " id="button2">
			<button type="button" class="btn btn-primary btn-sm popover-hide" id="detail_message_button" title="提示"
	            data-container="body" data-toggle="popover" data-placement="bottom"
	            data-content="请勿选择多条记录查看详细信息 ">
	       		<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>详情
	    	</button>
			<button class="btn btn-danger btn-sm" id="delete_message_button">
				<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除
			</button>
		</div>
		<!-- 分页显示 -->
		<div class="row">
			<!--分页文字信息  -->
			<div class="col-xs-6" id="page_info_area"></div>
			<!-- 分页条信息 -->
			<div class="col-xs-12" id="page_nav_area" ></div>
		</div>
	</div>
	
	
	


	<!-- 底部导航 -->
    <nav class="navbar navbar-default navbar-fixed-bottom" role="navigation">
    <div class="container-fluid">
    <div class="row">
		<div style="display: inline;"><button type="button" class="btn btn-default btn-lg "
			style="width: 90px;background: transparent;border: none;margin-left:20px ">
			<a href="javascript:history.back(-1)">返回 </a>
		</button></div>
		<div style="text-align: center;display: inline;margin:0 auto"><button type="button" class="btn btn-default btn-lg  "
			style="width: 90px;text-align: center;margin-left:auto;margin-right:auto; background:transparent;border: none;position:fixed;">
			<a href="#">首页 </a>
		</button></div>
		<div style="display: inline;"><button type="button" class="btn btn-default btn-lg  "
			style="width: 90px; background: transparent;border: none;margin-right:20px;position:fixed;right: 0px">
			<a href="#">消息 <span class="badge">2</span></a>
		</button></div>
	</div>
    </div>
    </nav>




</body>
</html>
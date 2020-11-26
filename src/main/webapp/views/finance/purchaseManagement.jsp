<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备上进行绘制和触屏缩放 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>库存管理</title>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!-- ========================================== -->
<!-- web路径：不以/开始的相对路径，找资源是以当前资源的路径为基准，比如index.jsp是在webapp下，src就从webapp开始，但容易出错 -->
<!-- 以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306),且需要加上项目名称
     http://localhost:3306/crudtest>
<!-- ========================================== -->
<!-- 引入jquery -->
<script type="text/javascript"
	src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<!-- 引入样式Bootstrap -->
<link
	href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<script type="text/javascript">
	function logout() {
		if (confirm("确定要退出登陆吗？")) {
			sessionStorage.clear();
			window.location.href = "${pageContext.request.contextPath}/login.jsp";
		}
	}
	
</script>
<style type="text/css">
img {
	/* 添加圆角边框 */
	border-radius: 8px;
}
td{
	/* 填充空白区域 */
	padding:5px;
}
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
				<li class="active"><a href="${pageContext.request.contextPath }/views/background/backgroundhome.jsp">后台管理</a></li>
<%-- 			<li><a href="${pageContext.request.contextPath }/login.jsp">退出登陆</a></li> --%>
				<li><a href="javascript:logout()">退出登陆</a></li>
			</ul>
		</div>
	</div>
	</nav>
	<!-- 搭建显示页面 -->
	<div class="container">
	<div style="height:30px;"></div>
		<table  border="0" align="center" >
			<tr >
				<td>
					<a href="${pageContext.request.contextPath}/views/sendMessage.jsp" rel="external">
					<img src="${pageContext.request.contextPath}/static/images/17.png" >
					</a>
				</td>
				<td>
					<a href="${pageContext.request.contextPath}/views/inventory/inventoryInformation.jsp" rel="external">
					<img src="${pageContext.request.contextPath}/static/images/17.png">
					</a>
				</td>
				<td>
					<a href="${pageContext.request.contextPath}/views/inventory/productOutbound.jsp" rel="external">
					<img src="${pageContext.request.contextPath}/static/images/17.png">
					</a>
				</td>
			</tr>
			<tr align="center">
				<td>商品入库</td>
				<td>库存清点</td>
				<td>出库统计</td>
			</tr>
			<tr >
				<td>
					<a href="${pageContext.request.contextPath}/views/error404.jsp" rel="external">
					<img src="${pageContext.request.contextPath}/static/images/123.png" >
					</a>
				</td>
<!-- 				<td> -->
<%-- 					<a href="${pageContext.request.contextPath}/views/inventoryInformation.jsp" rel="external"> --%>
<%-- 					<img src="${pageContext.request.contextPath}/static/images/17.png"> --%>
<!-- 					</a> -->
<!-- 				</td> -->
<!-- 				<td> -->
<%-- 					<a href="${pageContext.request.contextPath}/views/productOutbound.jsp" rel="external"> --%>
<%-- 					<img src="${pageContext.request.contextPath}/static/images/17.png"> --%>
<!-- 					</a> -->
<!-- 				</td> -->
			</tr>
			<tr align="center">
				<td>采购管理</td>
<!-- 				<td>库存清点</td> -->
<!-- 				<td>出库统计</td> -->
			</tr>
			
		</table>		
	</div>
		
				
	</div>

	




</body>
</html>
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
<script src="${APP_PATH }/static/js/echarts.min.js"></script>
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
	<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
    
   
	<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
		<div class="container">
    	<div class="row">
			<div class="col-xs-12">                 
				<div id="main"  style="width: 100%;height:400px;"></div>                                 
            </div>
		</div>
   	</div>
		
		
		
		<script type="text/javascript">
			// 基于准备好的dom，初始化echarts实例
			var myChart = echarts.init(document.getElementById('main'));
			var option;

			var labelRight = {
				normal: {
					position: 'right'
				}
			};
			option = {
				title: {
					text: '选取某件商品的月销量',
					
					sublink: 'http://e.weibo.com/1341556070/AjwF2AgQm'
				},
				tooltip: {
					trigger: 'axis',
					axisPointer: { // 坐标轴指示器，坐标轴触发有效
						type: 'shadow' // 默认为直线，可选为：'line' | 'shadow'
					}
				},
				grid: {
					top: 80,
					bottom: 30
				},
				xAxis: {
					type: 'value',
					position: 'top',
					splitLine: {
						lineStyle: {
							type: 'dashed'
						}
					},
				},
				yAxis: {
					type: 'category',
					axisLine: {
						show: false
					},
					axisLabel: {
						show: false
					},
					axisTick: {
						show: false
					},
					splitLine: {
						show: false
					},
					data: ['twelve','eleven','ten', 'nine', 'eight', 'seven', 'six', 'five', 'four', 'three', 'two', 'one']
				},
				series: [{
					name: '当月销量',
					type: 'bar',
					stack: '总量',
					label: {
						normal: {
							show: true,
							formatter: '{b}'
						}
					},
					data: [{
							value: -0.07,
							label: labelRight
						},
						{
							value: -0.09,
							label: labelRight
						},
						0.2, 0.44,
						{
							value: -0.23,
							label: labelRight
						},
						0.38,
						{
							value: -0.17,
							label: labelRight
						},
						0.47,
						{
							value: -0.36,
							label: labelRight
						},
						0.18,
						{
							value: -0.16,
							label: labelRight
						},
						0.28
					]
				}]
			};

			myChart.setOption(option);
		</script>
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
			<a href="#">消息 <span class="badge" id="messageNum"></span></a>
		</button></div>
	</div>
    </div>
    </nav>

</body>
</html>
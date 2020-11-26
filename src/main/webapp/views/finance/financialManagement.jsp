<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备上进行绘制和触屏缩放 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>销售管理</title>
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
    
   
	<div class="container">
    	<div class="row">
<!--                 <div class="col-xs-6"> -->
<!--                    <div class="panel panel-default"> -->
<!--                         <div class="panel-heading">网站统计</div> -->
<!--                         <div class="panel-body"></div> -->
<!--                 	</div> -->
                    
<!--                 </div> -->
			<div class="col-xs-12">                 
				<div id="canvas"  style="width: 100%;height:400px;"></div>                                 
            </div>

		</div>
		<div class="row">
			<div style="width:80%;margin:15px auto;">
	            <button type="button" class="btn btn-primary btn-lg btn-block">新增销售情况</button>
	  			<div style="height:10px"></div>
	  			<button type="button" class="btn btn-default btn-lg btn-block">查看销售信息</button>
			</div>
		</div>
   	</div>
    
    <script type="text/javascript">
    	//基于准备好的dom，初始化echarts实例
    	var myChart = echarts.init(document.getElementById('canvas'));
		// 指定图表的配置项和数据
    	option = {
			//标题组件
		    title: {
		        text: '本年度销售情况'
		    },
		    //提示框组件
		    tooltip: {
		        trigger: 'axis'
		    },
		    //图例组件展现了不同系列的标记(symbol)，颜色和名字。可以通过点击图例控制哪些系列不显示。
		    legend: {
		        data:'利润'
		    },
		    //直角坐标系内绘图网格，单个 grid 内最多可以放置上下两个 X 轴，左右两个 Y 轴。可以在网格上绘制折线图，柱状图，散点图（气泡图）。
		    grid: {
		        left: '3%',
		        right: '4%',
		        bottom: '3%',
		        containLabel: true
		    },
		    //工具栏。内置有导出图片，数据视图，动态类型切换，数据区域缩放，重置五个工具。
		    toolbox: {
		        feature: {
		            saveAsImage: {}
		        }
		    },
		    //直角坐标系 grid 中的 x 轴
		    xAxis: {
		        type: 'category',
		        boundaryGap: false,
		        data: ['2月','4月','6月','8月','10月','12月']
		    },
		    //直角坐标系 grid 中的 y 轴
		    yAxis: {
		        type: 'value'
		    },
		    //系列列表。每个系列通过 type 决定自己的图表类型
		    series: [
		        {
		            name:'利润',
		            type:'line',
		            stack: '总量',
		            data:[120, 90, 101, 134, 150, 130]
		        },
		        
		    ]
		};
		//使用刚指定的配置项和数据显示图表。
    	myChart.setOption(option);
	   	//重置容器高宽
   		window.onresize = function() {
	        myChart.resize();
    	};
 
    </script>
	
		<!-- 底部导航 -->
	    <nav class="navbar navbar-default navbar-fixed-bottom" role="navigation">
	    <div class="container-fluid">
	    <div class="row">
			<button type="button" class="btn btn-default btn-lg "
				style="width: 90px;background: transparent;border: none;margin-left:20px ">
				<a href="javascript:history.back(-1)">返回 </a>
			</button>
			<button type="button" class="btn btn-default btn-lg  "
				style="width: 90px;text-align: center;background: transparent;border: none;position:fixed;left:140px">
				<a href="#">首页 </a>
			</button>
			<button type="button" class="btn btn-default btn-lg  "
				style="width: 90px; background: transparent;border: none;margin-right:20px;position:fixed;right: 0px">
				<a href="#">消息 <span class="badge"></span></a>
			</button>
			</div>
	    </div>
		</nav>



</body>
</html>
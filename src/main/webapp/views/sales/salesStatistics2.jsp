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
<% pageContext.setAttribute("APP_PATH", request.getContextPath()); %>
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<script src="${APP_PATH }/static/js/echarts.min.js"></script>
<script type="text/javascript">
	function logout() {
		if (confirm("确定要退出登陆吗？")) {
			sessionStorage.clear();
			window.location.href = "${pageContext.request.contextPath}/login.jsp";
		}
	}
	$(function(){
		
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
		
		/****************************************************************/
		/************************ 生成ECharts图表    ***********************/
		/****************************************************************/
    	// 基于准备好的dom，初始化echarts实例
    	var myChart = echarts.init(document.getElementById('canvas'));
		// 指定图表的配置项和数据
		var date=new Date();
		var year=date.getFullYear();
		var data=[];
		$.ajax({
			url : "${APP_PATH}/sales/getYearProfit.do",
			type : "GET",
			data : "year="+year,
			success : function(result) {
				//console.log(result.extend.json);
				var obj=result.extend.json;
				for(var p in obj){
					data.push(obj[p]);
				};
				//隐藏加载动画
				myChart.hideLoading(); 
				//加载数据图表
                myChart.setOption({        

                    series: [{
                    	type:'line',
        	            stack: '总量',
                        // 根据名字对应到相应的系列
                        name: '利润',
                        data: data
                    }]
                });
				
			},
			error:function(result){
				alert("图表请求数据失败!");
	            myChart.hideLoading();
			}

		});
		// 显示标题，图例和空的坐标轴
		myChart.setOption({
		    title: {
		        text: year+'年度销售情况'
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
		    series: [{
	            name:'利润',
	            type:'line',
	            stack: '总量',
		        data: []
		    }]
		});
		//数据加载完之前先显示一段简单的loading动画
		myChart.showLoading();    
	   	//重置容器高宽
   		window.onresize = function() {
	        myChart.resize();
    	};
		
		
		
	})
	
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
	<!-- 顶部导航 -->
	<nav class="navbar navbar-default navbar-fixed-top">
	<div class="container-fluid">
		<div class="navbar-header" style="text-align:center;">
			<button type="button" class="btn btn-default btn-lg" onclick="javascript:history.back(-1)" id="topNavbarLeftButton">
        		<span class="glyphicon glyphicon-arrow-left"></span>
    		</button>
			<a  href="#"  style="font-size:18px;font-color:rgb(51,122,183)">销售管理</a>
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
	
	
	<!-- 搭建显示页面 -->
	<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
	<div class="container" style="margin-bottom: 50px;margin-top: 65px">
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
	            <button type="button" class="btn btn-primary btn-lg btn-block">
	            <a href="${pageContext.request.contextPath }/views/sales/salesInfAddManagement.jsp" style="color: #FFFFFF">
				新增销售情况
	            </a>
	            </button>
	  			<div style="height:10px"></div>
	  			<button type="button" class="btn btn-default btn-lg btn-block">
	  			<a href="${pageContext.request.contextPath }/views/sales/historySalesInformation.jsp">
	  			历史销售情况
	  			</a>
	  			</button>
			</div>
		</div>
   	</div>
    
	
	<!-- 底部导航 -->
    <nav class="navbar navbar-default navbar-fixed-bottom" role="navigation">
    <div class="container-fluid">
    <div class="row" style="text-align:center;">
		<button type="button" class="btn btn-default btn-lg " id="bottomNavbarLeftButton"
			style="width: 90px;background: transparent;border: none;margin-left:20px;">
			<a href="javascript:history.back(-1)">返回 </a>
		</button>
		<button type="button" class="btn btn-default btn-lg  "
			style="width: 90px;background: transparent;border: none;">
			<a href="#">首页 </a>
		</button>
		<button type="button" class="btn btn-default btn-lg  " id="bottomNavbarRightButton"
			style="width: 90px; background: transparent;border: none;margin-right:20px;">
			<a href="#">消息 <span class="badge"></span></a>
		</button>
		</div>
    </div>
	</nav>



</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备相应布局 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>门店管理页面</title>
<% pageContext.setAttribute("APP_PATH", request.getContextPath()); %>

<!-- jquery -->
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<!-- bootstrap -->
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<!-- echarts -->
<script src="${APP_PATH }/static/js/echarts.min.js"></script>
<script type="text/javascript" src="${APP_PATH }/static/js/map/china.js"></script>
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
		
		
		/****************************************************************/
		/*******************   异步将数据图形化展示    ******************/
		/****************************************************************/
		//定义图表数据 
		var dataMap =[  
		    {name: '北京',value: '100' },{name: '天津',value: '30'  },  
		    {name: '上海',value: '20'  },{name: '重庆',value: '40'  },  
		    {name: '南京',value: '80'  },{name: '福建',value: '40'  },
		    {name: '广州',value: '70'  },{name: '河北',value: '10'  },
		    {name: '浙江',value: '90'  },{name: '湖北',value: '50'  },
		    {name: '湖南',value: '60'  },{name: '山西',value: '30'  },
		];
		var geoCoordMap = {'北京':[121.15,31.89],
			    '天津':[109.781327,39.608266],
			    '上海':[120.38,37.35],
			    '重庆':[122.207216,29.985295],
			    '南京':[123.97,47.33]
		};
		var convertData = function (dataMap) {
		    var res = [];
		    for (var i = 0; i < dataMap.length; i++) {
		        var geoCoord = geoCoordMap[dataMap[i].name];
		        if (geoCoord) {
		            res.push({
		                name: dataMap[i].name,
		                value: geoCoord.concat(dataMap[i].value)
		            });
		        }
		    }
		    return res;
		};
		//基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main'));
		//指定图表的配置项和数据
		myChart.setOption({
			//标题
			title:{
				text: '连锁店门店分布情况',
				left: 'center',
				top: '50'
			},
			//工具栏
			tooltip: {
	            trigger: 'item',
	            showDelay: 0,
	            transitionDuration: 0.2,
	            formatter: function (params) {
	                var value = (params.value + '').split('.');
	                value = value[0].replace(/(\d{1,3})(?=(?:\d{3})+(?!\d))/g, '$1,');
	                return params.seriesName + '<br/>' + params.name + ': ' + value;
	            }
	        },
	        //图例组件
	        visualMap: {
	        	type: 'piecewise',
	            left: 'left',
	            min: 0,
	            max: 100,
	            splitNumber: 5,
	            color: ['blue','#6ac7ff'],//红黄蓝
	        },
	        //打印下载按钮
	        toolbox: {
	            show: true,
	            //orient: 'vertical',
	            left: 'left',
	            top: 'top',
	            feature: {
	                dataView: {readOnly: false},
	                restore: {},
	                saveAsImage: {}
	            }
	        },
	        geo: {
	            // 这个是重点配置区
	            map: 'china', // 表示中国地图
	            roam: true, // 支持扩大缩小
	            label: {
	            	normal: {
	                	show: false, // 是否显示对应地名
	                	textStyle: {
	                  		color: '#FFFFFF',//白
	                  		fontSize: 15
	                	}
	              	},
	              	emphasis: {
	                	show: false
	              	}
	            },
	            itemStyle: {
	                normal: {
	                	areaColor: {
		                    type: 'radial',
		                    x: 0.5,
		                    y: 0.6,
		                    r: 2.2,
	                    	colorStops: [
	                      		{
			                        offset: 1,
			                        color: '#6ac7ff' // 0% 处的颜色
			                    },
	                      		{
		                        	offset: 0,
		                        	color: '#6ac7ff' // 100% 处的颜色
		                        }
	                    	],
	                    	globalCoord: false
	                  	},
	                  	borderColor: '#D3D3D3' // 鼠标移动到省份边框颜色
	                },
	                emphasis: {
	                	areaColor: 'rgba(39, 17, 235, 0.5)', // 鼠标移动到省份显示的颜色
	                  	shadowBlur: 15,
	                  	borderWidth: 1,
	                  	shadowColor: 'rgba(39, 17, 235, 0.5)' // 鼠标移动地图周围阴影
	               	}
	        	}
	        },
	        series: [
	        	//地图类别
	        	{
		        	name: '连锁店规模', // 浮动框的标题
		            type: 'map',
		            geoIndex: 0,
		            top: '50',
		            data: dataMap
	        	}
	        ]
		        

	    });
		
		
		
		
	})
</script>
<style type="text/css">
	/* 选择前一半的li*/
	#empUl li:lt(lis) {
		float:left;
	}
	/* 选择后一半的li*/
 	#empUl li:gt(lis){
 		margin-left:50px;
 		list-style-type:none;
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
	<nav class="navbar navbar-default navbar-fixed-top" >
	<div class="container-fluid" >
		<div class="navbar-header" style="text-align:center;">
			<button type="button" class="btn btn-default btn-lg" onclick="javascript:history.back(-1)" id="topNavbarLeftButton">
        		<span class="glyphicon glyphicon-arrow-left"></span>
    		</button>
			<a  href="#"  style="font-size:18px;font-color:rgb(51,122,183)">门店管理</a>
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
		<div class="row " >
			<div style="text-align: center;">
				<button type="button" class="btn btn-info btn-sm col-xs-offset-7" id="searchButton">
					<span class="glyphicon glyphicon-search" aria-hidden="true"></span> 搜索
				</button>
			</div>
		</div>
		<div><label></label></div>
		<div class="row">
			<div  id="main" style="width: 95%;height:550px ;margin: 0 auto">
			</div>
		</div><!--div class="row"  -->
		
		

		
		
		
	</div><!-- <div class="container"> -->

	


	
	
	

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
 				<a href="#">消息 <span class="badge" id="messageNum"></span></a> 
			</button>
		</div> 
	</div>
    </div>
    </nav>







</body>

</html>
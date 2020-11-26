<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>决策助理</title>
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
	$(function() {

		/****************************************************************/
		/*******************调整顶部导航栏按钮的margin*******************/
		/****************************************************************/
		var width = document.body.clientWidth;
		var a = (width - 232 - 2 * 10) / 2;
		console.log("a=" + a + 'px');
		$("#topNavbarLeftButton").css({
			"margin-right" : a + 'px'
		});
		$("#topNavbarRightButton").css({
			"margin-left" : a + 'px'
		});
		//调整底部导航栏按钮的margin
		var b = (width - 310 - 2 * 10) / 2;
		console.log("b=" + b + 'px');
		$("#bottomNavbarLeftButton").css({
			"margin-right" : b + 'px'
		});
		$("#bottomNavbarRightButton").css({
			"margin-left" : b + 'px'
		});

		/****************************************************************/
		/************************ 获取决策树模型  ***********************/
		/****************************************************************/
		$("#makingDecision_btn").click(function() {
			console.log("start train model...");
			$("#loadingDiv").show();
			makingDecision();
		});
		function makingDecision() {
			$.ajax({
				url : "${APP_PATH }/analyze/makingDecision.do?appName=addNewProduct",
				type : "GET",
				success : function(resultdata) {
					$("#loadingDiv").hide();
					console.log(resultdata);
					$("#result").val(resultdata.extend.result);
				}
			});
		}
		$("#makingDecisionByModel_btn").click(function() {
			console.log("start predict...");
			$("#loadingDiv").show();
			makingDecisionByModel();
		});
		function makingDecisionByModel(){
			$.ajax({
				url : "${APP_PATH }/analyze/makingDecisionByModel.do?appName=addNewProduct",
				type : "GET",
				success : function(resultdata) {
					$("#loadingDiv").hide();
					console.log(resultdata);
					$("#result").val(resultdata.extend.result);
				}
			});
		}
		$("#test_btn").click(function() {
			console.log("start test...");
			$("#loadingDiv").show();
			testMethod();
		});
		function testMethod(){
			$.ajax({
				url : "${APP_PATH }/analyze/test",
				type : "GET",
				success : function(resultdata) {
					console.log("finish test...");
					$("#loadingDiv").hide();
				}
			});
		}
		
		/****************************************************************/
		/********************** 显示决策树模型记录  *********************/
		/****************************************************************/
		$.ajax({
			url:"${APP_PATH }/analyze/getAllTreeModel",
			type : "GET",
			success : function(resultdata) {
				console.log(resultdata.extend.treeList);
				$.each(resultdata.extend.treeList,function(index,item){ 
					var label1=$("<label style='margin-left:15px'></label>").append(item.treeModelNum);
					$("#div1").append(label1).append("<br/>");
					var label2=$("<label style='margin-left:15px'></label>").append("name:"+item.treeModelNum+",").append("test-error:"+item.treeModelError);
					$("#div2").append(label2).append("<br/>");
				});
			}
			
		});
		

		/****************************************************************/
		/************************ 生成ECharts图表    ************************/
		/****************************************************************/
		
		// 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main'));
       
		$.get("${APP_PATH }/analyze/getJsonTreeModel.do", function (data) {	
			var mydata={"children":[{"children":[],"name":"判断条件：feature 2 <= 2.60，属于类型：0.0"},{"children":[{"children":[],"name":"判断条件：feature 2 <= 4.85，属于类型：2.0"},{"children":[],"name":"判断条件：feature 2 > 4.85，属于类型：1.0"}],"name":"判断条件：feature 2 > 2.60"}],"name":"模型编号为dtc_f8c225833485，参与判断的属性共有5个，最多经过2次判断。"};
			console.log(mydata);
			console.log(data);
			myChart.setOption(option = {
				tooltip: {
	 		    	trigger: 'item',
 		            triggerOn: 'mousemove',
 		            position: 'top',
 		            formatter: function(value) { 
                		var str="";
                      	//debugger;
                      	if(value.dataIndex==1) return "模型说明";
                	  	if(typeof value !== 'string'){
                			str = value.data.name.toString();
                		}
                      	var splits=str.split("，");
                      	var res="";
                      	if(splits.length==2){
                      		res=splits[0]+"<br/>"+splits[1];
                      	}else{
                      		res=splits[0];
                      	}
                      	return res;  
 		            }
 		        },
 		        legend: {
 		            data:['属性'],
 		            orient: 'vertical',
		            x:'right',      //可设定图例在左、右、居中
		            y:'top',     //可设定图例在上、下、居中
		            padding:[0,0,0,0], 
 		        },
 		        series:[{
	            	type: 'tree',
	            	name: '属性',
	                data: [mydata],

	                left: '2%',//到上下左右边框的距离
	                right: '2%',
	                top: '8%',
	                bottom: '20%',

	                symbol: 'emptyCircle',//点击节点可以折叠子树
	                orient: 'vertical',//horizontal，纵向/横向布局
	                expandAndCollapse: false,
	                symbolSize: [15,15],   //节点标记的大小，默认7，可以设置成单一数字，也可以指定长宽：[20,20]

	                label: { //每个节点所对应的标签的样式
	                	position: 'top',
	                    rotate: 0,//旋转
	                    verticalAlign: 'bottom',//文字垂直对齐方式
	                    align: 'center',//文字水平对齐方式，默认自动。可选：top，center，bottom
	                    fontSize: 15,
	                    distance: 5,
	                   	formatter:function(value) { 
	                		var str="";
	                      	//debugger;
	                      	if(value.dataIndex==1) return "模型说明";
	                	  	if(typeof value !== 'string'){
	                			str = value.data.name.toString();
	                		}
	                      	var splits=str.split("，");
	                      	var res="";
	                      	if(splits.length==2){
	                      		temp=splits[1].split("：");
	                      		res=temp[1];
	                      		//res=temp[0]+"："+"<br/>"+temp[1];
	                      	}
	                      	return res;  
	                  	}
	                  	
	                },

	                leaves: {  //叶子节点的特殊配置
	                    label: {
	                        position: 'bottom',
	                        //rotate: -90,
	                        verticalAlign: 'top',
	                        align: 'middle',
	                        distance: 5
	                    }
	                },

	                animationDurationUpdate: 750 //数据更新动画的时长
 		        }]
        	});
		});//$.get
		//关键点！
		function clickFun(param) {
		    if (typeof param.seriesIndex == 'undefined') {
		        return;
		    }
		    if (param.type == 'click') {
		        alert(param.name);
		    }
		}


	})//$(function()
</script>
<style type="text/css">
img {
	/* 添加圆角边框 */
	border-radius: 8px;
}

td {
	/* 填充空白区域 */
	padding: 5px;
}

#topNavbarRightButton {
	float: none;
}

#topNavbarLeftButton {
	/* 	margin-top:8px; */
	/* 	margin-bottom:8px; */
	margin: 0 auto;
	padding: 7px 12px 7px 12px; /* 上右下左 */
}


.spinner {
  width: 60px;
  height: 60px;
  background-color: #67CF22;
  display:none;
 
  margin: 100px auto;
  -webkit-animation: rotateplane 1.2s infinite ease-in-out;
  animation: rotateplane 1.2s infinite ease-in-out;
}
 
@-webkit-keyframes rotateplane {
  0% { -webkit-transform: perspective(120px) }
  50% { -webkit-transform: perspective(120px) rotateY(180deg) }
  100% { -webkit-transform: perspective(120px) rotateY(180deg)  rotateX(180deg) }
}
 
@keyframes rotateplane {
  0% {
    transform: perspective(120px) rotateX(0deg) rotateY(0deg);
    -webkit-transform: perspective(120px) rotateX(0deg) rotateY(0deg)
  } 50% {
    transform: perspective(120px) rotateX(-180.1deg) rotateY(0deg);
    -webkit-transform: perspective(120px) rotateX(-180.1deg) rotateY(0deg)
  } 100% {
    transform: perspective(120px) rotateX(-180deg) rotateY(-179.9deg);
    -webkit-transform: perspective(120px) rotateX(-180deg) rotateY(-179.9deg);
  }
}
</style>
</head>
<body>
	<!-- 顶部导航 -->
	<nav class="navbar navbar-default navbar-fixed-top">
	<div class="container-fluid">
		<div class="navbar-header" style="text-align: center;">
			<button type="button" class="btn btn-default btn-lg"
				onclick="javascript:history.back(-1)" id="topNavbarLeftButton">
				<span class="glyphicon glyphicon-arrow-left"></span>
			</button>
			<a href="#" style="font-size: 18px; font-color: rgb(51, 122, 183)">决策管理</a>
			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target="#myNavbar" id="topNavbarRightButton">
				<!-- 按钮有三个横线 -->
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
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


	<!-- 搭建显示页面 -->
	<div class="container" style="margin-bottom: 50px; margin-top: 65px">
		<!-- 预测信息展示 -->
		<div class="jumbotron" style="padding: 15px 15px;">
			<div  id="main" style="width: 80%;height:350px ;margin: 0 auto">
			</div>
		</div><!--div class="row"  -->
    	
		<!-- loading动画 class="spinner"  -->
		<!--  <div id="loadingDiv" class="spinner" style="z-index: 9999; position:absolute;
			left:50%;margin-left: -30px">

		</div>
		<button id="makingDecision_btn">生成模型</button>
		<button id="makingDecisionByModel_btn">使用模型</button>
		<button id="test_btn">测试</button>
		<div style=" height: 400px;">
			<div style="display:inline;float:left;">
				<textarea id="result" style="width: 300px; height: 400px;"></textarea>
			</div>
			<div style="display:inline;float:left;width: 150px; height: 400px;">
				<div id="div1" style=" height: 200px;">
				<label id="label1">生成模型记录</label><br/>

				</div>
				<div  id="div2" style=" height: 200px;">
				<label id="label2">使用模型记录</label><br/>

				</div>
			</div>
		</div>-->

	</div>


	<!-- 底部导航 -->
	<nav class="navbar navbar-default navbar-fixed-bottom"
		role="navigation">
	<div class="container-fluid">
		<div class="row" style="text-align: center;">
			<button type="button" class="btn btn-default btn-lg "
				id="bottomNavbarLeftButton"
				style="width: 90px; background: transparent; border: none; margin-left: 20px;">
				<a href="javascript:history.back(-1)">返回 </a>
			</button>
			<button type="button" class="btn btn-default btn-lg  "
				style="width: 90px; background: transparent; border: none;">
				<a href="#">首页 </a>
			</button>
			<button type="button" class="btn btn-default btn-lg  "
				id="bottomNavbarRightButton"
				style="width: 90px; background: transparent; border: none; margin-right: 20px;">
				<a href="#">消息 <span class="badge"></span></a>
			</button>
		</div>
	</div>
	</nav>



</body>
</html>
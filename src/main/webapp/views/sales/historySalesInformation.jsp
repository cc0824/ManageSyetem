<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备上进行绘制和触屏缩放 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>销售界面</title>
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
		/****************************日历展示****************************/
		/****************************************************************/
		var startTime,endTime;
		laydate.render({
			elem: '#startTimeInputId', //指定元素
			change: function(value, date, endDate){//日期时间被切换后的回调
			    //console.log(value); //得到日期生成的值，如：2017-08-18
			    //console.log(date); //得到日期时间对象：{year: 2017, month: 8, date: 18, hours: 0, minutes: 0, seconds: 0}
			    //console.log(endDate); //得结束的日期时间对象，开启范围选择（range: true）才会返回。对象成员同上。
			},
			done:function(value,date,endDate){
				startTime=value;
				//console.log(value); 
			    //console.log(date); 
			    //console.log(endDate);
			}
		});
		laydate.render({
		  	elem: '#endTimeInputId', //指定元素
		  	done:function(value,date,endDate){
		  		endTime=value;
				//console.log(value); 
			    //console.log(date); 
			    //console.log(endDate);
			}
		});
		
		/****************************************************************/
		/****************************筛选功能****************************/
		/****************************************************************/
		$("#selectButton").click(function(){
			var startTime1=$("#startTimeInputId").val();
			var endTime1=$("#endTimeInputId").val();
			var searchCondition=$("#fuzzyInputId").val();
			console.log("开始时间："+startTime1);
			console.log("结束时间："+endTime1);
			console.log("搜索条件："+searchCondition);
 			$.ajax({
 				url:"${APP_PATH}/sales/selectSalesHistory.do",
 				type:"GET",
				data:{"startTime1":startTime1,"endTime1":endTime1,"searchCondition":searchCondition},
 				success:function(result){
 					alert("ok");
 					console.log(result);
 				},
 				error:function(){
 					alert("fail");
				}
 			})
		
		});
		
		
		
		
		
// 		$("#product_save_btn").click(function() {
// 			console.log($("#productAddForm").serialize());
// 			$.ajax({
// 				url : "${APP_PATH}/message/sendMessage.do",
// 				type : "POST",
// 				data : $("#productAddForm").serialize(),
// 				success : function(result) {
// 					//测试
// 					alert("success");
// 					//清楚cookie

// 				},
// 				error:function(result){
// 					alert("fail");
// 				}

// 			});

// 		});
		
// 		$("#myLink").click(function() {
// 			//1.表单数据存到cookie
// 			var fromUser=$("[name='messageFromUser']").val();
// 			var toUser=$("[name='messageToUser']").val();
// 			var changeType=$("[name='messageType']").val();
// 			var message=$("[name='messageContent']").val();
// 			document.cookie="fromUser="+fromUser+"toUser="+toUser+"changeType="+changeType+"message="+message;
// 			console.log(document.cookie);
// 			//2.提前为此次库存变动赋值message_id
// 			var iid;
// 			$.ajax({
// 				url : "${APP_PATH}/message/getLastMessageId.do",
// 				type : "GET",
// 				success : function(result) {
// 					console.log(result);
// 					iid=result.extend.id;
// 					//3.跳转
// 					window.location.href="${pageContext.request.contextPath}/views/inventory/inventoryAddManagement.jsp?id="+iid;
// 				},
// 				error:function(result){
// 					alert("fail");
// 				}

// 			});
			
// 		});
		
		
// 		//显示历史入库记录信息
// 		$.ajax({
// 			url : "${APP_PATH}/message/getAllInboundMessage.do",
// 			type : "GET",
// 			success : function(result) {
// 				//测试
// 				alert("success");
// 				console.log(result);
// 				var messages=result.extend.pageInfo.list;
// 				console.log(messages);
// 				//只展示前5条历史纪录
// 				$.each(messages,function(index,item){
// 					if(index==0){
// 						createNocollapseAccordion(item);
// 					}else{
// 						createCollapseAccordion(item);
// 					}
					
// 					if (index>3) {
// 		                return false;
// 		        	}
					
// 				});
				

// 			},
// 			error:function(result){
// 				alert("fail");
// 			}

// 		});
// 		//创建每条入库记录的折叠展示区域(默认展开)
// 		function createNocollapseAccordion(item){
// 			var text1=item;
// 			var headingDiv=$("<div></div>").addClass("panel-heading").append($("<div></div>").addClass("panel-title")
// 					.append($("<a data-toggle='collapse' data-parent='#accordion'  ></a>").attr("href","#collapseOne").append("发信人："+item.messageFromUser+",发信内容："+item.messageContent)));
// 			var bodyDiv=$("<div id='collapseOne' class='panel-collapse collapse in'></div>")
// 				.append($("<div class='panel-body'></div>").append(item.messageTime));
			
// 			var panelDiv=$("#accordion").append($("<div></div>").addClass("panel panel-success").append(headingDiv).append(bodyDiv));
			
// 		}
// 		//创建每条入库记录的折叠展示区域(默认折叠)
// 		function createCollapseAccordion(item){
// 			var text1=item;
// 			var headingDiv=$("<div></div>").addClass("panel-heading").append($("<div></div>").addClass("panel-title")
// 					.append($("<a data-toggle='collapse' data-parent='#accordion'  ></a>").attr("href","#collapseOne").text("发信人："+item.messageFromUser+",发信内容："+item.messageContent)));
// 			var bodyDiv=$("<div id='collapseOne' class='panel-collapse collapse '></div>")
// 				.append($("<div class='panel-body'></div>").append("发信时间："+item.messageTime));
			
// 			var panelDiv=$("#accordion").append($("<div></div>").addClass("panel panel-success").append(headingDiv).append(bodyDiv));
			
// 		}


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
	<!-- 搭建系统主页 -->
	<!-- 顶部导航 -->
	<nav class="navbar navbar-default">
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
	
	
	<div class="container" >
		<form class="form-horizontal">
			<div class="form-group">
				<label for="startTimeInput" class="col-xs-4 control-label" style="text-align: right">开始时间</label>
				<div class="col-xs-5">
					<input type="text" class="form-control demo-input" name="startTimeInput" id="startTimeInputId"
						placeholder="请选择日期"></input>
				</div>
			</div>
			<div class="form-group">
				<label for="endTimeInput" class="col-xs-4 control-label" style="text-align: right">结束时间</label>
				<div class="col-xs-5">
					<input type="text" class="form-control demo-input" name="endTimeInput" id="endTimeInputId"
						placeholder="请选择日期"></input>
				</div>
			</div>
			<div class="form-group">
				<label for="fuzzyInput" class="col-xs-4 control-label" style="text-align: right">模糊搜索</label>
				<div class="col-xs-5">
					<input type="text" class="form-control" name="fuzzyInput" id="fuzzyInputId"
						placeholder="搜索条件"></input>
				</div>
			</div>
			<div class="form-group">
				<div class="col-xs-offset-8 ">
					<button type="button" class="btn btn-success" id="selectButton">筛选</button>
				</div>
			</div>
		</form>
				
		<div style="width: 90%;margin: 0px auto">
			<label>历史销售记录</label>
			<div class="panel-group" id="accordion2">
<!-- 				<div class="panel panel-success"> -->
<!-- 			        <div class="panel-heading"> -->
<!-- 			            <h4 class="panel-title"> -->
<!-- 			                <a data-toggle="collapse" data-parent="#accordion"  -->
<!-- 			                href="#collapseTwo"> -->
<!-- 			                	销售人：b，销售时间：2020/2/14 -->
<!-- 			                </a> -->
<!-- 			            </h4> -->
<!-- 			        </div> -->
<!-- 			        <div id="collapseTwo" class="panel-collapse collapse"> -->
<!-- 			            <div class="panel-body"> -->
<!-- 			            </div> -->
<!-- 			        </div> -->
<!--     			</div> -->
				<div class="panel panel-success">
			        <div class="panel-heading">
			            <h4 class="panel-title">
			                <a data-toggle="collapse" data-parent="#accordion" 
			                href="#collapseTwo">
			                	销售人：b，销售时间：2020/2/15
			                </a>
			            </h4>
			        </div>
			        <div id="collapseTwo" class="panel-collapse collapse">
			            <div class="panel-body">
			            </div>
			        </div>
    			</div>
				<div class="panel panel-success">
			        <div class="panel-heading">
			            <h4 class="panel-title">
			                <a data-toggle="collapse" data-parent="#accordion" 
			                href="#collapseTwo">
			                	销售人：b，销售时间：2020/2/16
			                </a>
			            </h4>
			        </div>
			        <div id="collapseTwo" class="panel-collapse collapse">
			            <div class="panel-body">
			            </div>
			        </div>
    			</div>
				<div class="panel panel-success">
			        <div class="panel-heading">
			            <h4 class="panel-title">
			                <a data-toggle="collapse" data-parent="#accordion" 
			                href="#collapseOne">
			                	销售人：b，销售时间：2020/2/17
			                </a>
			            </h4>
			        </div>
			        <div id="collapseOne" class="panel-collapse collapse">
			            <div class="panel-body">
			               	 销售商品列表：1.牛奶*20，2.饼干*15
			               	 <a href="${pageContext.request.contextPath}/views/message/seeMoreMessage.jsp" style="display:block;text-align: right;" rel="external">查看详情</a>
			            </div>
			        </div>
    			</div>
				<div class="panel panel-success">
			        <div class="panel-heading">
			            <h4 class="panel-title">
			                <a data-toggle="collapse" data-parent="#accordion" 
			                href="#collapseTwo">
			                	销售人：b，销售时间：2020/2/17
			                </a>
			            </h4>
			        </div>
			        <div id="collapseTwo" class="panel-collapse collapse">
			            <div class="panel-body">
			            </div>
			        </div>
    			</div>
<!-- 				<div class="panel panel-success"> -->
<!-- 			        <div class="panel-heading"> -->
<!-- 			            <h4 class="panel-title"> -->
<!-- 			                <a data-toggle="collapse" data-parent="#accordion"  -->
<!-- 			                href="#collapseThree"> -->
<!-- 			                	销售人：c，销售时间：2020/2/17 -->
<!-- 			                </a> -->
<!-- 			            </h4> -->
<!-- 			        </div> -->
<!-- 			        <div id="collapseThree" class="panel-collapse collapse"> -->
<!-- 			            <div class="panel-body"> -->
<!-- 			                	销售商品列表：1.牛奶1*20，2.牛奶2*30，3.牛奶3*35 -->
<!-- 			            </div> -->
<!-- 			        </div> -->
<!--     			</div> -->
		
	    	</div>
	    	<a href="${pageContext.request.contextPath}/views/message/seeMoreMessage.jsp" style="display:block;text-align: right;" rel="external">查看更多</a>
		</div>
	</div><!-- div class="container" -->

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
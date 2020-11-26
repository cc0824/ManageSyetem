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

	$(function() {

		$("#product_save_btn").click(function() {
			console.log($("#productAddForm").serialize());
			$.ajax({
				url : "${APP_PATH}/message/sendMessage.do",
				type : "POST",
				data : $("#productAddForm").serialize(),
				success : function(result) {
					//测试
					alert("success");
					//清楚cookie

				},
				error:function(result){
					alert("fail");
				}

			});

		});
		
		$("#myLink").click(function() {
			//1.表单数据存到cookie
			var fromUser=$("[name='messageFromUser']").val();
			var toUser=$("[name='messageToUser']").val();
			var changeType=$("[name='messageType']").val();
			var message=$("[name='messageContent']").val();
			document.cookie="fromUser="+fromUser+"toUser="+toUser+"changeType="+changeType+"message="+message;
			console.log(document.cookie);
			//2.提前为此次库存变动赋值message_id
			var iid;
			$.ajax({
				url : "${APP_PATH}/message/getLastMessageId.do",
				type : "GET",
				success : function(result) {
					console.log(result);
					iid=result.extend.id;
					//3.跳转
					window.location.href="${pageContext.request.contextPath}/views/inventory/inventoryAddManagement.jsp?id="+iid;
				},
				error:function(result){
					alert("fail");
				}

			});
			
		});
		
		
		//显示历史入库记录信息
		$.ajax({
			url : "${APP_PATH}/message/getAllInboundMessage.do",
			type : "GET",
			success : function(result) {
				//测试
				alert("success");
				console.log(result);
				var messages=result.extend.pageInfo.list;
				console.log(messages);
				//只展示前5条历史纪录
				$.each(messages,function(index,item){
					if(index==0){
						createNocollapseAccordion(item);
					}else{
						createCollapseAccordion(item);
					}
					
					if (index>3) {
		                return false;
		        	}
					
				});
				

			},
			error:function(result){
				alert("fail");
			}

		});
		//创建每条入库记录的折叠展示区域(默认展开)
		function createNocollapseAccordion(item){
			var text1=item;
			var headingDiv=$("<div></div>").addClass("panel-heading").append($("<div></div>").addClass("panel-title")
					.append($("<a data-toggle='collapse' data-parent='#accordion'  ></a>").attr("href","#collapseOne").append("发信人："+item.messageFromUser+",发信内容："+item.messageContent)));
			var bodyDiv=$("<div id='collapseOne' class='panel-collapse collapse in'></div>")
				.append($("<div class='panel-body'></div>").append(item.messageTime));
			
			var panelDiv=$("#accordion").append($("<div></div>").addClass("panel panel-success").append(headingDiv).append(bodyDiv));
			
		}
		//创建每条入库记录的折叠展示区域(默认折叠)
		function createCollapseAccordion(item){
			var text1=item;
			var headingDiv=$("<div></div>").addClass("panel-heading").append($("<div></div>").addClass("panel-title")
					.append($("<a data-toggle='collapse' data-parent='#accordion'  ></a>").attr("href","#collapseOne").text("发信人："+item.messageFromUser+",发信内容："+item.messageContent)));
			var bodyDiv=$("<div id='collapseOne' class='panel-collapse collapse '></div>")
				.append($("<div class='panel-body'></div>").append("发信时间："+item.messageTime));
			
			var panelDiv=$("#accordion").append($("<div></div>").addClass("panel panel-success").append(headingDiv).append(bodyDiv));
			
		}


	})
</script>
<style type="text/css">
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
				<span class="icon-bar"></span> <span class="icon-bar"></span> 
				<span class="icon-bar"></span>
			</button>
			<button type="button" class="btn btn-default btn-lg" style="padding-left: 12px;padding-right: 12px;padding-bottom:7px ;padding-top:7px ;margin-left: 15px;line-height: 18px"
				onclick="javascript:history.back(-1);">
        		<span class="glyphicon glyphicon-arrow-left"></span>
    		</button>
			<a class="navbar-brand col-xs-offset-2 col-xs-4" href="#" 
				style="float:none;display: inline-block;text-align:center ">
  			采购管理</a>
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
		<div id="abcd">
			<form class="form-horizontal" id="productAddForm">
				<div class="form-group">
					<label for="inputRole" class="col-xs-4 control-label" style="text-align: right">采购人名称</label>
					<div class="col-xs-5">
						<input type="text" class="form-control" id="inputEmail3" name="messageFromUser"
							placeholder="采购人">
					</div>
				</div>
				<div class="form-group">
					<label for="inputToRole" class="col-xs-4 control-label" style="text-align: right">审批人名称</label>
					<div class="col-xs-5">
						<input type="text" class="form-control" id="inputEmail3" name="messageToUser"
							placeholder="审批人">
<!-- 						<input type="text" class="form-control" id="inputToRoles" name="messageToUser" -->
<!-- 							placeholder="审批人" style="width: 138.75px;position:absolute;"> -->
<!-- 						<select class="form-control" style="width:180px;height:34px;"> -->
<!-- 							<option>库管员</option> -->
<!-- 							<option>店长</option> -->
<!-- 							<option>理货员</option> -->
<!-- 							<option>4</option> -->
<!-- 							<option>5</option> -->
<!-- 						</select> -->
					</div>
				</div>
				<div class="form-group">
					<label for="inputType" class="col-xs-4 control-label" style="text-align: right">采购渠道</label>
					<div class="col-xs-5">
						<select class="form-control" name="messageType">
							<option selected="selected" value="1">采购商1</option>
							<option value="2">采购商2</option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label for="inputApplication" class="col-xs-4 control-label" style="text-align: right">内容</label>
					<div class="col-xs-5">
						<input type="text" class="form-control" id="inputApplication" name="messageContent"
							placeholder="内容">
					</div>
				</div>
				<div class="form-group">
					<a href="#" rel="external" id="myLink">
						<label for="inputProduct" class="col-xs-8 control-label" style="text-align: right">前往填写采购商品</label>
					</a>
				</div>
				<div class="form-group">
					<div class="col-xs-offset-8 ">
						<button class="btn btn-success" id="product_save_btn">申请</button>
					</div>
				</div>
			</form>
		</div>
		
		
		<div style="width: 90%;margin: 0px auto">
<!-- 			<label>线程安全问题  如果有别人提前插入  message_id就会变化</label> -->
			<label>历史采购记录</label>
			<div class="panel-group" id="accordion2">
				<div class="panel panel-success">
			        <div class="panel-heading">
			            <h4 class="panel-title">
			                <a data-toggle="collapse" data-parent="#accordion" 
			                href="#collapseOne">
			                	采购人：c，采购时间：2020/2/11
			                </a>
			            </h4>
			        </div>
			        <div id="collapseOne" class="panel-collapse collapse">
			            <div class="panel-body">
			               	 采购商品列表：1.牛奶*20，2.饼干*15
			            </div>
			        </div>
    			</div>
				<div class="panel panel-success">
			        <div class="panel-heading">
			            <h4 class="panel-title">
			                <a data-toggle="collapse" data-parent="#accordion" 
			                href="#collapseTwo">
			                	采购人：c，采购时间：2020/2/12
			                </a>
			            </h4>
			        </div>
			        <div id="collapseTwo" class="panel-collapse collapse">
			            <div class="panel-body">
			                Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred 
			                nesciunt sapiente ea proident. Ad vegan excepteur butcher vice 
			                lomo.
			            </div>
			        </div>
    			</div>
				<div class="panel panel-success">
			        <div class="panel-heading">
			            <h4 class="panel-title">
			                <a data-toggle="collapse" data-parent="#accordion" 
			                href="#collapseThree">
			                	采购人：c，采购时间：2020/2/12
			                </a>
			            </h4>
			        </div>
			        <div id="collapseThree" class="panel-collapse collapse">
			            <div class="panel-body">
			                	采购商品列表：1.牛奶1*20，2.牛奶2*30，3.牛奶3*35
			            </div>
			        </div>
    			</div>
	    	</div>
	    	<a href="${pageContext.request.contextPath}/views/message/seeMoreMessage.jsp" style="display:block;text-align: right;" rel="external">查看更多</a>
	    	
	   
		</div>
	</div>

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
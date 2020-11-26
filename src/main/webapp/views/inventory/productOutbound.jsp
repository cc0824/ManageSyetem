<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备上进行绘制和触屏缩放 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>商品出库</title>
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
<script src="${APP_PATH }/static/js/sockjs.min.js"></script>
<script type="text/javascript">
	function logout() {
		if (confirm("确定要退出登陆吗？")) {
			sessionStorage.clear();
			window.location.href = "${pageContext.request.contextPath}/login.jsp";
		}
	}
	
	$(function(){
		/*
		这里也写了个心跳重连，重新连接就是断开连接的时候socket会执行onclose()方法，然后在onclose方法里调用restConnect();方法重新连接。
		然后在连接成功的时候调用heartCheck.start();方法开始计时，每间隔一段时间给后端service发送一次消息，如果有返回信息就说明连接没有断开，这时候再调用heartCheck.reset();方法重新计时
		*/
		//获取webSocket路径
		var wsPath=wsPath();
		function wsPath(){
		    var local=window.location;
		    var contextPath=local.pathname.split("/")[1];
		    return "ws://"+local.host+"/"+contextPath+"/";
		};

	    //建立socket连接
	    var sock;
	    var lockReconnect = false,count=0;
	    createWebSocket(); 


	    function createWebSocket(){
	        try {
	            if ('WebSocket' in window) {
	                sock = new WebSocket(wsPath+"socketServer"); 
	            } else if ('MozWebSocket' in window) {
	                sock = new MozWebSocket(wsPath+"socketServer");
	            } else {
	                sock = new SockJS(wsPath+"sockjs/socketServer");
	            }
	            init();
	        } catch (e) {
	            console.log('Ceate WebSocket Error ! Tring To RestConnection !'+e);
	            restConnect();
	        }

	    }

	    function init(){
	        sock.onopen = function (e) {
	            heartCheck.start();
	            console.debug(" WebSocket Connection Success ! ");
	        };
	        sock.onmessage = function (e) {
	            heartCheck.reset();
	            if(e.data==""){
	                return false;
	            }
	            var socketMSG=JSON.parse(e.data);
	            //socketMSG.MSG 我这里后端传的是个json 所以这么写的
	            if(socketMSG.MSG!=undefined){
	            //e.data是获取后端传送的消息，我这里的操作时把信息拿出来放到消息栏并提示， 这里根据自己的需求修改吧。
	            }
	        };
	        sock.onerror = function (e) {
	            console.error(" WebSocket Connection Failure ! Tring To RestConnect !"+e);
	            restConnect();
	        };
	        sock.onclose = function (e) {
	            console.warn(" WebSocket Connection Close ! Tring To RestConnect !"+e);
	            restConnect();
	        }
	    }


	    function restConnect(){
	        if(lockReconnect){
	            return;
	        }
	        if(count<=3){
	            createWebSocket();
	            lockReconnect=true;
	        }else{
	            console.error('WebSocket Connection Timeout!');
	        }
	    }

	    var heartCheck = {
	        timeout: 300000,//60ms
	        timeoutObj: null,
	        serverTimeoutObj: null,
	        reset: function(){
	            clearTimeout(this.timeoutObj);
	            clearTimeout(this.serverTimeoutObj);
	    　　　　 		this.start();
	        },
	        start: function(){
	            var _this = this;
	            this.timeoutObj = setTimeout(function(){
	                sock.send("");
	                _this.serverTimeoutObj = setTimeout(function(){
	                    sock.close();
	                }, _this.timeout)
	            }, this.timeout)
	        }
	    };


		//窗口关闭前,主动关闭websocket连接 
	    window.onbeforeunload = function () { 
	    	sock.close(); 
	    };
	})

	
</script>
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
	<!-- 搭建显示页面 -->
	<div class="container-fluid">
		<form class="form-horizontal">
			<div class="form-group">
				<label for="inputUser" class="col-xs-3 control-label"
					style="text-align: right">操作员</label>
				<div class="col-xs-7">
					<select class="form-control">
						<option>库管员</option>
						<option>店长</option>
						<option>理货员</option>
						<option>4</option>
						<option>5</option>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label for="inputPassword3" class="col-xs-3 control-label"
					style="text-align: right">出库时间</label>
				<div class="col-xs-7">
					<input type="password" class="form-control" id="inputPassword3"
						placeholder="出库时间">
				</div>
			</div>
			<div class="form-group">
				<label for="inputUser" class="col-xs-3 control-label"
					style="text-align: right">出库类型</label>
				<div class="col-xs-7">
					<select class="form-control">
						<option>货架补货</option>
						<option>门店调货</option>
						<option>退货</option>
					</select>
				</div>
			</div>
			<div class="form-group">
				<div class="col-xs-offset-2 col-xs-8" style="text-align: center">
					<button type="submit" class="btn btn-success">添加出库商品信息</button>
				</div>
			</div>


			<div class="form-group">
				<div class="col-xs-offset-6 col-xs-4" style="text-align: right">
					<button type="submit" class="btn btn-default">申请出库</button>
				</div>
			</div>
		</form>


		<div>
			<label for="inputUser" class="col-xs-4 control-label"
				style="text-align: left">出库记录表</label> </br> </br>
			<div class="panel-group" id="accordion">
				<div class="panel panel-info">
					<div class="panel-heading">
						<h4 class="panel-title">
							<a data-toggle="collapse" data-parent="#accordion"
								href="#collapseOne" > 第一条出库记录 <span class="badge">10</span></a>
						</h4>
					</div>
					<div id="collapseOne" class="panel-collapse collapse in">
						<div class="panel-body">出库人：<label id="" value="张三"/></div>
					</div>
				</div>
				<div class="panel panel-info">
					<div class="panel-heading">
						<h4 class="panel-title">
							<a data-toggle="collapse" data-parent="#accordion"
								href="#collapseTwo"> 第二条出库记录 <span class="badge">5</span> </a>
						</h4>
					</div>
					<div id="collapseTwo" class="panel-collapse collapse">
						<div class="panel-body"></div>
					</div>
				</div>
				<div class="panel panel-info">
					<div class="panel-heading">
						<h4 class="panel-title">
							<a data-toggle="collapse" data-parent="#accordion"
								href="#collapseThree" > 第三条出库记录 <span class="badge">20</span> </a>
						</h4>
					</div>
					<div id="collapseThree" class="panel-collapse collapse">
						<div class="panel-body"></div>
					</div>
				</div>
			</div>
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
			<a href="#">消息 <span class="badge" id="messageNum">2</span></a>
		</button></div>
	</div>
    </div>






</body>
</html>
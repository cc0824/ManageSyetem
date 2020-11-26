<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备相应布局 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>搜索详情页面</title>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!-- web路径：
不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306)；需要加上项目名
		http://localhost:3306/crud
 -->
<!-- 引入jquery -->
<script type="text/javascript"
	src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<!-- 引入bootstrap -->
<link
	href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<script type="text/javascript">
	$(function() {
		//获取url中的参数
		var searchData;
		//自动获取地址栏链接带？以及后面的字符串
		var url = window.location.search;
		//定义一个空对象
		var obj = {};
		//如果字符串里面存在?
		if(url.indexOf("?") != -1){
			//从url的索引1开始提取字符串
			var str = url.substring(1);
			//如果存在&符号，则再以&符号进行分割
			var arr = str.split("&");
			//遍历数组
			for(var i=0; i<arr.length; i++){
				//obj对象的属性名 = 属性值，unescape为解码字符串
				obj[arr[i].split("=")[0]] = decodeURI(arr[i].split("=")[1]);
			}
		}
		searchData=obj.searchData;
		console.log(searchData);
		//展示页面
		$.ajax({
			url:"${APP_PATH}/menu/getSearchMenu.do",
			data:"searchData="+searchData,
			type:"GET",
			success:function(result){
    			alert("ok");
    			console.log(result);
    			//将数据展示到表格中
    			displaySearchDataResult(result.extend.searchMenus);
    			
    		},
    		error:function(result){
    			alert("fail");
    		}
		});
		function displaySearchDataResult(result){
			$.each(result,function(index,item){
				//展示
				var datali=$("<li class='list-group-item'></li>").append($("<a></a>").attr("href","${APP_PATH}/views/"+item.menuUrl).append(item.menuName));
				$(".list-group").append(datali);
			});
		}
		
	})
</script>
<style type="text/css">
#button2 {
	text-align: right
}

#page1 {
	text-align: center
}

#page2 {
	text-align: center
}
#label1{
	text-align: center
}
</style>
</head>
<body>
	<!-- 传统的显示页面：浏览器发送页面请求，通过控制器解析数据，把数据封装给pageinfo对象，再返回给浏览器，在转发的页面中用el表达式调用这些数据 -->
	<!-- 现在的方法：利用ajax转发页面，解析数据，底下的表格显示信息、分页显示信息等代码都全部使用ajax展示-->
	<!-- 搭建显示界面 -->
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
  			管理系统</a>
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

	<div class="container">
		<!-- 页面 -->
		<div class="row ">
			<div style="text-align: center">
				<label  >搜索结果</label>

				<button type="button" class="btn btn-info btn-sm col-xs-offset-7" >
					<span class="glyphicon glyphicon-search" aria-hidden="true"></span> 搜索
				</button>
				
				
			</div>
		</div>
		<div><label></label></div>
		<label  >菜单项</label>
		<ul class="list-group">
<!-- 			<li class="list-group-item">Cras justo odio</li> -->
		</ul>
		
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
				<a href="#">消息 <span class="badge">2</span></a>
			</button>
		</div>
	    </div>
		</nav>



	</div>




</body>

</html>
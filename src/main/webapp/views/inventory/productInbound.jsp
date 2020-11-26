<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备上进行绘制和触屏缩放 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>商品入库</title>
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
	
	$(function(){
		$("#inboundButton").click(function(){
			var tr = $("#product_table tr"); // 获取table中每一行内容
			var result = []; // 数组
			for (var i = 0; i < tr.length; i++) {// 遍历表格中每一行的内容
				var tds = $(tr[i]).find("td");
				if (tds.length > 0) {
					if($(tds[0]).find("input").val()!=""||$(tds[1]).find("input").val()!=""||
							$(tds[2]).find("input").val()!=""||$(tds[3]).find("input").val()!=""){
					result.push({
						"inboundName" : $(tds[0]).find("input").val(),
						"inboundCost" : $(tds[1]).find("input").val(),
						"inboundSize" : $(tds[2]).find("input").val(),
						"inboundTotal" : $(tds[3]).find("input").val()
					})
					}
				}
			}
			console.log(result);
			// json对象
 			var jsonObjectData = { 
 				"inboundList" : result
 			};
 			console.log("jsonObjectData--->"+jsonObjectData);
			// 将json对象转换成json字符串
			var jsonData=JSON.stringify(jsonObjectData);
			console.log("jsonData--->"+jsonData);

			$.ajax({
				type : "POST",
				url : "${APP_PATH}/inbound/addInbound.do",
				headers: {
					'Accept': 'application/json',
					'Content-Type': 'application/json'},
				data : JSON.stringify(result),
				dataType:"json",
				success : function(data) {
		 			alert("inbound-success");
		 			window.location.href="${pageContext.request.contextPath}/views/inventory/productInbound.jsp";
				},
				error:function(result){
					alert("inbound-fail");
				}
			});
			
			
			
		});
		
		
		//日历展示
		var startTime,endTime;
		laydate.render({
			elem: '#test1', //指定元素
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
		  	elem: '#test2', //指定元素
		  	done:function(value,date,endDate){
		  		endTime=value;
				//console.log(value); 
			    //console.log(date); 
			    //console.log(endDate);
			}
		});
		
		
		
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
				<li class="active"><a href="${pageContext.request.contextPath }/views/background/backgroundhome.jsp">后台管理</a></li>
<%-- 			<li><a href="${pageContext.request.contextPath }/login.jsp">退出登陆</a></li> --%>
				<li><a href="javascript:logout()">退出登陆</a></li>
			</ul>
		</div>
	</div>
	</nav>
	<!-- 搭建显示页面 -->
	<div class="container">
		<div class="row">
			<div class="col-xs-12">
				<div class="table-responsive ">
					<table class="table" id="product_table" border="1">

						<thead>
							<tr>
								<th>名称</th>
								<th>成本</th>
								<th>数目</th>
								<th>总金额</th>

							</tr>
						</thead>
						<tbody>
							<tr>
								<td><input type="text" name="productName"
									class="form-control" id="name_input1"></td>
								<td><input type="text" name="productCost"
									class="form-control" id="cost_input1"></td>
								<td><input type="text" name="productSize"
									class="form-control" id="size_input1"></td>
								<td><input type="text" name="productTotal"
									class="form-control" id="total_input1"></td>
							</tr>
							<tr>
								<td><input type="text" name="productName"
									class="form-control" id="name_input2"></td>
								<td><input type="text" name="productCost"
									class="form-control" id="cost_input2"></td>
								<td><input type="text" name="productSize"
									class="form-control" id="size_input2"></td>
								<td><input type="text" name="productTotal"
									class="form-control" id="total_input2"></td>
							</tr>
							<tr>
								<td><input type="text" name="productName"
									class="form-control" id="name_input3"></td>
								<td><input type="text" name="productCost"
									class="form-control" id="cost_input3"></td>
								<td><input type="text" name="productSize"
									class="form-control" id="size_input3"></td>
								<td><input type="text" name="productTotal"
									class="form-control" id="total_input3"></td>
							</tr>
							<tr>
								<td><input type="text" name="productName"
									class="form-control" id="name_input4"></td>
								<td><input type="text" name="productCost"
									class="form-control" id="cost_input4"></td>
								<td><input type="text" name="productSize"
									class="form-control" id="size_input4"></td>
								<td><input type="text" name="productTotal"
									class="form-control" id="total_input4"></td>
							</tr>
							<tr>
								<td><input type="text" name="productName"
									class="form-control" id="name_input5"></td>
								<td><input type="text" name="productCost"
									class="form-control" id="cost_input5"></td>
								<td><input type="text" name="productSize"
									class="form-control" id="size_input5"></td>
								<td><input type="text" name="productTotal"
									class="form-control" id="total_input5"></td>
							</tr>
							<tr>
								<td><input type="text" name="productName"
									class="form-control" id="name_input6"></td>
								<td><input type="text" name="productCost"
									class="form-control" id="cost_input6"></td>
								<td><input type="text" name="productSize"
									class="form-control" id="size_input6"></td>
								<td><input type="text" name="productTotal"
									class="form-control" id="total_input6"></td>
							</tr>
							<tr>
								<td><input type="text" name="productName"
									class="form-control" id="name_input7"></td>
								<td><input type="text" name="productCost"
									class="form-control" id="cost_input7"></td>
								<td><input type="text" name="productSize"
									class="form-control" id="size_input7"></td>
								<td><input type="text" name="productTotal"
									class="form-control" id="total_input7"></td>
							</tr>
							<tr>
								<td><input type="text" name="productName"
									class="form-control" id="name_input8"></td>
								<td><input type="text" name="productCost"
									class="form-control" id="cost_input8"></td>
								<td><input type="text" name="productSize"
									class="form-control" id="size_input8"></td>
								<td><input type="text" name="productTotal"
									class="form-control" id="total_input8"></td>
							</tr>
							
						</tbody>

					</table>
				</div>
			</div>
		</div>
		<form class="form-horizontal">
			<div class="form-group">
				<label for="xxx" class="col-xs-4 control-label" style="text-align:right">操作人</label>
				<div class="col-xs-6">
					<input type="xxxxxx" class="form-control" id="xxx">
				</div>
			</div>
			<div class="form-group">
				<label for="startTime" class="col-xs-4 control-label" style="text-align:right">操作时间</label>
				<div class="col-xs-6">
					<input type="text" class="form-control" 
						class="demo-input" placeholder="请选择日期" id="test1" name="startTime"></input>
				</div>
			</div>
			<div class="form-group">
				<div class="col-xs-offset-6 col-xs-6">
					<button type="button" class="btn btn-success" id="inboundButton">入库</button>
					<button type="button" class="btn btn-danger">修改</button>
					
				</div>
			</div>
		</form>
	</div>





</body>
</html>
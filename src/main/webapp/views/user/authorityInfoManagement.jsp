<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备相应布局 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>用户管理页面</title>
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
		/***********************************/
		/**********分页信息使用json显示**********/
		/***********************************/
		
		//定义变量：总记录数和当前页码
		var totalRecord,currentPage;
		
		//页面加载完成以后，直接去发送ajax请求,要到分页数据
		//跳转到首页
		to_page(1);
		//跳转页面函数		
		function to_page(pn){
			$.ajax({
				url:"${APP_PATH}/user/getAllUserWithRole.do",
				data:"pn="+pn,//pn=指定的pn
				type:"GET",
				success:function(result){
					//0.控制台测试f12-双击响应路径-network-response
					console.log(result);
					//1、解析并显示商品信息
					build_userWithRole_table(result);
					//2、解析并显示分页信息
					build_page_info(result);
					//3、解析显示分页条数据
					build_page_nav(result);
					$("#check_all").prop("checked",false);
				}
			});
		}
		//解析并显示商品信息函数
		function build_userWithRole_table(result){
			//每次跳转页面都要先清空table表格
			$("#userWithRole_table tbody").empty();
			var userWithRoles = result.page.list;
			console.log(userWithRoles);
			$.each(userWithRoles,function(index,item){
				//创建td,如果没有就自动创建出来，append为每个元素结尾添加内容
				var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
				var userIdTd = $("<td></td>").append(item.userId);
				var userNameTd = $("<td></td>").append(item.userName);
				var userRoleNameTd =$("<td></td>").append(item.role.roleName);				
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-xs edit_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
				editBtn.attr("edit-id",item.userId);
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-xs delete_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
				delBtn.attr("del-id",item.userId);
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				
				//创建tr
				$("<tr></tr>").append(checkBoxTd)
					.append(userIdTd)
					.append(userNameTd)
					.append(userRoleNameTd)
					.append(btnTd)
					.appendTo("#userWithRole_table tbody");

			});
		}
		//解析显示分页信息函数
		function build_page_info(result){
			//每次跳转页面都要先清空分页信息
			$("#page_info_area").empty();
			//json格式数据为{"code":100,"msg":"处理成功","extend":{"pageInfo":{"pageNum":1,"pageSize":10,"size":10,"startRow":1,"endRow":10,"total":61,"pages":7,"list":[]
			$("#page_info_area").append("当前"+result.page.pageNum+"页,总"+
					result.page.pages+"页,总"+
					result.page.total+"条记录");
			//取得总记录数
			totalRecord = result.page.total;
			//取得当前页码
			currentPage = result.page.pageNum;
		}
		//解析显示分页条函数，点击分页要能去下一页....
		function build_page_nav(result){
			//每次跳转页面都要先清空分页条信息
			$("#page_nav_area").empty();
			//创建ul
			var ul = $("<ul></ul>").addClass("pagination").attr("margin-left","50px");			
			//构建首页、前一页、后一页、末页
			var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr({href:"#"}));
			var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
			var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
			var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
			//是否有前一页
			if(result.page.hasPreviousPage == false){
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			}else{
				firstPageLi.click(function(){
					to_page(1);
				});
				prePageLi.click(function(){
					to_page(result.page.pageNum -1);
				});
			}
			//是否有下一页
			if(result.page.hasNextPage == false){
				nextPageLi.addClass("disabled");
				lastPageLi.addClass("disabled");
			}else{
				nextPageLi.click(function(){
					to_page(result.page.pageNum +1);
				});
				lastPageLi.click(function(){
					to_page(result.page.pages);
				});
			}
								
			//首页和前一页的提示添加到ul
			ul.append(firstPageLi).append(prePageLi);			
			//遍历页码号1、2、3、4、5，把页码号添加到ul
			$.each(result.page.navigatepageNums,function(index,item){				
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				//将当前页码显示
				if(result.page.pageNum == item){
					numLi.addClass("active");
				}
				//点击页码跳转
				numLi.click(function(){
					to_page(item);
				});
				//把页码号添加到ul
				ul.append(numLi);
			});
			//下一页和末页的提示添加到ul
			ul.append(nextPageLi).append(lastPageLi);			
			//把ul加入到nav
			var navEle = $("<nav></nav>").append(ul);
			//把nav添加到分页条区域
			navEle.appendTo("#page_nav_area");
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
				<label  >权限信息</label>

				<button type="button" class="btn btn-info btn-sm col-xs-offset-7" >
					<span class="glyphicon glyphicon-search" aria-hidden="true"></span> 搜索
				</button>
			</div>
		</div>
		<div><label></label></div>
		<!-- 商品信息展示 -->
		<!-- 响应式表格 -->
		<div class="row">
			<div class="col-xs-12">
				<div class="table-responsive">
					<table class="table" id="userWithRole_table">					
						<thead>
							<tr>
								<!-- 表头th -->
								<th>
									<input type="checkbox" id="check_all"/>
								</th>
								<th>编号</th>
								<th>用户名称</th>
								<th>权限名称</th>
								<th>操作</th>
							</tr>
						</thead>

						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<!--按钮显示  -->
		<div class="col-xs-offset-7 " id="button2">
			<button class="btn btn-primary btn-sm" id="add_user_button">
				<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>新增
			</button>
			<button class="btn btn-danger btn-sm" id="delete_user_button">
				<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除
			</button>
		</div>

		<!-- 利用ajax显示 -->
		<div class="row">
			<!--分页文字信息  -->
			<div class="col-xs-6" id="page_info_area" style="margin:0 auto;"></div>
			<!-- 分页条信息 -->
			<div class="col-xs-12" id="page_nav_area" style="margin:0 auto;"></div>
		</div>

		<!-- 添加商品的模态框 -->
		<div class="modal fade" id="userAddModal" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">添加商品信息</h4>
					</div>
					<div class="modal-body">
						<!-- 使用水平排列的表单 -->
						<form class="form-horizontal" id="productAddForm">
							<!-- 输入商品名称的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">商品名称</label>
								<div class="col-xs-9">
									<input type="text" name="productName" class="form-control"
										id="productName_add_input" placeholder="商品名称"> 
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 输入商品成本的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">商品成本</label>
								<div class="col-xs-9">
									<input type="text" name="productCost" class="form-control"
										id="productCost_add_input" placeholder="商品成本"> 
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 输入商品价格的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">商品价格</label>
								<div class="col-xs-9">
									<input type="text" name="productPrice" class="form-control"
										id="productPrice_add_input" placeholder="商品价格"> 
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 输入商品产地的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">商品产地</label>
								<div class="col-xs-9">
									<input type="text" name="productArea" class="form-control"
										id="productArea_add_input" placeholder="商品产地"> 
									<span class="help-block"></span>
								</div>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" id="product_save_btn">保存</button>
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div>
		</div>

		<!-- 商品修改的模态框 -->
		<div class="modal fade" id="productUpdateModal" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">修改商品信息</h4>
					</div>
					<div class="modal-body">
						<!-- 使用水平排列的表单 -->
						<form class="form-horizontal" id="productUpdateForm" >
							<!-- 修改商品名称的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">商品名称</label>
								<div class="col-xs-9">
									<!-- 不想让商品信息被修改  将input替换成静态控件 -->
 									<input type="text" name="productName" class="form-control"
										id="productName_update_input" placeholder="商品名称">
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 修改商品成本的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">商品成本</label>
								<div class="col-xs-9">
									<input type="text" name="productCost" class="form-control"
										id="productCost_update_input" placeholder="商品成本"> <span
										class="help-block"></span>
								</div>
							</div>
							<!-- 修改商品价格的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">商品价格</label>
								<div class="col-xs-9">
									<input type="text" name="productPrice" class="form-control"
										id="productPrice_update_input" placeholder="商品价格"> 
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 修改商品产地的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">商品产地</label>
								<div class="col-xs-9">
									<input type="text" name="productArea" class="form-control"
										id="productArea_update_input" placeholder="商品产地"> 
									<span class="help-block"></span>
								</div>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" id="product_update_btn">修改</button>
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div>
		</div>
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



	</div>




</body>

</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备相应布局 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>库存管理页面</title>
<% pageContext.setAttribute("APP_PATH", request.getContextPath()); %>
<!-- 引入jquery -->
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<!-- 引入bootstrap -->
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<script type="text/javascript">
	$(function() {
		/********************************************************************/
		/**************************分页信息使用json显示*************************/
		/********************************************************************/


		//定义变量：总记录数和当前页码
		var totalRecord,currentPage;
		
		//页面加载完成以后，直接去发送ajax请求,要到分页数据
		//跳转到首页
		to_page(1);
		//跳转页面函数		
		function to_page(pn){
			$.ajax({
				url:"${APP_PATH}/inventory/displayInventoryInformation.do",
				data:"pn="+pn,//pn=指定的pn
				type:"GET",
				success:function(result){
					console.log(result);
 					var inventorys = result.extend.pageInfo.list;
 					logPageHref();
 					build_inventory_table(inventorys);
 					build_page_info(result);
 					build_page_nav(result);
 					$("#check_all").prop("checked",false);//取消全选
				}
			});
		}
		
		
		
		//判断页面跳转来源
		function logPageHref(){
			var ref = ''; 
			if (document.referrer.length > 0) { 
			  	ref = document.referrer; 
				console.log(ref);
				
			} 
		}
		//解析并显示商品信息函数
		function build_inventory_table(result){
			//每次跳转页面都要先清空table表格
			$("#inventory_table tbody").empty();
			//在'A','B','C','D','E'中随机取值，暂时无用
		 	var arr = ['A','B','C','D','E'];
		    var	idvalue=arr[Math.floor(Math.random()*5)];
			 
			//遍历inventorys,遍历的回调函数function
			$.each(result,function(index,item){
				var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");//多选框
				var inventoryIdTd = $("<td></td>").append(item.inventoryId);//库存id
				var inventoryNameTd=$("<td></td>").append(item.product.productName);//库存名称
				var inventorySizeTd = $("<td></td>").append(item.inventorySize);//库存数量
				var inventoryAreaTd =$("<td></td>").append(item.inventoryArea);//库存区域
				
				//创建编辑按钮
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-xs edit_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
				//为编辑按钮添加一个自定义的属性来表示当前商品id
				editBtn.attr("edit-id",item.inventoryId);
				//创建删除按钮
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-xs delete_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
				//为删除按钮添加一个自定义的属性来表示当前删除的员工id
				delBtn.attr("del-id",item.inventoryId);
				//把两个按钮创建到一个单元格
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				
				//创建tr
				//append方法执行完成以后还是返回原来的元素，每次append返回tr再继续append
				$("<tr></tr>").append(checkBoxTd)
					.append(inventoryIdTd)
					.append(inventoryNameTd)
					.append(inventorySizeTd)
					.append(inventoryAreaTd)
					.append(btnTd)
					.appendTo("#inventory_table tbody");

			});
		}
		//解析显示分页信息函数
		function build_page_info(result){
			//每次跳转页面都要先清空分页信息
			$("#page_info_area").empty();
			//json格式数据为{"code":100,"msg":"处理成功","extend":{"pageInfo":{"pageNum":1,"pageSize":10,"size":10,"startRow":1,"endRow":10,"total":61,"pages":7,"list":[]
			$("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页,总"+
					result.extend.pageInfo.pages+"页,总"+
					result.extend.pageInfo.total+"条记录");
			//取得总记录数
			totalRecord = result.extend.pageInfo.total;
			//取得当前页码
			currentPage = result.extend.pageInfo.pageNum;
		}
		//解析显示分页条函数，点击分页要能去下一页....
		function build_page_nav(result){
			//每次跳转页面都要先清空分页条信息
			$("#page_nav_area").empty();
			//创建ul
			var ul = $("<ul></ul>").addClass("pagination");			
			//构建首页、前一页、后一页、末页
			var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
			var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
			var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
			var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
			//是否有前一页
			if(result.extend.pageInfo.hasPreviousPage == false){
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			}else{
				firstPageLi.click(function(){
					to_page(1);
				});
				prePageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum -1);
				});
			}
			//是否有下一页
			if(result.extend.pageInfo.hasNextPage == false){
				nextPageLi.addClass("disabled");
				lastPageLi.addClass("disabled");
			}else{
				nextPageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum +1);
				});
				lastPageLi.click(function(){
					to_page(result.extend.pageInfo.pages);
				});
			}
								
			//首页和前一页的提示添加到ul
			ul.append(firstPageLi).append(prePageLi);			
			//遍历页码号1、2、3、4、5，把页码号添加到ul
			$.each(result.extend.pageInfo.navigatepageNums,function(index,item){				
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				//将当前页码显示
				if(result.extend.pageInfo.pageNum == item){
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
		
		
		
		/********************************************************************/
		/**********************************搜索*******************************/
		/********************************************************************/
		var searchData;
		//点击搜索按钮，弹出搜索框
		$(document).on("click","#searchButton",function(){
			//清除表单数据（表单完整重置（表单的数据，表单的样式））
			//reset_form("#storeInfoAddModal form");
			//弹出模态框
			$("#searchModal").modal({
				backdrop:"static"
			});
		});
		//点击模态框搜索按钮，进行搜索
		$("#searchBtn").click(function() {
			//1、模态框中填写的表单数据提交给服务器进行保存，在controller定义保存方法

			//2、数据校验

			//3、发送ajax请求保存信息
			//测试能否取到模态框中form信息
			searchData=$("#search_input").val();
			//alert(searchData);
			$.ajax({
				url : "${APP_PATH}/inventory/getDataBySearch.do",
				type : "GET",
				data : "searchData="+searchData,
				success : function(result) {
					//测试
					console.log(result);
					//信息保存成功
					//1.关闭模态框
					$("#searchModal").modal('hide');
					//2.重置门店列表
					var data=result.extend.searchDatas;
					var flag=result.extend.searchDatas.length;
					if(flag>0){
						searchDataFlag=true;
					}
					$("#inventory_table tbody").empty();
					build_inventory_table(data);
					
					

				},
				error:function(result){
					alert("fail");
				}

			});
		});
		
		/********************************************************************/
		/*****************************新增库存信息*****************************/
		/********************************************************************/
		//点击新增按钮显示新增模态框
		$("#add_inventory_button").click(function() {
			//清除表单数据（表单完整重置（表单的数据，表单的样式））
			//或者使用$("")[0].reset();
			reset_form("#inventoryAddModal form");
			$("#alertModalDiv").css("display","none");
			//设置点击模态框周围空白区域不会关闭模态框
			$("#inventoryAddModal").modal({
				backdrop : "static"
			});
		});
		//清空表单样式及内容
		function reset_form(ele){
			$(ele)[0].reset();
			//清空表单样式
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}
		//点击模态框保存按钮，将数据保存至数据库，并显示在页面上
		$("#inventory_save_btn").click(function() {
			console.log($("#inventoryAddForm").serialize());
			console.log($("#inventoryName_add_input").val());
			//1、检测是否已经存在该商品信息
			$.ajax({
				url:"${APP_PATH}/inventory/checkNewInventoryExist.do",
				type:"GET",
				data:{"inventoryName":$("#inventoryName_add_input").val()},
				success:function(result) {
					console.log(result.extend.existFlag);
					//商品不存在
					if(result.extend.existFlag==0){
						//需要先新增商品信息
						$("#alertModalDiv").css("display","block");

					}else{ 
						//2、发送ajax请求保存商品信息
						$.ajax({
							url : "${APP_PATH}/inventory/addNewInventory.do",
							type : "POST",
							data : $("#inventoryAddForm").serialize(),
							success : function(result) {
								console.log(result);
								//1、关闭模态框
								$("#inventoryAddModal").modal('hide');
								//2、来到最后一页显示新增的信息，保证totalRecord大于总页码
								to_page(totalRecord);

							},
							error:function(result){
								alert("fail");
							}

						});
					
					
					
					}
				},
				error:function(result){
					alert("fail");
				}
			
			});

			

		})

		
		
		


		/********************************************************************/
		/******************************修改商品信息*****************************/
		/********************************************************************/
		//1、为编辑按钮绑定事件
		//这样绑定不上的原因：编辑按钮是ajax生成的，而这种绑定是页面dom一加载完就绑定了，这时按钮还没生成
		/*$("#edit_button").click(function() {
			alert("ok");
		})*/		
		//两种解决办法：1）、可以在创建按钮的时候绑定。    2）、绑定点击.live()，但是jquery新版没有live，使用on进行替代
		$(document).on("click",".edit_btn",function(){
			//alert("edit");						
			//1、查出部门信息，并显示部门列表
			//getDepts("#empUpdateModal select");
			//2、查出商品信息
			getSelectProduct($(this).attr("edit-id"));			
			//3、把商品的id传递给模态框的更新按钮
			$("#product_update_btn").attr("edit-id",$(this).attr("edit-id"));
			$("#productUpdateModal").modal({
				//backdrop:"static"
			});
		});
		
		function getSelectProduct(id){
			$.ajax({
				url:"${APP_PATH}/product/getProductById.do",
				data:"id="+id,
				type:"GET",
				success:function(result){
					//console.log(result);
					//拿到返回的数据
					var productData=result.extend.product;
					//给input框赋值
					$("#productName_update_input").val(productData.productName);
					$("#productCost_update_input").val(productData.productCost);
					$("#productPrice_update_input").val(productData.productPrice);
					$("#productArea_update_input").val(productData.productArea);

				}
			});
		}
		
		//点击修改按钮，更新商品信息
		$("#product_update_btn").click(function(){
			//1、验证输入格式
			
			//2、发送ajax'请求保存信息
			console.log($("#productUpdateForm").serialize()+"&_method=PUT");
			$.ajax({
				url:"${APP_PATH}/product/updateProduct.do",
				type:"PUT",
				//contentType: "application/x-www-form-urlencoded",
				date:$("#productUpdateForm").serialize(),
				//url:"${APP_PATH}/product/updateProduct.do",
				//type:"PUT",
				//date:$("#productUpdateForm").serialize(),
				success:function(result){
					//0.测试
					alert(result.msg);
					//1、关闭模态框
					//$("#productUpdateModal").modal("hide");
					//2、回到该商品所在分页
					//to_page(currentPage);
				},
				error:function(result){
					alert("fail");
				}
			});
		});


				

		


		/********************************************************************/
		/***************************删除商品信息********************************/
		/********************************************************************/
		//单个删除
		$(document).on("click",".delete_btn",function(){
			//1、弹出确认删除对话框
			//eq()指定index值的元素，index从0开始，td:eq(2)表示第三个td
			//alert($(this).parents("tr").find("td:eq(2)").text());
			var productId=$(this).attr("del-id");
			var productName = $(this).parents("tr").find("td:eq(2)").text();
			//console.log(productId);
			confirmDelete(productId,productName);
			
		});		
		function confirmDelete(productId,productName){
			console.log(productId);
			if(confirm("确认删除【"+productName+"】吗？")){
				$.ajax({
					url: "${APP_PATH}/product/deleteProduct.do",
					type:"post",
					data:{productId:productId,_method:"DELETE"},
					success:function(result){
						console.log(result);
						alert("ok")
						to_page(currentPage);
					},
					error:function(result){
						alert("fail");
					}
				
				});
				
			}
		}
		//完成全选/全不选功能
		$("#check_all").click(function(){
			//attr获取checked是undefined;用prop修改和读取dom原生属性的值
			//$(this).prop("checked")获取全选按钮的选中状态
			$(".check_item").prop("checked",$(this).prop("checked"));
		});
		
		//每页的单选框都被选中后，全选按钮也被选中
		$(document).on("click",".check_item",function(){
			//判断当前选择中的元素是否5个
			//:checked选择器，选择被选中的单选框
			//.length代替.size属性
			//alert($(".check_item:checked").length);
			//用flag代替if else
			var flag = $(".check_item:checked").length==$(".check_item").length;
			$("#check_all").prop("checked",flag);
		})
		

		//点击全部删除，就批量删除
		$("#delete_product_button").click(function(){
			//定义空字符串
			var productNames = "";
			var productIds = "";
			//$(".check_item:checked")找到被选中的商品
			$.each($(".check_item:checked"),function(){
				//this表示被选中的元素
				//alert($(this).parents("tr").find("td:eq(2)").text());
				productNames += $(this).parents("tr").find("td:eq(2)").text()+",";
				//alert($(this).parents("tr").find("td:eq(1)").text());
				productIds += $(this).parents("tr").find("td:eq(1)").text()+"-";
			});
			//去除productNames多余的,substring截取字符串长度
			productNames = productNames.substring(0, productNames.length-1);
			//alert(productNames);
			//去除del_idstr多余的-
			productIds = productIds.substring(0, productIds.length-1);
			//alert(productIds);
			if(confirm("确认删除【"+productNames+"】吗？")){
				//发送ajax请求删除
				$.ajax({
					url:"${APP_PATH}/product/deleteProductBatch.do",
					type:"post",
					data:{productIds:productIds,_method:"DELETE"},
					success:function(result){
						alert("ok");
						console.log(result.msg);
						//回到当前页面
						to_page(currentPage);
					}
				});
			}
		});
		

		
		
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
  			库存管理</a>
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
				<label  >库存信息</label>
				<button type="button" class="btn btn-info btn-sm col-xs-offset-7" id="searchButton">
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
					<table class="table" id="inventory_table">					
						<thead>
							<tr>
								<!-- 表头th -->
								<th>
									<input type="checkbox" id="check_all"/>
								</th>
								<th>编号</th>
								<th>商品名称</th>
								<th>库存数量</th>
								<th>区域</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody></tbody>
						
					</table>
				</div>
			</div>
		</div>
		<!--按钮显示  -->
		<div class="col-xs-offset-7 " id="button2">
			<button class="btn btn-primary btn-sm" id="add_inventory_button">
				<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>新增
			</button>
			<button class="btn btn-danger btn-sm" id="delete_inventory_button">
				<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除
			</button>
		</div>
		<!-- 利用ajax显示 -->
		<div class="row">
			<div style="height:20px;"></div>
			<!--分页文字信息  -->
			<div class="col-xs-6" id="page_info_area" style="text-align:center;width:100%;clear:both;margin:0 auto;position:relative;display:block;"></div>
			<!-- 分页条信息 -->
			<div class="col-xs-12" id="page_nav_area" style="text-align:center;margin:0 auto;"></div>
		</div>

		
		<!-- 搜索按钮模态框 -->
		<div class="modal fade" id="searchModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <h4 class="modal-title" id="myModalLabel">搜索：</h4>
	            </div>
	            <div class="modal-body">
	            	<form class="form-horizontal"  id="searchForm">
	            		<div class="form-group">
						    <label for="search_input" class="col-xs-4 control-label">关键字</label>
						    <div class="col-xs-8">
						      <input type="text" class="form-control" id="search_input" 
						      	name="searchInput" placeholder="请输入">
						    </div>
						</div>
					</form>
				</div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	                <button type="button" class="btn btn-primary" id="searchBtn">搜索</button>
	            </div>
	        </div><!-- /.modal-content -->
	    </div><!-- /.modal -->
		</div>
		
		<!-- 添加库存的模态框 -->
		<div class="modal fade" id="inventoryAddModal" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">添加库存信息</h4>
					</div>
					<div class="modal-body">
						<!-- 使用水平排列的表单 -->
						<form class="form-horizontal" id="inventoryAddForm">
							<!-- 输入库存名称的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">库存名称</label>
								<div class="col-xs-9">
									<input type="text" name="inventoryName" class="form-control"
										id="inventoryName_add_input" placeholder="库存名称"> 
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 输入库存数量的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">库存数量</label>
								<div class="col-xs-9">
									<input type="text" name="inventorySize" class="form-control"
										id="inventorySize_add_input" placeholder="库存数量"> 
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 输入库存区域的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">库存区域</label>
								<div class="col-xs-9">
									<input type="text" name="inventoryArea" class="form-control"
										id="inventoryArea_add_input" placeholder="库存区域"> 
									<span class="help-block"></span>
								</div>
							</div>
						</form>
						<div id="alertModalDiv" class="alert alert-warning alert-dismissible" role="alert" style="display: none;">
							<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						  	<strong>警告！没有查询到该商品！</strong> <br>
						  	<div style="padding-top: 10px;"><a href="${pageContext.request.contextPath}/views/product/productInformation.jsp" class="alert-link">————前往添加商品信息</a></div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" id="inventory_save_btn">保存</button>
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



	</div>




</body>

</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备相应布局 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>销售管理页面</title>
<% pageContext.setAttribute("APP_PATH", request.getContextPath()); %>
<!-- 引入jquery -->
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<!-- 引入bootstrap -->
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<!-- js自动补全 -->
<script src="${APP_PATH }/static/js/plumen.js"></script>
<script type="text/javascript">
	$(function() {
		
		/****************************************************************/
		/*******************调整顶部导航栏按钮的margin*********************/
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
		/************************ 显示商品销售情况*************************/
		/****************************************************************/
		//定义变量：总记录数和当前页码
		var totalRecord,currentPage;
		//在saleInfAnalysis.jsp页面，查询商品没有销售信息，需要添加
		//selectProductId只在增加销售信息的模态框里有用
		var selectProductId=window.location.href.split("=")[1];
		console.log("传来的productId="+selectProductId);
		//指定商品的销售信息
		var productId;
		
		//判断页面跳转来源  alertModalDiv  智能分析  alertModalDiv2 销售管理
		var ref = document.referrer; 
		if (document.referrer.length > 0) { 
			var targetUrl1="http://localhost:8080/views/analysis/saleInfAnalysis.jsp"
			var targetUrl2="http://localhost:8080/views/sales/salesStatistics.jsp";
			//console.log(targetUrl1.indexOf(ref));
			if(targetUrl1.indexOf(ref)!=-1){
				$("#alertModalDiv").css("display","block");
			}
			if(targetUrl2.indexOf(ref)!=-1){
				$("#alertModalDiv2").css("display","block");
			}
		} 
		
		
		//跳转页面函数	
		to_page(1);
		function to_page(pn){
			var pnAndId;
			if(productId==null){
				pnAndId="pn="+pn;//没有指定，展示所有商品的销售信息
			}else{
				pnAndId="pn="+pn+"&productId="+productId;//指定了商品
			}
			$.ajax({
				url:"${APP_PATH}/sales/getSelectProductSaleInf.do",
				data:pnAndId,
				type:"GET",
				success:function(result){
					console.log(result);
 					var sales = result.extend.pageInfo.list;
 					build_saleInf_table(sales);
 					build_page_info(result);
 					build_page_nav(result);
 					$("#check_all").prop("checked",false);//取消全选
				}
			});
		}
		
		
		//解析并显示商品信息函数
		function build_saleInf_table(result){
			//每次跳转页面都要先清空table表格
			$("#saleInf_table tbody").empty();
			//遍历inventorys,遍历的回调函数function
			$.each(result,function(index,item){
				var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");//多选框
				var salesIdTd = $("<td></td>").append(item.salesId);
				var productNameTd=$("<td></td>").append(item.product.productName);
				var salesSizeTd = $("<td></td>").append(item.salesSize);
				var salesPriceTd =$("<td></td>").append(item.salesPrice);
				
				//创建编辑按钮
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-xs edit_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
				//为编辑按钮添加一个自定义的属性来表示当前商品id
				editBtn.attr("edit-id",item.salesId);
				//创建删除按钮
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-xs delete_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
				//为删除按钮添加一个自定义的属性来表示当前删除的员工id
				delBtn.attr("del-id",item.salesId);
				//把两个按钮创建到一个单元格
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				
				//创建tr
				//append方法执行完成以后还是返回原来的元素，每次append返回tr再继续append
				$("<tr></tr>").append(checkBoxTd)
					.append(salesIdTd)
					.append(productNameTd)
					.append(salesSizeTd)
					.append(salesPriceTd)
					.append(btnTd)
					.appendTo("#saleInf_table tbody");

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
		
		/****************************************************************/
		/*************************新增商品销售情况*************************/
		/****************************************************************/
		
		$("#add_saleInf_button").click(function() {
			$("#alert1").hide();
			//清除表单数据（表单完整重置（表单的数据，表单的样式））
			reset_form("#saleInfAddModal form");
			//设置点击模态框周围空白区域不会关闭模态框
			$("#saleInfAddModal").modal({
				backdrop : "static"
			});
			displaySelect();
			
		});
		//清空表单样式及内容
		function reset_form(ele){
			$(ele)[0].reset();
			//清空表单样式
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}
		//动态展示下拉列表
		function displaySelect(){
			//输入框内容有变化就查数据
			//$("#saleInfName_add_input").on('input',function(){
			//点击查询按钮再查数据
			$("#nameSearchButton").bind("click",function(){
				var inputData=$("#saleInfName_add_input").val();
				console.log(inputData);
				//每次点击查找都要清除上次展示的数据
				$("#nameUl").empty();
				$.ajax({
					url:"${APP_PATH}/product/displayProductInSelect.do",
					data:{"inputData":inputData},
					type:"GET",
					success:function(result){
						console.log(result.extend.searchDatas);
						//输入的商品名称关键词找不到匹配的商品
						if(result.extend.searchDatas.length==0){
							console.log("null");
							//展示提示框
							$("#alert1").show();
							//不展示下拉列表
							$("#nameSearchButton").dropdown('toggle');
						}else{
							//生成下拉列表
							$.each(result.extend.searchDatas,function(index,item){ 
								var getLi=$("<li></li>").append($("<a></a>").attr("id",item.productId).attr("name","selectLLi").append(item.productName));
								$("#nameUl").append(getLi);
							});
							//选中li
							$("[name='selectLLi']").bind("click",function(){
								console.log("选中id"+this.id);
								console.log("选中值"+this.innerHTML);
								productId=this.id;
								$("#saleInfName_add_input").val(this.innerHTML);
							});
							
							
						}
					},
					error:function(result){alert("fail");}
				
				});
			});
		}
		//保存按钮，新增销售信息
		$("#saleInfAdd_save_btn").click(function(){
			var formStr=$("#saleInfAddForm").serialize();
            params = decodeURIComponent(formStr,true); //关键点
			//console.log("pId="+ productId+"&"+params);
            var productName=$("#saleInfName_add_input").val();
            //如果直接输入商品名称
            if(productId==null){
            	alert("查询商品是否存在！");
            	//查询商品是否存在
            	$.ajax({
            		url:"${APP_PATH}/product/getProductByName.do",
            		type:"GET",
            		data:"productName="+productName,
            		success:function(result){
            			console.log("查id="+result.extend.product.productId);
            			if(result.extend.product==null){
            				//没有当前商品
            				$("#alert1").show();
            			}else{
            				productId=result.extend.product.productId;
            				addSaleInf();
            			}
            		},
            		error:function(result){
     					alert("fail");
     				}
            	});
            }else{
            	addSaleInf();
            }
            

		});
		
		function addSaleInf() {
            console.log(productId);
			$.ajax({
				url:"${APP_PATH}/sales/addSaleInf.do",
				type:"POST",
				//contentType: "application/x-www-form-urlencoded",
				//data:"productId="+ $("#product_update_btn").attr("edit-id")+"&"+formStr,
				data:"pId="+ productId+"&"+params,
				success:function(result){
					console.log(result);
					//1、关闭模态框
					$("#saleInfAddModal").modal("hide");
					//2、回到该商品所在分页
					to_page(1);
				},
				error:function(result){
					alert("fail");
				}
			});
        }
		
			
		/****************************************************************/
		/*************************修改商品销售情况*************************/
		/****************************************************************/
		
		
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
	<!-- 传统的显示页面：浏览器发送页面请求，通过控制器解析数据，把数据封装给pageinfo对象，再返回给浏览器，在转发的页面中用el表达式调用这些数据 -->
	<!-- 现在的方法：利用ajax转发页面，解析数据，底下的表格显示信息、分页显示信息等代码都全部使用ajax展示-->
	<!-- 搭建显示界面 -->
	<!-- 导航 -->
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

	<div class="container" style="margin-bottom: 50px;margin-top: 65px">
		<!-- 页面 -->
		<div class="row ">
			<div style="text-align: center">
				<label  >销售情况</label>

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
					<table class="table" id="saleInf_table">					
						<thead>
							<tr>
								<!-- 表头th -->
								<th>
									<input type="checkbox" id="check_all"/>
								</th>
								<th>编号</th>
								<th>商品名称</th>
								<th>销售数量</th>
								<th>销售价格</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody>
<!-- 							<tr> -->
<!-- 								<td><input type='checkbox' class='check_item'/></td> -->
<!-- 								<td>5</td> -->
<!-- 								<td>方便面</td> -->
<!-- 								<td>20</td> -->
<!-- 								<td>12.5</td> -->
<!-- 								<td> -->
<!-- 									<button class="btn btn-primary btn-xs" id="edit_button"> -->
<!-- 										<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>编辑 -->
<!-- 									</button> -->
<!-- 									<button class="btn btn-danger btn-xs"> -->
<!-- 										<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除 -->
<!-- 									</button> -->
<!-- 								</td> -->
<!-- 							</tr> -->
<!-- 							<tr> -->
<!-- 								<td><input type='checkbox' class='check_item'/></td> -->
<!-- 								<td>5</td> -->
<!-- 								<td>方便面</td> -->
<!-- 								<td>30</td> -->
<!-- 								<td>11.5</td> -->
<!-- 								<td> -->
<!-- 									<button class="btn btn-primary btn-xs" id="edit_button"> -->
<!-- 										<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>编辑 -->
<!-- 									</button> -->
<!-- 									<button class="btn btn-danger btn-xs"> -->
<!-- 										<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除 -->
<!-- 									</button> -->
<!-- 								</td> -->
<!-- 							</tr> -->
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<!--按钮显示  -->
		<div class="col-xs-offset-5 " id="button2">
			<button class="btn btn-primary btn-sm" id="add_saleInf_button">
				<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>新增
			</button>
			<button class="btn btn-info btn-sm" id="add_discount_button">
				<span class="glyphicon glyphicon-ice-lolly-tasted" aria-hidden="true"></span>折扣
			</button>
			<button class="btn btn-danger btn-sm" id="delete_saleInf_button">
				<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除
			</button>
		</div>
		<!-- 分页显示 -->
		<div class="row">
			<div style="height:20px;"></div>
			<!--分页文字信息  -->
			<div class="col-xs-6" id="page_info_area" style="text-align:center;width:100%;clear:both;margin:0 auto;position:relative;display:block;"></div>
			<!-- 分页条信息 -->
			<div class="col-xs-12" id="page_nav_area" style="text-align:center;margin:0 auto;"></div>
		</div>
		<!-- 利用ajax显示 -->
		<div class="row">
			<div style="height:20px;"></div>
			<!--分页文字信息  -->
			<div class="col-xs-6" id="page_info_area" style="text-align:center;width:100%;clear:both;margin:0 auto;position:relative;display:block;"></div>
			<!-- 分页条信息 -->
			<div class="col-xs-12" id="page_nav_area" style="text-align:center;margin:0 auto;"></div>
		</div>
		<div id="alertModalDiv" class="alert alert-warning alert-dismissible" role="alert" style="display: none;">
			<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		  	<div style="padding-top: 10px;"><a href="${APP_PATH}/views/analysis/saleInfAnalysis.jsp" class="alert-link">
		  	<strong>如果完成此次操作，请点击这里！返回智能分析页面！</strong> </a>
		  	</div>
		</div>
		<div id="alertModalDiv2" class="alert alert-warning alert-dismissible" role="alert" style="display: none;">
			<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		  	<div style="padding-top: 10px;"><a href="${APP_PATH}/views/analysis/saleInfAnalysis.jsp" class="alert-link">
		  	<strong>如果完成此次操作，请点击这里！返回销售管理页面</strong> </a>
		  	</div>
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
		
		<!-- 新增销售商品的模态框 -->
		<div class="modal fade" id="saleInfAddModal" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">添加商品销售信息</h4>
					</div>
					<div class="modal-body">
						<form class="form-horizontal" id="saleInfAddForm">
							<div class="form-group">
								<label class="col-xs-3 control-label">商品名称</label>
								<div class="col-xs-9">
								    <div class="input-group">
								      <input type="text" name="saleInfName" class="form-control"
										id="saleInfName_add_input" placeholder="商品名称"> 
								      <div class="input-group-btn">
								        <button id="nameSearchButton"type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">查找 <span class="caret"></span></button>
								        <ul class="dropdown-menu dropdown-menu-right" id="nameUl">
<!-- 								          <li><a href="#">纯牛奶</a></li> -->
<!-- 								          <li><a href="#">Another action</a></li> -->
<!-- 								          <li><a href="#">Something else hereSomething else hereSomething else here</a></li> -->
<!-- 								          <li role="separator" class="divider"></li> -->
<!-- 								          <li><a href="#">Separated link</a></li> -->
								        </ul>
								      </div><!-- /btn-group -->
								    </div><!-- /input-group -->
								  </div><!-- /.col-xs-6 -->
							</div><!-- /form-group -->
							<div class="form-group">
								<label class="col-xs-3 control-label">销售数量</label>
								<div class="col-xs-9">
									<input type="text" name="salesSize" class="form-control"
										id="saleInfSize_add_input" placeholder="商品数量"> 
									<span class="help-block"></span>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-3 control-label">销售价格</label>
								<div class="col-xs-9">
									<input type="text" name="salesPrice" class="form-control"
										id="saleInfPrice_add_input" placeholder="商品售价"> 
									<span class="help-block"></span>
								</div>
							</div>
							<div id="alert1"class="alert alert-warning" style="display:none">
							    <a href="#" class="close" data-dismiss="alert">
							        &times;
							    </a>
							    <strong>警告！</strong>查询的商品不存在！
							    <a href="${APP_PATH}/views/product/productInformation.jsp"> 点击这里前往添加商品</a>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" id="saleInfAdd_save_btn">保存</button>
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 添加折扣信息的模态框 -->
		<div class="modal fade" id="zhekouModal" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">添加商品折扣信息</h4>
					</div>
					<div class="modal-body">
						<!-- 使用水平排列的表单 -->
						<form class="form-horizontal" id="changeInventoryAddForm">
			<div class="form-group">
			<label class="col-xs-3 control-label" style="text-align:right">折扣类型</label>
			<div class="col-xs-9">
                <div class="input-group">
                    <input type="text" class="form-control" placeholder="折扣类型">
                    <div class="input-group-btn">
                        <button type="button" class="btn btn-default 
                        dropdown-toggle" data-toggle="dropdown">折扣
                            <span class="caret"></span>
                        </button>
                        <ul class="dropdown-menu pull-right">
                            <li>
                                <a href="#">功能</a>
                            </li>
                            <li>
                                <a href="#">另一个功能</a>
                            </li>
                            <li>
                                <a href="#">其他</a>
                            </li>
                            <li class="divider"></li>
                            <li>
                                <a href="#">分离的链接</a>
                            </li>
                        </ul>
                    </div><!-- /btn-group -->
                </div><!-- /input-group -->
            </div><!-- /.col-lg-6 -->
            </div>
            <!-- 输入库存变动价格的div -->
				<div class="form-group">
					<label class="col-xs-3 control-label" style="text-align:right">折扣价格</label>
					<div class="col-xs-9">
						<input type="text" name="inboundCost" class="form-control"
							id="changeinboundCost_add_input" placeholder="折扣价格"> 
						<span class="help-block"></span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-xs-3 control-label" style="text-align:right">折扣商品名称</label>
					<div class="col-xs-9">
						<input type="text" name="inboundCost" class="form-control"
							id="changeinboundCost_add_input" placeholder="折扣商品名称"> 
						<span class="help-block"></span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-xs-3 control-label" style="text-align:right">折扣商品数量</label>
					<div class="col-xs-9">
						<input type="text" name="inboundCost" class="form-control"
							id="changeinboundCost_add_input" placeholder="折扣商品数量"> 
						<span class="help-block"></span>
					</div>
				</div>
            		
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" id="changeInventory_save_btn">保存</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
				</div>
			</div>
		</div>

	</div>
	
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
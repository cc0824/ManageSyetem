<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备相应布局 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>权限管理页面</title>
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
<link
	href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap-select.min.css"
	rel="stylesheet">	
<script
	src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<script
	src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap-select.js"></script>
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
				url:"${APP_PATH}/role/getAllRoleWithMenu.do",
				data:"pn="+pn,//pn=指定的pn
				type:"GET",
				success:function(result){
					//0.控制台测试f12-双击响应路径-network-response
					console.log(result);
					console.log("123");
					//1、解析并显示权限信息
					build_roleWithMenu_table(result);
					//2、解析并显示分页信息
					build_page_info(result);
					//3、解析显示分页条数据
					build_page_nav(result);
					$("#check_all").prop("checked",false);
				}
			});
		}
		//解析并显示商品信息函数
		function build_roleWithMenu_table(result){
			//每次跳转页面都要先清空table表格
			$("#roleWithMenu_table tbody").empty();
			var roleWithMenus = result.extend.pageInfo.list;
			console.log(roleWithMenus);
			$.each(roleWithMenus,function(index,item){
				//创建td,如果没有就自动创建出来，append为每个元素结尾添加内容
				var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
				var roleIdTd = $("<td></td>").append(item.roleId);
				var roleNameTd = $("<td></td>").append(item.roleName);
				if(item.menuList.length==0){
					var hasMenuTd=$("<td></td>").append("无"); 
				}else{
					var hasMenuTd=$("<td></td>").append("有");
				}
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-xs edit_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
				editBtn.attr("edit-id",item.roleId);
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-xs delete_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
				delBtn.attr("del-id",item.roleId);
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				
				//创建tr
				$("<tr></tr>").append(checkBoxTd)
					.append(roleIdTd)
					.append(roleNameTd)
					.append(hasMenuTd)
					.append(btnTd)
					.appendTo("#roleWithMenu_table tbody");

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
			var ul = $("<ul></ul>").addClass("pagination").attr("margin-left","50px");			
			//构建首页、前一页、后一页、末页
			var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr({href:"#"}));
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
					to_page(result.page.pageNum -1);
				});
			}
			//是否有下一页
			if(result.extend.pageInfo.hasNextPage == false){
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
		
		/***********************************/
		/************修改角色信息**************/
		/***********************************/
		//1、为编辑按钮绑定事件
		//这样绑定不上的原因：编辑按钮是ajax生成的，而这种绑定是页面dom一加载完就绑定了，这时按钮还没生成
		/*$("#edit_button").click(function() {
			alert("ok");
		})*/		
		//两种解决办法：1）、可以在创建按钮的时候绑定。    2）、绑定点击.live()，但是jquery新版没有live，使用on进行替代
		$(document).on("click",".edit_btn",function(){
			console.log("edit");
			//1.清除缓存
			$(".selectpicker").empty();
			//2、查出角色信息
			getSelectMenu($(this).attr("edit-id"));			
			//3、把角色的id传递给模态框的更新按钮
			$("#menu_update_btn").attr("edit-id",$(this).attr("edit-id"));
			$("#menuUpdateModal").modal({
				//backdrop:"static"
			});
		});
		
		
		function getSelectMenu(id){
			$.ajax({
				url:"${APP_PATH}/menu/getAllMenu.do",
				type:"GET",
				success:function(result){
					console.log(result);
					//拿到返回的数据
					var menuNames=result.extend.allMenus;
					var selectTemp=$("<select></select>").addClass("selectpicker").attr({ "data-live-search":"true"});
					$.each(menuNames,function(index,item){
						$("#selector").append("<option value='"+menuNames[index].menuId+"'>"+menuNames[index].menuName+"</option>");
					
					});
					//使用refresh方法更新UI以匹配新状态。
			        $('#selector').selectpicker('refresh');
			        //render方法强制重新渲染引导程序 - 选择ui。
			        $('#selector').selectpicker('render');
			        
			        //将上面的框中显示当前角色名称
			        
			        //将下拉菜单中当前用户的角色选中
					
				}
			});
		}
		
		/***********************************/
		/************删除角色信息**************/
		/***********************************/
		//单个删除
		$(document).on("click",".delete_btn",function(){
			//1、弹出确认删除对话框
			//eq()指定index值的元素，index从0开始，td:eq(2)表示第三个td
			//alert($(this).parents("tr").find("td:eq(2)").text());
			var roleId=$(this).attr("del-id");
			var roleName = $(this).parents("tr").find("td:eq(2)").text();
			console.log(roleId);
			confirmDelete(roleId,roleName);
			
		});		
		function confirmDelete(roleId,roleName){
			console.log(roleId);
			if(confirm("确认删除【"+roleName+"】吗？")){
				$.ajax({
					url: "${APP_PATH}/role/deleteRole.do",
					type:"post",
					data:{roleId:roleId,_method:"DELETE"},
					success:function(result){
						console.log(result);
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
		<!-- 权限信息展示 -->
		<!-- 响应式表格 -->
		<div class="row">
			<div class="col-xs-12">
				<div class="table-responsive">
					<table class="table" id="roleWithMenu_table">					
						<thead>
							<tr>
								<!-- 表头th -->
								<th>
									<input type="checkbox" id="check_all"/>
								</th>
								<th>编号</th>
								<th>角色名称</th>
								<th>有无权限</th>
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
			<button class="btn btn-primary btn-sm" id="add_menu_button">
				<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>新增
			</button>
			<button class="btn btn-danger btn-sm" id="delete_menu_button">
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



		<!-- 权限修改的模态框 -->
		<div class="modal fade" id="menuUpdateModal" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">修改权限信息</h4>
					</div>
					<div class="modal-body">
						<!-- 使用水平排列的表单 -->
						<form class="form-horizontal" id="menuUpdateForm" >
							
							<!-- 修改商品价格的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">角色种类</label>
								<div class="col-xs-9" id="selectpickerDiv">
<!-- 									<select class="selectpicker" multiple data-live-search="true"> -->
<!-- 									    <option value="1">广东省</option> -->
<!-- 									    <option value="2">广西省</option> -->
<!-- 									    <option value="3">福建省</option> -->
<!-- 									    <option value="4">湖南省</option> -->
<!-- 									    <option value="5">山东省</option>                             -->
<!-- 									</select> -->
									<select class="selectpicker " multiple data-live-search="true" id="selector" name="selector">
							        	<option></option>
							        </select>
								</div>
							</div>
							
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" id="menu_update_btn">修改</button>
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
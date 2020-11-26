<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 移动设备相应布局 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>门店管理页面</title>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!-- web路径：
不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306)；需要加上项目名
		http://localhost:3306/crud
 -->
<!-- jquery -->
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<!-- bootstrap -->
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<!-- echarts -->
<script src="${APP_PATH }/static/js/echarts.min.js"></script>
<script type="text/javascript" src="${APP_PATH }/static/js/map/china.js"></script>
<script type="text/javascript">
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
		
		//判断是否搜索过
		var searchDataFlag=false;
		/**********************************显示*******************************/
		//页面一加载就发送请求
		$.ajax({
			url:"${APP_PATH }/storeInfo/getAllStoreInfo.do",
			type:"GET",
			data:{},
			success:function(result){
				alert("ok");
				console.log(result);
				var storeInfo = result.extend.storeInfoList;
				build_storeInfo_table(storeInfo);
			},
			error:function(){
				alert("fail");
			}
		});
		
		//构建展示门店信息列表
		function build_storeInfo_table(result){
			
			$.each(result,function(index,item){
				//创建td,如果没有就自动创建出来，append为每个元素结尾添加内容
				var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
				var storeNumTd = $("<td></td>").append(item.storeNum);
				var storeNameTd= $("<td></td>").append(item.storeName);
				var storeAddressTd= $("<td></td>").append(item.storeAddress);
				var storeInfoBtn=$("<button></button>").addClass("btn btn-primary btn-xs edit_btn")
					.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("详情");
				storeInfoBtn.attr("edit-id",item.id);
				var storeInfoBtnTd=$("<td></td>").append(storeInfoBtn);
				$("<tr></tr>").append(checkBoxTd)
					.append(storeNumTd)
					.append(storeNameTd)
					.append(storeAddressTd)
					.append(storeInfoBtnTd)
					.appendTo("#storeInfo_table tbody");

			});
		}
		
		//点击按钮显示门店详情
		$(document).on("click",".edit_btn",function(){
			//清除上次查询到的信息
			$("#empUl").empty();
			//展示门店信息
			getStoreInfoById($(this).attr("edit-id"));
			//展示员工信息
			getEmpByStoreId($(this).attr("edit-id"));
			
			//弹出模态框
			$("#storeInfoModal").modal({
				backdrop:"static"
			});
			//将当前id赋给更新员工信息按钮
			$("#storeInfo_update_btn").attr("edit-id",$(this).attr("edit-id"));
		});
		
		//展示门店信息
		function getStoreInfoById(id){
		
			$.ajax({
				url:"${APP_PATH}/storeInfo/getStoreInfoById.do",
				data:"id="+id,
				type:"GET",
				success:function(result){
					console.log("门店信息ok");
					console.log(result);
					var storeInfo2=result.extend.storeInfo;
					$("#storeNumLabel").html(storeInfo2.storeNum);
					$("#storeNameLabel").html(storeInfo2.storeName);
					$("#storeAddressLabel").html(storeInfo2.storeAddress);
					$("#storePostCodeLabel").html(storeInfo2.storePostCode);
					
				}
			});
		}
		
		//展示员工信息
		function getEmpByStoreId(id){
			//debugger;
			$.ajax({
				url:"${APP_PATH}/storeInfo/getEmpByStoreId.do",
				type:"GET",
				data:"id="+id,
				success:function(result){
					console.log("员工ok");
					console.log(result);
					//debugger;
					var empInfo=result.extend.userList;
					var lis=empInfo.length;//li个数
					$.each(empInfo,function(index,item){
						var empId=item.userId;
						var userNameliChild=$("<li></li>").append("用户名:").append(item.userName).attr("id","userli");
						console.log("员工id");
						console.log(empId);
						userNameliChild.appendTo("#empUl");
						getEmpWithRole(empId,userNameliChild);
					})
					
					
				},
				error:function(result){
					alert("员工fail");
				}
			
			})
		}
		//修改li样式，选择前面的用lt，后面的用gt
		//$("#empUl li:gt(2)").css({"background-color":"red"});
		//展示员工信息的同时把角色查询到
		function getEmpWithRole(id,userNameliChild){
			//debugger;
			$.ajax({
				url:"${APP_PATH}/user/getUserWithRole.do",
				type:"GET",
				data:"id="+id,
				success:function(result){
					console.log("角色ok");
					console.log(result);
					var roleNameliChild=$("<li></li>").append("角色名称：").append(result.roleName).attr("id","roleli");
					roleNameliChild.appendTo("#empUl");
				},
				error:function(result){
					alert("员工fail");
				}
			
			});
		}
		
		
		/**********************************搜索*******************************/
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
				url : "${APP_PATH}/storeInfo/getDataBySearch.do",
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
					$("#storeInfo_table tbody").empty();
					build_storeInfo_table(data);
					
					

				},
				error:function(result){
					alert("fail");
				}

			});
		});
		
		/**********************************新增*******************************/
		//新增门店信息
		$(document).on("click","#add_store_button",function(){
			//清除表单数据（表单完整重置（表单的数据，表单的样式））
			//reset_form("#storeInfoAddModal form");
			//展示门店信息
			//getStoreInfoById($(this).attr("edit-id"));
			//展示员工信息
			//getEmpByStoreId($(this).attr("edit-id"));
			
			//弹出模态框
			$("#storeInfoAddModal").modal({
				backdrop:"static"
			});
			//将当前id赋给更新员工信息按钮
			//$("#storeInfo_update_btn").attr("edit-id",$(this).attr("edit-id"));
		});
		function reset_form(ele){
			$(ele)[0].reset();
			//清空表单样式
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}
		
		//点击模态框保存按钮，将数据保存至数据库，并显示在页面上
		$("#addStoreInfoBtn").click(function() {
			//1、模态框中填写的表单数据提交给服务器进行保存，在controller定义保存方法

			//2、数据校验

			//3、发送ajax请求保存信息
			//测试能否取到模态框中form信息
			alert($("#storeInfoAddForm").serialize());
			$.ajax({
				url : "${APP_PATH}/storeInfo/addNewStoreInfo.do",
				type : "POST",
				data : $("#storeInfoAddForm").serialize(),
				success : function(result) {
					//测试
					alert(result.msg);
					//信息保存成功
					//1、关闭模态框
					$("#storeInfoAddModal").modal('hide');
					//2、来到最后一页显示新增的信息，保证totalRecord大于总页码
					to_page(totalRecord);

				},
				error:function(result){
					alert("fail");
				}

			});

		})
		
		
		
		
		/**********************************删除*******************************/
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
		$("#delete_storeInfo_button").click(function(){
			//定义空字符串
			var storeInfoNames = "";
			var storeInfoIds = "";
			//$(".check_item:checked")找到被选中的商品
			$.each($(".check_item:checked"),function(){
				//this表示被选中的元素
				//alert($(this).parents("tr").find("td:eq(2)").text());
				storeInfoNames += $(this).parents("tr").find("td:eq(2)").text()+",";
				//alert($(this).parents("tr").find("td:eq(1)").text());
				storeInfoIds += $(this).parents("tr").find("td:eq(1)").text()+"-";
			});
			//去除productNames多余的,substring截取字符串长度
			storeInfoNames = storeInfoNames.substring(0, storeInfoNames.length-1);
			//alert(storeInfoNames);
			//去除del_idstr多余的-
			storeInfoIds = storeInfoIds.substring(0, storeInfoIds.length-1);
			//alert(storeInfoIds);
			if(confirm("确认删除【"+storeInfoNames+"】吗？")){
				//发送ajax请求删除
				$.ajax({
					url:"${APP_PATH}/storeInfo/deleteStoreInfoBatch.do",
					type:"post",
					data:{storeInfoIds:storeInfoIds,_method:"DELETE"},
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
	/* 选择前一半的li*/
	#empUl li:lt(lis) {
		float:left;
	}
	/* 选择后一半的li*/
 	#empUl li:gt(lis){
 		margin-left:50px;
 		list-style-type:none;
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
	<nav class="navbar navbar-default navbar-fixed-top" >
	<div class="container-fluid" >
		<div class="navbar-header" style="text-align:center;">
			<button type="button" class="btn btn-default btn-lg" onclick="javascript:history.back(-1)" id="topNavbarLeftButton">
        		<span class="glyphicon glyphicon-arrow-left"></span>
    		</button>
			<a  href="#"  style="font-size:18px;font-color:rgb(51,122,183)">门店管理</a>
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
		<div class="row " >
			<div style="text-align: center;">
				<label  >门店信息</label>
				<button type="button" class="btn btn-info btn-sm col-xs-offset-7" id="searchButton">
					<span class="glyphicon glyphicon-search" aria-hidden="true"></span> 搜索
				</button>
			</div>
		</div>
		<div><label></label></div>
		<!-- 门店信息展示 -->
		<!-- 响应式表格 -->
		<div class="row">
			<div class="col-xs-12">
				<div class="table-responsive">
					<table class="table" id="storeInfo_table">					
						<thead>
							<tr>
								<!-- 表头th -->
								<th>
									<input type="checkbox" id="check_all"/>
								</th>
								<th>门店编号</th>
								<th>门店名称</th>
								<th>门店地址</th>
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
			<button class="btn btn-primary btn-sm" id="add_store_button">
				<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>新增
			</button>
			<button class="btn btn-danger btn-sm" id="delete_storeInfo_button">
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
		
		<!-- 门店地图 -->
		<div class="alert alert-info">
			<button type="button" class="close" data-dismiss="alert"
                    aria-hidden="true">
                &times;
            </button>
			<a href="${pageContext.request.contextPath }/views/storeInfo/storeMapManagement.jsp"><u>点击查看分布地图！</u></a>
		</div>
		<!-- 展示门店详细信息模态框 -->
		<div class="modal fade" id="storeInfoModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <h4 class="modal-title" id="myModalLabel">门店详情</h4>
	            </div>
	            <div class="modal-body">
	            	<label>门店编号:</label><label id="storeNumLabel"></label></br>
	            	<label>门店名称:</label><label id="storeNameLabel"></label></br>
	            	<label>门店地址:</label><label id="storeAddressLabel"></label></br>
	            	<label>门店邮编:</label><label id="storePostCodeLabel"></label></br>
	            	<label>员工列表:</label>
		            	<ul id="empUl">
		            	
		            	</ul></br>
		            
	
				</div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	                <button type="button" class="btn btn-primary" id="updateStoreInfoBtn">提交更改</button>
	            </div>
	        </div><!-- /.modal-content -->
	    </div><!-- /.modal -->
		</div>
		
		
		<!-- 新增门店详细信息模态框 -->
		<div class="modal fade" id="storeInfoAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <h4 class="modal-title" id="myModalLabel">新增门店</h4>
	            </div>
	            <div class="modal-body">
	            	<form class="form-horizontal"  id="storeInfoAddForm">
	            		<div class="form-group">
						    <label for="storeNum_input" class="col-xs-4 control-label">门店编号</label>
						    <div class="col-xs-8">
						      <input type="text" class="form-control" id="storeNum_input" 
						      	name="storeNum" placeholder="请输入">
						    </div>
						</div>
					
						<div class="form-group">
						    <label for="storeName_input" class="col-xs-4 control-label">门店名称</label>
						    <div class="col-xs-8">
						      <input type="text" class="form-control" id="storeName_input" 
						      	name="storeName" placeholder="请输入">
						    </div>
						</div>
					    <div class="form-group">
					        <label for="storeAddress_input" class="col-xs-4 control-label">门店地址</label>
					        <div class="col-xs-8">
					          <input type="text" class="form-control" id="storeAddress_input" 
					          	name="storeAddress" placeholder="请输入">
					        </div>
					    </div>
					    <div class="form-group">
					        <label for="storePostCode_input" class="col-xs-4 control-label">门店邮编</label>
					        <div class="col-xs-8">
					          <input type="text" class="form-control" id="storePostCode_input" 
					          	name="storePostCode" placeholder="请输入">
					        </div>
					    </div>
					    
					  
					</form>
				</div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	                <button type="button" class="btn btn-primary" id="addStoreInfoBtn">提交更改</button>
	            </div>
	        </div><!-- /.modal-content -->
	    </div><!-- /.modal -->
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
		
		
	</div><!-- <div class="container"> -->

	


	
	
	

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
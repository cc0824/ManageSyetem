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
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<!-- 引入样式Bootstrap -->
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<!-- 引入日期插件 -->
<script src="${APP_PATH }/static/laydate/laydate.js"></script>
<!-- 侧边导航 -->
<script src="${APP_PATH }/static/assets/js/jquery.mCustomScrollbar.concat.min.js"></script>
<script src="${APP_PATH }/static/assets/js/custom.js"></script>


<script type="text/javascript">
	function logout() {
		if (confirm("确定要退出登陆吗？")) {
			sessionStorage.clear();
			window.location.href = "${pageContext.request.contextPath}/login.jsp";
		}
	}
	
	$(function() {
		
		/***********************************/
		/**********分页信息使用json显示**********/
		/***********************************/
		
		//定义变量：总记录数和当前页码
		var totalRecord,currentPage,data;
		
		//页面加载完成以后，直接去发送ajax请求,要到分页数据
		//跳转到首页
		to_page(1);
		//跳转页面函数		
		function to_page(pn){
			$.ajax({
				url:"${APP_PATH}/message/getAllInboundMessage.do.do",
				data:"pn="+pn,//pn=指定的pn
				type:"GET",
				success:function(result){
					//0.控制台测试f12-双击响应路径-network-response
					console.log(result);
					data=result;
					//1、解析并显示历史记录信息
					build_message_table(result);
					//2、解析并显示分页信息
					build_page_info(result);
					//3、解析显示分页条数据
					build_page_nav(result);
					$("#check_all").prop("checked",false);
				}
			});
		}
		//解析并显示商品信息函数
		function build_message_table(result){
			//每次跳转页面都要先清空table表格
			$("#message_table tbody").empty();
			var messages = result.extend.pageInfo.list;
			//遍历products,遍历的回掉函数function
			$.each(messages,function(index,item){
				//创建td,如果没有就自动创建出来，append为每个元素结尾添加内容
				var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
				var messageIdTd = $("<td></td>").append(item.id);
				var messageFromUserTd = $("<td></td>").append(item.messageFromUser);
				var messageToUserTd =$("<td></td>").append(item.messageToUser);
				var messageTimeTd = $("<td></td>").append(item.messageTime);
				
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-xs edit_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
				//为编辑按钮添加一个自定义的属性来表示当前商品id
				editBtn.attr("edit-id",item.id);
				//创建删除按钮
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-xs delete_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
				//为删除按钮添加一个自定义的属性来表示当前删除的员工id
				delBtn.attr("del-id",item.id);
				//把两个按钮创建到一个单元格
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				
				//创建tr
				//append方法执行完成以后还是返回原来的元素，每次append返回tr再继续append
				$("<tr></tr>").append(checkBoxTd)
					.append(messageIdTd)
					.append(messageFromUserTd)
					.append(messageToUserTd)
					.append(messageTimeTd)
					.appendTo("#message_table tbody");

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
		
		/***********************************/
		/*************筛选记录****************/
		/***********************************/
		$("#message_select_btn").click(function(){
			var fromUser=$("#fromUser").val();
			var toUser=$("#toUser").val();
			$.ajax({
				url:"${APP_PATH}/message/getAllMessageByCondition.do",
				type:"GET",
				//data:{"fromUser":fromUser,"toUser":toUser,"startTime":startTime,"endTime":endTime},
				data:fromUser,
				success:function(result){
					alert("ok");
				},
				error:function(){
					alert("fail");
				
				}
				
			})
		
		});
		
		
		
		
		
		
		/***********************************/
		/*************查看详情****************/
		/***********************************/
		$("#detail_message_button").click(function(){
		
			//如果多选，则提示只能选择一个
			if($(".check_item:checked").length>1){
				//show弹出框
				$('.popover-hide').popover('show');
			}else{
				//hide弹出框
				$('.popover-hide').popover('destroy');
				var messageId = $(".check_item:checked").parents("tr").find("td:eq(1)").text();
				console.log(messageId);
				window.location.href="${APP_PATH}/message/getSelectMessageDetail.do?meId=messageId"
// 				$.ajax({
// 					url:"${APP_PATH}/message/getSelectMessageDetail.do",
// 					type:"GET",
// 					data:{messageId:messageId},
// 					success:function(result){
// 						alert("ok");
// 						console.log(result.msg);
// 						//回到当前页面
// 						to_page(currentPage);
// 					}
// 				});
				
			}
				
			
			
			
		});
		
		
		
		
		
		
		/***********************************/
		/*************删除记录****************/
		/***********************************/
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
		$("#delete_message_button").click(function(){
			//定义空字符串
			var messageIds = "";
			//$(".check_item:checked")找到被选中的商品
			$.each($(".check_item:checked"),function(){
				//this表示被选中的元素
				//alert($(this).parents("tr").find("td:eq(1)").text());
				messageIds += $(this).parents("tr").find("td:eq(1)").text()+"-";
			});
			//去除del_idstr多余的-
			messageIds = messageIds.substring(0, messageIds.length-1);
			//alert(messageIds);
			if(confirm("确认删除【"+messageIds+"】吗？")){
				//发送ajax请求删除
				$.ajax({
					url:"${APP_PATH}/message/deleteSelectMessage.do",
					type:"post",
					data:{messageIds:messageIds,_method:"DELETE"},
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

.demo-input{padding-left: 10px; height: 38px; min-width: 262px; line-height: 38px; border: 1px solid #e6e6e6;  background-color: #fff;  border-radius: 2px;}
</style>
</head>
<body>
	<!-- 搭建系统主页 -->
	<!-- 顶部导航 -->
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
	<div id="inputForm">
		<form class="form-horizontal" id="selectMessageForm">
			<div class="form-group">
				<label for="inputFromUser" class="col-xs-4 control-label" style="text-align: right">申请人名称</label>
				<div class="col-xs-5">
					<input type="text" class="form-control" name="inputFromUser" id="fromUser"
						placeholder="申请人">
				</div>
			</div>
			<div class="form-group">
				<label for="inputToUser" class="col-xs-4 control-label" style="text-align: right">审批人名称</label>
				<div class="col-xs-5">
					<input type="text" class="form-control" name="inputToUser" id="toUser"
						placeholder="审批人"></input>
				</div>
			</div>
			<div class="form-group">
				<label for="startTime" class="col-xs-4 control-label" style="text-align: right">开始时间</label>
				<div class="col-xs-5">
					<input type="text" class="form-control" 
						class="demo-input" placeholder="请选择日期" id="test1" name="startTime"></input>
				</div>
			</div>
			<div class="form-group">
				<label for="endTime" class="col-xs-4 control-label" style="text-align: right">结束时间</label>
				<div class="col-xs-5">
					<input type="text" class="form-control" 
						class="demo-input" placeholder="请选择日期" id="test2" name="endTime"></input>
				</div>
			</div>
		
			
			<div class="form-group">
				<div class="col-xs-offset-8 ">
					<button class="btn btn-success" id="message_select_btn">筛选</button>
				</div>
			</div>
		</form>
	</div>
	

        
        
 
	<div class="container">
		<!-- 页面 -->
		<div class="row ">
			<div style="text-align: center">
				<label  >历史记录</label>
			</div>
		</div>
		<div><label></label></div>
		<!-- 商品信息展示 -->
		<!-- 响应式表格 -->
		<div class="row">
			<div class="col-xs-12">
				<div class="table-responsive">
					<table class="table" id="message_table">					
						<thead>
							<tr>
								<!-- 表头th -->
								<th>
									<input type="checkbox" id="check_all"/>
								</th>
								<th>编号</th>
								<th>申请人</th>
								<th>审批人</th>
								<th>时间</th>
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
			<button type="button" class="btn btn-primary btn-sm popover-hide" id="detail_message_button" title="提示"
	            data-container="body" data-toggle="popover" data-placement="bottom"
	            data-content="请勿选择多条记录查看详细信息 ">
	       		<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>详情
	    	</button>
			<button class="btn btn-danger btn-sm" id="delete_message_button">
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
	</div>
	
	
	

<!-- 
div style="text-align: center;display: inline;margin:0 auto" 
button style="width: 90px;text-align: center;margin-left:auto;margin-right:auto; 
	background:transparent;border: none;position:fixed;"
-->
		
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
 				<a href="#">消息 <span class="badge" id="messageNum">2</span></a> 
			</button>
		</div> 
	</div>
    </div>
    </nav>




</body>
</html>
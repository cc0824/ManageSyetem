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
<%pageContext.setAttribute("APP_PATH", request.getContextPath());%>

<!-- 引入jquery -->
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<!-- 引入bootstrap -->
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<!-- 引入fontawesome字体图标 -->
<link rel="stylesheet" href="${APP_PATH }/static/font-awesome-4.7.0/css/font-awesome.min.css" >
<!-- 引入侧边导航插件 -->
<link rel="stylesheet" type="text/css" href="${APP_PATH }/static/css/demo.css">
<link rel="stylesheet" href="${APP_PATH }/static/assets/css/jquery.mCustomScrollbar.min.css" />
<link rel="stylesheet" href="${APP_PATH }/static/assets/css/custom.css">
<script src="${APP_PATH }/static/assets/js/jquery.mCustomScrollbar.concat.min.js"></script>
<script src="${APP_PATH }/static/assets/js/custom.js"></script>
<!-- 引入echarts -->
<script src="${APP_PATH }/static/js/echarts.min.js"></script>

<script type="text/javascript">
	function logout() {
		if (confirm("确定要退出登陆吗？")) {
			sessionStorage.clear();
			window.location.href = "${pageContext.request.contextPath}/login.jsp";
		}
	}
	$(function(){
		/****************************************************************/
		/********************** 1.ajax轮询查询消息通知 **********************/
		/****************************************************************/
		//读取session中username、userpwd
		var userSession="<%=session.getAttribute("user")%>"; 
		var roleSession="<%=session.getAttribute("role")%>"; 
		var myname,mypwd,myrole;
		if(userSession!="null"){
			strs = userSession.split(",");
			strs2 = roleSession.split(",");
			mynames=strs[0].split(":");
			myname=mynames[1];
			mypwds=strs[1].split(":");
			mypwd=mypwds[1];
			myroles=strs2[0].split("=");
			myrole=myroles[1].substr(0,myroles[1].length-1);
			console.log(myname);
			console.log(mypwd);
			console.log(myrole);
		}
		else{
			window.location.href="${pageContext.request.contextPath}/login.jsp";
		}
		
		
		//轮询
		setInterval(function(){
			getMessage();
		},50000);
		
		var myMessageList;
		function getMessage(){
			$.ajax({
				url:"${APP_PATH}/message/getMessageByUserName.do",
				type:"GET",
				data:{"myname":myname},
				success:function(result){
					myMessageList=result.extend.myMessage;
					console.log(result.extend.myMessage);
					if(myMessageList.length>0){
						//修改右下角消息标签
						$("#messageNum").html(myMessageList.length);
// 						$.each(myMessageList,function(index,item){
							
							
// 						});
					}
// 						var id=item.id;
// 						var type=item.messageType;//消息种类
// 						var readstate=item.messageState;
// 						var displaystate=item.messageStateDisplay;
// 						console.log(id);
// 						if(type==1){
// 							inboundWarning();
// 							changeDisplayState(id);
// 						}else{
// 							outboundWarning();
// 							changeDisplayState(id);
// 						}
				},
				error:function(result){
					alert("fail");
				}
			});
		}
		//将展示的信息状态置为1
		function changeDisplayState(id){
			$.ajax({
				url:"${APP_PATH}/message/updateDisplayState.do",
				type:"GET",
				data:"id="+id,
				//dataType:"json",//不是json格式数据就不写
				success:function(result){
					//alert("ok");
					console.log("当前id："+id);
					
				},
				error:function(result){
					//alert("fail");
				}
			});
		}
		//点击消息按钮，弹出提示框
		$("#myMsgBtn").click(function(){
			$("#myMsg").empty();
			
			console.log("点击消息按钮...");
			console.log(myMessageList);
			if(myMessageList!=null){
				$.each(myMessageList,function(index,item){
					var tmp=item.messageContent+"申请--"+item.messageFromUser;
					console.log(tmp);
					var ahref=$("<a></a>").append(tmp);
					$("#myMsg").append($("<li></li>").append(ahref));
				
				});
			}
			else{
				$("#myMsg").append($("<li></li>").append($("<a></a>").append("暂无新消息...")));
			}
			$("#myMsg").append("<li class='divider'></li>");
			$("#myMsg").append("<li><a href='${APP_PATH}/views/message/checkMoreMessage.jsp'>查看更多</a></li>");
					
			$("#myMsgBtn").dropdown();
			
		});
		

		
		/****************************************************************/
		/***************************** 2.侧边菜单：  *************************/
		/****************************************************************/
		//显示用户和角色信息
		displayUserAndRole();
		//显示在线离线
		displayOnlineState();
		//依据角色展示系统菜单
		displayMenu();
		
		//显示用户和角色信息
		function displayUserAndRole(){
			$(".user-name").append(myname);
			$(".user-role").append(myrole);
		}
		//显示在线离线
		function displayOnlineState(){
			if(myname!=null){
				$(".user-status a").append($("<span></span>").addClass("label label-success").append("在线"));
			}else{
				$(".user-status a").append($("<span></span>").addClass("label label-danger").append("离线"));
				
			}
			
		}
		//显示菜单
		var menus="";
		function displayMenu(){
			$.ajax({
				url:"${APP_PATH}/menu/getMenu.do?parentId=1",
				type:"GET",
				//dataType:"json",//不是json格式数据就不写
				//data:{},//不往后台传参就不用写
				success:function(result){
					//生成菜单列表
					var menuData = result.extend.menuList;
					console.log(menuData);
					displayMenuTree(1,menuData);
					
				},
				error:function(result){
					alert("fail");
				}
			});
		}
		//获取下级菜单
		function getChildMenu(id, arry){
			var newArry = new Array();
            for (var i in arry) {
                if (arry[i].pId == id)
                    newArry.push(arry[i]);
            }
            return newArry;
		}
		//生成菜单列表
		function displayMenuTree(id, arry) {
            var childArry = getChildMenu(id, arry);//用户、库存、商品、门店——一级菜单
            $.each(childArry,function(index,item){
            	var childUrl="${APP_PATH }/views"+item.menuUrl;
            	//添加二级菜单的<a>
            	var childA=$("<a></a>").attr("href","#").append($("<i></i>").addClass(item.menuIcon).attr("aria-hidden","true"))
					.append($("<span></span>").append(item.menuName));
            	menus=$("<li></li>").addClass("sidebar-dropdown").append(childA);
            	//添加二菜单的<div>
            	//debugger;
            	displayMenuChildDiv(childA,item,arry);
            	$("#tree").append(menus);
            
            });
            
        }
		//添加二级菜单的<div>
		function displayMenuChildDiv(child,item1,arry){
			var childArry = getChildMenu(item1.menuId, arry);//3个 用户、角色、权限——二级菜单
			var childDiv=$("<div></div>").addClass("sidebar-submenu");
			//往<ul>后面添加<li>，要判断<li>是不是根节点
			$.each(childArry,function(index,item){//第一次遍历，查询用户管理下面的菜单
				var temp = getChildMenu(item.menuId, arry);
				if(temp.length==0){//角色、权限是根节点
					console.log("isRoot");
					displayMenuChildLi2(childDiv,item,arry);
					
				}else{//用户不是根节点
					console.log("isNotRoot");
					displayMenuChildLiWithDiv(childDiv,item,arry);
				}
			});
			menus.append(childDiv);
			
		}
		
		//二级菜单后面没有三级菜单
		function displayMenuChildLi2(child,item,arry){
			//添加<li>容器
			var childUrl="${APP_PATH }/views"+item.menuUrl;
			var childLi=$("<li></li>").append($("<a></a>").attr("href",childUrl).append(item.menuName));
				
			child.append($("<ul></ul>").css({"padding-top":"0px"}).append(childLi));
		}
		
		//二级菜单后面有三级菜单
		function displayMenuChildLiWithDiv(childDiv,item,arry){//查用户管理下面
			var childUrl="${APP_PATH }/views"+item.menuUrl;
			var childA=$("<a></a>").attr("href",childUrl).append(item.menuName);
			var childLi=$("<li></li>").addClass("sidebar-dropdown2");
			childLi.append(childA);
			//添加根菜单
			displayMenuChildLi3(childLi,item,arry)
			childDiv.append($("<ul></ul>").css({"padding-top":"0px"}).append(childLi));
		}
            
		//添加三级菜单
		function displayMenuChildLi3(child,item,arry){
			
			var childArry = getChildMenu(item.menuId, arry);
			var temp=$("<span></span>");
			
			$.each(childArry,function(index,item){
				var childUrl="${APP_PATH }/views"+item.menuUrl;
				var childLi=$("<li></li>").append($("<a></a>").attr("href",childUrl).append(item.menuName));
				temp.append(childLi);
				
			});
			child.append($("<div></div>").addClass("sidebar-submenu2").append($("<ul></ul>").css({"padding-top":"0px"}).append(temp)));
			
			
		}
		
		//为生成的菜单绑定单击事件   	
		$(document).on("click",".sidebar-dropdown > a",function(){
			$(".sidebar-submenu").slideUp(250);
           	if ($(this).parent().hasClass("active")){
				$(".sidebar-dropdown").removeClass("active");
				$(this).parent().removeClass("active");
           	}else{
           		$(".sidebar-dropdown").removeClass("active");
           		$(this).next(".sidebar-submenu").slideDown(250);
           	 	$(this).parent().addClass("active");
           	}

		});
        $(document).on("click",".sidebar-dropdown2 > a",function(){
   	        $(".sidebar-submenu2").slideUp(250);
           	if ($(this).parent().hasClass("active")){
    		         $(".sidebar-dropdown2").removeClass("active");
    		         $(this).parent().removeClass("active");
           	}else{
           		$(".sidebar-dropdown2").removeClass("active");
           		$(this).next(".sidebar-submenu2").slideDown(250);
           	 	$(this).parent().addClass("active");
           	}

        });
        
        
        //搜索功能
        $("#searchSpan").click(function(){
        	var searchData=$("#searchInput").val();
        	console.log(searchData);
        	if(searchData!=null&&searchData!=''){
        		$.ajax({
            		url:"${APP_PATH}/menu/getSearchMenu.do",
            		data:"searchData="+searchData,
            		type:"GET",
            		success:function(result){
            			alert("ok");
            			console.log(result);
            			
            			window.location.href="${APP_PATH}/views/searchResult.jsp"+"?searchData="+searchData;
            		},
            		error:function(result){
            			alert("fail");
            		}
            	});
        	}
        	
        });
          	
        
        
        /********************************************************************/
		/************************列表展示当前盘点单的盘点情况***********************/
		/********************************************************************/


		//定义变量：总记录数和当前页码
		var totalRecord,currentPage;
		
		//页面加载完成以后，直接去发送ajax请求,要到分页数据
		//跳转到首页
		to_page(1);
		//跳转页面函数		
		function to_page(pn){
			$.ajax({
				url:"${APP_PATH}/inventory/getCheckProduct.do",
				data:"pn="+pn+"&inventoryCheckId="+1,//pn=指定的pn
				type:"GET",
				success:function(result){
					console.log(result);
 					var checkItems = result.extend.pageInfo.list;
 					build_inventoryCheck_table(checkItems);
 					build_page_info(result);
 					build_page_nav(result);
 					$("#check_all").prop("checked",false);//取消全选
				}
			});
		}
		
		
		
		
		//解析并显示商品信息函数
		function build_inventoryCheck_table(result){
			//每次跳转页面都要先清空table表格
			$("#inventoryCheck_table tbody").empty();
			//在'A','B','C','D','E'中随机取值，暂时无用
		 	var arr = ['A','B','C','D','E'];
		    var	idvalue=arr[Math.floor(Math.random()*5)];
			 
			//遍历inventorys,遍历的回调函数function
			$.each(result,function(index,item){
				//debugger;
				var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");//多选框
				var inventoryCheckItemIdTd = $("<td></td>").append(item.inventoryCheckItemId);//库存盘点id
				var inventoryCheckProductNameTd = $("<td></td>").append(item.product.productName);//盘点商品名称
				var inventoryCheckProductExpectedSizeTd=$("<td></td>").append(item.inventoryCheckProductExpectedSize);//预期数量
				var inventoryCheckProductActualSizeTd = $("<td></td>").append(item.inventoryCheckProductActualSize);//实际数量
				var inventoryCheckStateTd =$("<td></td>").append("-");
				if(item.inventoryCheckState=="2"){
					inventoryCheckStateTd=$("<td></td>").append("盘亏");
				}
				else if(item.inventoryCheckState=='3'){
					inventoryCheckStateTd=$("<td></td>").append("盘盈");
				}
				
				//创建编辑按钮
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-xs edit_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
				//为编辑按钮添加一个自定义的属性来表示当前商品id
				editBtn.attr("edit-id",item.inventoryCheckItemId);
				//创建删除按钮
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-xs delete_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
				//为删除按钮添加一个自定义的属性来表示当前删除的员工id
				delBtn.attr("del-id",item.inventoryCheckItemId);
				//把两个按钮创建到一个单元格
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				
				//创建tr
				//append方法执行完成以后还是返回原来的元素，每次append返回tr再继续append
				$("<tr></tr>").append(checkBoxTd)
					.append(inventoryCheckItemIdTd)
					.append(inventoryCheckProductNameTd)
					.append(inventoryCheckProductExpectedSizeTd)
					.append(inventoryCheckProductActualSizeTd)
					.append(inventoryCheckStateTd)
					.append(btnTd)
					.appendTo("#inventoryCheck_table tbody");

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
		/************************当前盘点单新增商品盘点***********************/
		/********************************************************************/ 
		
		$("#add_inventoryCheck_button").click(function() {
			reset_form("#inventoryCheckAddForm");
			$("#inventoryCheckAddModal").modal({
				backdrop : "static"
			});
			//动态展示下拉列表
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
			//需要先输入关键词，再点击查询按钮再查数据
			$("#nameSearchButton").bind("click",function(){
				//debugger;
				var inputData=$("#inventoryCheckName_add_input").val();
				console.log(inputData);
				//每次点击查找都要清除上次展示的数据
				$("#nameUl").empty();
				$.ajax({
					url:"${APP_PATH}/product/displayProductInSelect.do",
					data:{"inputData":inputData},
					type:"GET",
					success:function(result){
						//console.log(result.extend.searchDatas);
						//输入的商品名称关键词找不到匹配的商品
						if(result.extend.searchDatas.length==0){
							//不展示下拉列表
							$("#nameUl").empty();
							$("#nameSearchButton").dropdown('toggle');
							//展示提示框
							$("#alert1").show();
						}else{
							$("#alert1").hide();
							$("#nameUl").empty();
							//生成下拉列表
							$.each(result.extend.searchDatas,function(index,item){ 
								var getLi=$("<li></li>").append($("<a></a>").attr("id",item.productId).attr("name","selectLLi").append(item.productName));
								$("#nameUl").append(getLi);
							});
							//选中li
							$("[name='selectLLi']").bind("click",function(){
								//console.log("选中id"+this.id);
								//console.log("选中值"+this.innerHTML);
								//productId=this.id;
								//productName=this.innerHTML;
								$("#inventoryCheckName_add_input").val(this.innerHTML);
							});
							
						}
					},
					error:function(result){alert("fail");}
				
				});
			});
		}
		//点击模态框保存按钮，将数据保存至数据库，并显示在页面上
		$("#inventoryCheck_save_btn").click(function() {
			alert($("#inventoryCheckAddForm").serialize());
// 			$.ajax({
// 				url : "${APP_PATH}/product/addNewProduct.do",
// 				type : "POST",
// 				data : $("#productAddForm").serialize(),
// 				success : function(result) {
// 					//测试
// 					//alert(result.msg);
// 					//信息保存成功
// 					//1、关闭模态框
// 					$("#productAddModal").modal('hide');
// 					//2、来到最后一页显示新增的信息，保证totalRecord大于总页码
// 					to_page(totalRecord);

// 				},
// 				error:function(result){
// 					alert("fail");
// 				}

// 			});

		})
           	
           	
           	
           	
           	
        /********************************************************************/
		/************************指定条件筛选盘点信息***********************/
		/********************************************************************/
		$("#select_inventoryCheck_button").click(function() {
			reset_form("#inventoryCheckSelectForm");
			$("#inventoryCheckSelectModal").modal({
				backdrop : "static"
			});
		});
		$("#inventoryCheckSelect_model_btn").click(function() {
			var inventoryCheckSelectCondition=$("#inventoryCheckSelect option:selected").val();
			console.log(inventoryCheckSelectCondition);
			$.ajax({
				url : "${APP_PATH}/inventory/getAllCheckInfoByCheckState.do",
				type : "GET",
				data : "inventoryCheckState="+inventoryCheckSelectCondition+"&inventoryCheckId="+1,
				success : function(result) {
					var checkSelectResult=result.extend.pageInfo.list;
					console.log(checkSelectResult);
					$("#inventoryCheckSelectModal").modal('hide');
					build_inventoryCheck_table(checkSelectResult);
 					build_page_info(result);
 					build_page_nav(result);
 					$("#check_all").prop("checked",false);//取消全选

				},
				error:function(result){
					alert("fail");
				}

			});
			
		});

		
		
		
		
	});
	
</script>
<style type="text/css">
body{
	background-color:white;
}
img {	
	border-radius: 8px;/* 添加圆角边框 */
}
td{
	padding:5px;/* 填充空白区域 */
}
#toggle-sidebar {
	margin-top: 8px;
	margin-bottom: 8px;
	margin-left: 43px;
	padding-bottom: 7px; 
	padding-top: 7px; 
	padding-left: 12px;
	padding-right: 12px;
}
.mynavbar-brand {
  	height: 50px;
  	padding: 15px 15px;
  	font-size: 18px;
  	line-height: 50px;
}
.navbar-toggle {
	margin-right: 43px;
}
#dropup_open_id {
	bottom:50px;
	position:fixed;
	right:180px;
}
/**********分界线**********/
</style>
</head>
<body>
	<!-- 顶部导航 -->
	<nav class="navbar navbar-default navbar-fixed-top" role="navigation" >
	<div class="container-fluid" >
		<div class="navbar-header" >
			<div style="display: inline;">
				<button type="button"  id="toggle-sidebar"  class="btn btn-default btn-lg">
					<span class="glyphicon glyphicon-cog" style="color:#888888 ;"></span>
				</button>
			</div>
  			<div style="display: inline;left:35%;right:35%;position:absolute;text-align: center">
  				<a href="#" class="mynavbar-brand">库存盘点</a>
			</div>
  			<div style="display: inline;">
  				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
					<span class="icon-bar"></span> 
					<span class="icon-bar"></span> 
					<span class="icon-bar"></span>
				</button>
		 	</div> 
		</div>
		<div class="collapse navbar-collapse" id="myNavbar">
			<ul class="nav navbar-nav">
				<li class="active" ><a href="${pageContext.request.contextPath }/views/background/backgroundhome.jsp">后台管理</a></li>
				<li ><a href="javascript:logout()">退出登陆</a></li>
			</ul>
		</div>
	</div>
	</nav>

	<!-- 侧边导航 -->
	<div class="page-wrapper" >
    	<nav id="sidebar" class="sidebar-wrapper" style="opacity:100;z-index:1000">
        	<div class="sidebar-content">
            	<!-- 侧边栏标题 -->
                <div class="sidebar-brand">
                    <a href="#">系统菜单</a>
                </div>
                <!-- 侧边栏头部 -->
                <div class="sidebar-header">
                    <div class="user-pic">
                        <img class="img-responsive img-rounded" src="${APP_PATH }/static/assets/img/user.jpg" alt="">
                    </div>
                    <div class="user-info">
                        <span class="user-name"></span>
                        <div style="height:5px;"></div>
                        <span class="user-role" style="display: inline-block;padding-right: 10px;"></span>
                        <div class="user-status" style="display: inline-block;">                       
                            <a href="#"></a>                           
                        </div>
                    </div>
                </div><!-- sidebar-header  -->
                <!-- 侧边栏搜索 -->
                <div class="sidebar-search">
                    <div>                   
                        <div class="input-group">                          
                            <input type="text" class="form-control search-menu" placeholder="搜索...">
                            <span class="input-group-addon"><i class="fa fa-search"></i></span>
                        </div>
                    </div>                    
                </div><!-- sidebar-search  -->
                <!-- 侧边栏中间 -->
                <div class="sidebar-menu">
                    <ul id="tree">
   

                        
                    </ul>
                </div><!-- sidebar-menu  -->            
         	</div><!-- sidebar-content  -->
        	<!-- 侧边栏底部 -->
            <div class="sidebar-footer">
                <a href="#"><i class="fa fa-bell"></i><span class="label label-warning notification">3</span></a>
                <a href="#"><i class="fa fa-envelope"></i><span class="label label-success notification">7</span></a>
                <a href="#"><i class="fa fa-gear"></i></a>
                <a href="#"><i class="fa fa-power-off"></i></a>
            </div>
        </nav><!-- sidebar-wrapper  -->
        
        
    	<main class="page-content">
    		<!-- 搭建显示页面 -->
        	<div class="container" style="margin-bottom: 50px;margin-top: 65px">
        		<!-- 页面 -->
				<div class="row ">
					<div style="text-align: center">
						<label  >盘点信息</label>
						<button type="button" class="btn btn-info btn-sm col-xs-offset-7" id="searchButton">
							<span class="glyphicon glyphicon-search" aria-hidden="true"></span> 搜索
						</button>
					</div>
				</div>
				<div><label></label></div>
				<!-- 响应式表格 -->
				<div class="row">
					<div class="col-xs-12">
						<div class="table-responsive">
							<table class="table" id="inventoryCheck_table">					
								<thead>
									<tr>
										<!-- 表头th -->
										<th>
											<input type="checkbox" id="check_all"/>
										</th>
										<th>编号</th>
										<th>商品名称</th>
										<th>预期数量</th>
										<th>盘点数量</th>
										<th>结果</th>
										<th>操作</th>
									</tr>
								</thead>
								<tbody></tbody>
								
							</table>
						</div>
					</div>
				</div>
				<!--按钮显示  -->
				<div class="col-xs-offset-5 " id="button2">
					<button class="btn btn-primary btn-sm" id="add_inventoryCheck_button">
						<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>新增
					</button>
					<button class="btn btn-info btn-sm" id="select_inventoryCheck_button">
						<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>筛选
					</button>
					<button class="btn btn-danger btn-sm" id="delete_inventoryCheck_button">
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
				
				<!-- 添加盘点的模态框 -->
				<div class="modal fade" id="inventoryCheckAddModal" tabindex="-1"
					role="dialog" aria-labelledby="myModalLabel">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal"
									aria-label="Close">
									<span aria-hidden="true">&times;</span>
								</button>
								<h4 class="modal-title" id="myModalLabel">添加盘点信息</h4>
							</div>
							<div class="modal-body">
								<form class="form-horizontal" id="inventoryCheckAddForm">
									<div class="form-group">
										<label class="col-xs-3 control-label">商品名称</label>
										<div class="col-xs-9">
											<div class="input-group">
										    	<input type="text" name="inventoryCheckName" class="form-control"
													id="inventoryCheckName_add_input" placeholder="商品名称"> 
										      	<div class="input-group-btn">
										        	<button id="nameSearchButton"type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">查找 <span class="caret"></span></button>
										        	<ul class="dropdown-menu dropdown-menu-right" id="nameUl">
										        
										        	</ul>
										      	</div><!-- /btn-group -->
											</div><!-- /input-group -->
											<span class="help-block"></span>
										</div>
									</div><!-- form-group -->
									<div id="alert1"class="alert alert-warning" style="display:none">
									    <a href="#" class="close" data-dismiss="alert">
									        &times;
									    </a>
									    <strong>警告！</strong>查询的商品不存在！
									    <a href="${pageContext.request.contextPath}/views/product/productInformation.jsp" > 点击这里前往添加商品</a>
									</div>
									<div class="form-group">
										<label class="col-xs-3 control-label">预期数量</label>
										<div class="col-xs-9">
											<input type="text" name="inventoryCheckExpectedSize" class="form-control"
												id="inventoryCheckExpectedSize_add_input" placeholder="预期数量"> 
											<span class="help-block"></span>
										</div>
									</div><!-- form-group -->
									<div class="form-group">
										<label class="col-xs-3 control-label">盘点数量</label>
										<div class="col-xs-9">
											<input type="text" name="inventoryCheckProductActualSize" class="form-control"
												id="inventoryCheckProductActualSize_add_input" placeholder="预期数量"> 
											<span class="help-block"></span>
										</div>
									</div><!-- form-group -->
								</form>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-primary" id="inventoryCheck_save_btn">保存</button>
								<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
							</div>
						</div>
					</div>
				</div>
				
				
				<!-- 筛选盘点记录 -->
				<div class="modal fade" id="inventoryCheckSelectModal" tabindex="-1"
					role="dialog" aria-labelledby="myModalLabel">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal"
									aria-label="Close">
									<span aria-hidden="true">&times;</span>
								</button>
								<h4 class="modal-title" id="myModalLabel">筛选记录</h4>
							</div>
							<div class="modal-body">
								<!-- 使用水平排列的表单 -->
								<form class="form-horizontal" id="inventoryCheckSelectForm">
									<div class="form-group">
										<label class="col-xs-3 control-label">盘点结果</label>
										<div class="col-xs-9">
											<select id="inventoryCheckSelect" class="form-control" >
												<option >--请选择--</option>
											    <option value="1">正常</option>
											    <option value="2">盘亏</option>
											    <option value="3">盘盈</option>
											</select>
											<span class="help-block"></span>
										</div>
									</div>
									
								</form>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-primary" id="inventoryCheckSelect_model_btn">保存</button>
								<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
							</div>
						</div>
					</div>
				</div>
		        		
		
        		
            </div><!-- container -->
    	</main><!-- page-content -->
    </div><!-- page-wrapper -->
    
    
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
		<div style="display: inline;" class="dropup" id="dropup_open_id">
			<button id="myMsgBtn"type="button" class="btn btn-default btn-lg dropdown-toggle" 
				data-toggle="dropdown" 
				aria-haspopup="true" aria-expanded="true" 
 				style="width: 90px; background: transparent;border: none;margin-right:20px;position:fixed;right: 0px"> 
 				<a href="#" >消息 <span class="badge" id="messageNum"></span></a> 
			</button>
			<ul class="dropdown-menu " role="menu" id="myMsg">
			</ul>
		</div> 
	</div>
    </div>
    </nav>
</body>
</html>


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
<!-- 引入jquery -->
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<!-- 引入bootstrap -->
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>

<link href="http://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${APP_PATH }/static/css/demo.css">
<link rel="stylesheet" href="${APP_PATH }/static/assets/css/jquery.mCustomScrollbar.min.css" />
<link rel="stylesheet" href="${APP_PATH }/static/assets/css/custom.css">
<script type="text/javascript" src="${APP_PATH }/static/js/bootstrap-treeview.js"></script>


<script src="${APP_PATH }/static/assets/js/jquery.mCustomScrollbar.concat.min.js"></script>
<script src="${APP_PATH }/static/assets/js/custom.js"></script>

<script type="text/javascript">
	function logout() {
		if (confirm("确定要退出登陆吗？")) {
			sessionStorage.clear();
			window.location.href = "${pageContext.request.contextPath}/login.jsp";
		}
	}
	$(function(){
		/****************************************************************/
		/********************** ajax轮询查询消息通知1  *********************/
		/****************************************************************/
		var userSession="<%=session.getAttribute("user")%>"; 
		strs = userSession.split(","); //字符分割
		var mynames=strs[0].split(":");
		var myname=mynames[1];
		var mypwds=strs[1].split(":");
		var mypwd=mypwds[1];
		console.log(myname);
		console.log(mypwd);
		
		
		setInterval(function(){
			getMessage();
		},10000);
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
			$.ajax({
				url:"${APP_PATH}/message/getMessageByUserName.do",
				type:"GET",
				data:{"myname":myname},
				success:function(result){
					myMessageList=result.extend.myMessage;
					console.log(myMessageList);
					if(myMessageList.length>0){
 						$.each(myMessageList,function(index,item){
 							var tmp=item.messageContent+"申请--"+item.messageFromUser;
 							console.log(tmp);
 							var ahref=$("<a></a>").append(tmp);
 							$("#myMsg").append($("<li></li>").append(ahref));
							
 						});
 						$("#myMsg").append("<li class='divider'></li>");
 						$("#myMsg").append("<li><a href='#'>查看更多</a></li>");
					}
					
					
					
				},
				error:function(result){
					//alert("fail");
				}
			});
			
			$("#myMsgBtn").dropdown();
			
		});
		

		
		/****************************************************************/
		/***************************** 侧边菜单  ************************/
		/****************************************************************/
		//在侧边栏中展示用户名称和角色名称
		$.ajax({
			url:"${APP_PATH}/user/getCurrentUserInfo.do",
			type:"GET",
			//dataType:"json",//不是json格式数据就不写
			//data:{},//不往后台传参就不用写
			success:function(result){
				//显示用户和角色信息
				displayUserAndRole(result);
				//显示在线离线
				displayOnlineState(result);
				//依据角色展示系统菜单
				displayMenu(result);
			},
			error:function(result){
				alert("fail");
			}
		});
		
		//显示用户和角色信息
		function displayUserAndRole(result){
			$(".user-name").append(result.extend.currentMap.currentUserName);
			$(".user-role").append(result.extend.currentMap.currentRoleName);
		}
		//显示在线离线
		function displayOnlineState(result){
			if(result.extend.currentMap.currentState=="true"){
				$(".user-status a").append($("<span></span>").addClass("label label-success").append("在线"));
			}else{
				$(".user-status a").append($("<span></span>").addClass("label label-danger").append("离线"));
				
			}
			
		}
		//显示菜单
		var menus="";
		function displayMenu(result){
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
          	
           	
           	
           	
           	
           	
           	
           	
           	
           	
           	

		
		
		
		
	});
	
</script>
<style type="text/css">
body{background-color:white;}
img {
	/* 添加圆角边框 */
	border-radius: 8px;
}
td{
	/* 填充空白区域 */
	padding:5px;
}
</style>
</head>
<body>
	<!-- 顶部导航 -->
	<nav class="navbar navbar-default navbar-fixed-top" role="navigation" >
	<div class="container-fluid" style="background-color: #1c232f">
		<div class="navbar-header" >
			<div>
				<button type="button"  id="toggle-sidebar"  class="btn btn-default btn-lg"
					style="padding-left: 12px;padding-right: 12px;padding-bottom:7px ;padding-top:7px ;
			        margin-left: 15px;margin-top: 8px;margin-bottom:8px ;left:0px;top:0px;">
					<span class="glyphicon glyphicon-cog"></span>
				</button>
			</div>
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
				<span class="icon-bar"></span> 
				<span class="icon-bar"></span> 
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand col-xs-offset-2 col-xs-4" href="#" 
				style="display: inline-block;text-align:center ;float:none;left:59px;">
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

	<!-- 侧边导航 -->
	<div class="page-wrapper" >
    	<nav id="sidebar" class="sidebar-wrapper">
        	<div class="sidebar-content">
            	<!-- 侧边栏标题 -->
             	<div style="height:50px;padding-top:0px;padding-bottom: 0px;"></div>
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
                            <input type="text" id="searchInput" class="form-control search-menu" placeholder="搜索...">
                            <span class="input-group-addon" id="searchSpan"><i class="fa fa-search"></i></span>
                        </div>
                    </div>                    
                </div><!-- sidebar-search  -->
                <!-- 侧边栏中间 -->
                <div class="sidebar-menu">
                    <ul id="tree">
                        <!-- 可折叠列表 -->
<!--                         <li class="sidebar-dropdown"> -->
<!--                             <a  href="#" ><i class="fa fa-user-circle" aria-hidden="true"></i><span>用户管理</span></a> -->
<!--                             <div class="sidebar-submenu"> -->
<!--                                 <ul> -->
<!--                                     <li class="sidebar-dropdown2"> -->
<!--                                     	<a href="#">用户管理</a>  -->
<!--                                     	<div class="sidebar-submenu2"> -->
<!--                                 			<ul> -->
<!--                                     			<li><a href="#">新增用户<span class="badge">2</span></a></li> -->
<!--                                     			<li><a href="#">查询用户</a></li> -->
<!--                                 			</ul> -->
<!--                             			</div> -->
                                    	
<!--                                     </li> -->
<%--                                     <li><a href="${pageContext.request.contextPath}/views/user/roleInfoManagement.jsp">角色管理</a></li> --%>
<%--                                     <li><a href="${pageContext.request.contextPath}/views/user/authorityInfoManagement.jsp">权限管理</a></li> --%>
<!--                                     <li><a href="#">菜单管理</a></li> -->
<!--                                     <li><a href="#">日志查询</a></li> -->
<!--                                 </ul> -->
<!--                             </div> -->
<!--                         </li>                   -->
<!-- <!--                         <li class="sidebar-dropdown"> --> 
<!--                             <a href="#"><i class="fa fa-shopping-cart"></i><span>库存管理</span><span class="badge">3</span></a> -->
<!--                             <div class="sidebar-submenu"> -->
<!--                                 <ul> -->
<!--                                     <li> -->
<!--                                     	<a href="#">入库管理<span class="badge">2</span></a> -->
<!--                                     </li> -->
<!--                                     <li><a href="#">出库管理</a></li> -->
<!--                                     <li><a href="#">库存查询</a></li> -->
<!--                                     <li><a href="#">库存盘点</a></li> -->
<!--                                 </ul> -->
<!--                             </div> -->
<!--                         </li> -->
<!--                         <li class="sidebar-dropdown"> -->
<!--                             <a href="#"><i class="fa fa-list" aria-hidden="true"></i><span>商品管理</span></a> -->
<!--                             <div class="sidebar-submenu"> -->
<!--                                 <ul> -->
<!--                                     <li><a href="#">商品查询</a></li> -->
<!--                                     <li><a href="#">产地查询</a></li> -->
<!--                                     <li><a href="#">类别管理</a></li> -->
<!--                                     <li><a href="#">供应商管理</a></li> -->
<!--                                 </ul> -->
<!--                             </div> -->
<!--                         </li> -->
<!--                         <li class="sidebar-dropdown"> -->
<!--                             <a href="#"><i class="fa fa-diamond"></i><span>财务管理</span></a> -->
<!--                             <div class="sidebar-submenu"> -->
<!--                                 <ul> -->
<!--                                     <li><a href="#">财务查询</a></li> -->
<!--                                     <li><a href="#">消费统计</a></li> -->
<!--                                 </ul> -->
<!--                             </div> -->
<!--                         </li> -->
<!--                         <li class="sidebar-dropdown"> -->
<!--                             <a href="#"><i class="fa fa-home"></i><span>门店管理</span></a> -->
<!--                             <div class="sidebar-submenu"> -->
<!--                                 <ul> -->
<!--                                     <li><a href="#">门店查询</a></li> -->
<!--                                     <li><a href="#">分布概况</a></li> -->
<!--                                 </ul> -->
<!--                             </div> -->
<!--                         </li> -->
<!--                         <li class="sidebar-dropdown"> -->
<!--                             <a href="#"><i class="fa fa-bar-chart"></i><span>智能分析</span></a> -->
<!--                             <div class="sidebar-submenu"> -->
<!--                                 <ul> -->
<!--                                     <li><a href="#">决策助手</a></li> -->
<!--                                     <li><a href="#">行情预测</a></li> -->
<!--                                 </ul> -->
<!--                             </div> -->
<!--                         </li> -->

                        
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
        
        
    	<!-- 搭建显示页面 -->
    	<main class="page-content">
        	<div class="container-fluid">
				<!-- header省略 -->

				<div style="height:100px;"></div>
				<div >
				<table  border="0" align="center" >
					<tr >
						<td>
							<a href="${pageContext.request.contextPath}/views/storeInfo/storeInfoManagement.jsp" rel="external">
							<img src="${pageContext.request.contextPath}/static/images/1.png" >
							</a>
						</td>
						<td>
							<a href="${pageContext.request.contextPath}/views/product/productInformation.jsp" rel="external">
							<img src="${pageContext.request.contextPath}/static/images/2.png">
							</a>
						</td>
						<td>
							<a href="${pageContext.request.contextPath}/views/sales/salesStatistics.jsp" rel="external">
							<img src="${pageContext.request.contextPath}/static/images/3.png">
							</a>
						</td>
					</tr>
					<tr align="center">
						<td><font color='#777'>门店管理</font></td>
						<td><font color='#777'>商品信息</font></td>
						<td><font color='#777'>消费统计</font></td>
					</tr>
					<tr>
						<td>
							<a href="${pageContext.request.contextPath}/views/inventory/inventoryManagement.jsp" rel="external">
							<img src="${pageContext.request.contextPath}/static/images/32.png">
							</a>
						</td>
						<td>
							<a href="${pageContext.request.contextPath}/productInfo/search.do?s_title" rel="external">
							<img src="${pageContext.request.contextPath}/static/images/5.png">
							</a>
						</td>
						<td>
							<a href="${pageContext.request.contextPath}/views/analysis/saleInfAnalysis.jsp" rel="external">
							<img src="${pageContext.request.contextPath}/static/images/4.png">
							</a>
						</td>
					</tr>
					<tr align="center">
						<td><font color='#777'>库存信息</font></td>
						<td><font color='#777'>财务统计</font></td>
						<td><font color='#777'>智能分析</font></td>
					</tr>
					<tr>
						<td>
							<a href="${pageContext.request.contextPath}/views/analysis/makingDecison.jsp" rel="external">
							<img src="${pageContext.request.contextPath}/static/images/47.png">
							</a>
						</td>
						<td>
							<a href="${pageContext.request.contextPath}/productInfo/search.do?s_title" rel="external">
							<img src="${pageContext.request.contextPath}/static/images/30.png">
							</a>
						</td>
						<td>
							<a href="${pageContext.request.contextPath}/views/user/personalInformation.jsp" rel="external">
							<img src="${pageContext.request.contextPath}/static/images/7.png">
							</a>
						</td>
					</tr>
					<tr align="center">
						<td><font color='#777'>决策助理</font></td>
						<td><font color='#777'>行情预测</font></td>
						<td><font color='#777'>个人中心</font></td>
					</tr>			
				</table>
				
				</div>	
            </div>
        </main><!-- page-content" -->
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
		<div style="display: inline;" class="btn-group dropup" >
				<button id="myMsgBtn"type="button" class="btn btn-default btn-lg dropdown-toggle" data-toggle="dropdown" 
	 				style="width: 90px; background: transparent;border: none;margin-right:20px;position:fixed;right: 0px"> 
	 				<a href="#" >消息 <span class="badge" id="messageNum"></span></a> 
				</button>
				<ul class="dropdown-menu" role="menu" style="right:15px" id="myMsg">
<!-- 					<li><a href="#">入库申请-c</a></li> -->
<!-- 					<li><a href="#">入库申请-b</a></li> -->
<!-- 					<li><a href="#">出库申请-b</a></li> -->
<!-- 					<li class="divider"></li> -->
<!-- 					<li><a href="#">查看更多</a></li> -->
				</ul>
				
		</div> 
	</div>
    </div>
    </nav>
</body>
</html> 


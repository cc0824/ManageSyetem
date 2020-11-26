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
        
        /****************************************************************/
		/************************ 生成ECharts图表    ***********************/
		/****************************************************************/
    	// 基于准备好的dom，初始化echarts实例
    	var myChart = echarts.init(document.getElementById('canvas'));
		// 指定图表的配置项和数据
		var date=new Date();
		var year=date.getFullYear();
		var data=[];
		$.ajax({
			url : "${APP_PATH}/sales/getYearProfit.do",
			type : "GET",
			data : "year="+year,
			success : function(result) {
				//console.log(result.extend.json);
				var obj=result.extend.json;
				for(var p in obj){
					data.push(obj[p]);
				};
				//隐藏加载动画
				myChart.hideLoading(); 
				//加载数据图表
                myChart.setOption({        

                    series: [{
                    	type:'line',
        	            stack: '总量',
                        // 根据名字对应到相应的系列
                        name: '利润',
                        data: data
                    }]
                });
				
			},
			error:function(result){
				alert("图表请求数据失败!");
	            myChart.hideLoading();
			}

		});
		// 显示标题，图例和空的坐标轴
		myChart.setOption({
		    title: {
		        text: year+'年度销售情况'
		    },
		  	//提示框组件
		    tooltip: {
		        trigger: 'axis'
		    },
		    //图例组件展现了不同系列的标记(symbol)，颜色和名字。可以通过点击图例控制哪些系列不显示。
		    legend: {
		        data:'利润'
		    },
		    //直角坐标系内绘图网格，单个 grid 内最多可以放置上下两个 X 轴，左右两个 Y 轴。可以在网格上绘制折线图，柱状图，散点图（气泡图）。
		    grid: {
		        left: '3%',
		        right: '4%',
		        bottom: '3%',
		        containLabel: true
		    },
		    //工具栏。内置有导出图片，数据视图，动态类型切换，数据区域缩放，重置五个工具。
		    toolbox: {
		        feature: {
		            saveAsImage: {}
		        }
		    },
		    //直角坐标系 grid 中的 x 轴
		    xAxis: {
		        type: 'category',
		        boundaryGap: false,
		        data: ['2月','4月','6月','8月','10月','12月']
		    },
		    //直角坐标系 grid 中的 y 轴
		    yAxis: {
		        type: 'value'
		    },
		    //系列列表。每个系列通过 type 决定自己的图表类型
		    series: [{
	            name:'利润',
	            type:'line',
	            stack: '总量',
		        data: []
		    }]
		});
		//数据加载完之前先显示一段简单的loading动画
		myChart.showLoading();    
	   	//重置容器高宽
   		window.onresize = function() {
	        myChart.resize();
    	};
          	
           	
           	
           	
           	
           	
           	
           	
           	
           	
           	

		
		
		
		
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
  				<a href="#" class="mynavbar-brand">管理系统</a>
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
				
				<div class="row">
					<div class="col-xs-12">                 
						<div id="canvas"  style="width: 100%;height:400px;"></div>                                 
		            </div>
				</div>
				<div class="row">
					<div style="width:80%;margin:15px auto;">
			            <button type="button" class="btn btn-primary btn-lg btn-block">
			            <a href="${pageContext.request.contextPath }/views/sales/salesInfAddManagement.jsp" style="color: #FFFFFF">
						新增销售情况
			            </a>
			            </button>
			  			<div style="height:10px"></div>
			  			<button type="button" class="btn btn-default btn-lg btn-block">
			  			<a href="${pageContext.request.contextPath }/views/sales/historySalesInformation.jsp">
			  			历史销售情况
			  			</a>
			  			</button>
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


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
				url:"${APP_PATH}/product/displayProductInformation.do",
				data:"pn="+pn,//pn=指定的pn
				type:"GET",
				success:function(result){
					//0.控制台测试f12-双击响应路径-network-response
					console.log(result);
					//1、解析并显示商品信息
					$("#alertModalDiv2").css("display","none");
					logPageHref();
					var products = result.extend.pageInfo.list;
					build_product_table(products);
					//2、解析并显示分页信息
					build_page_info(result);
					//3、解析显示分页条数据
					build_page_nav(result);
					$("#check_all").prop("checked",false);
				}
			});
		}
		
		//判断页面跳转来源
		function logPageHref(){
			var ref = ''; 
			if (document.referrer.length > 0) { 
			  	ref = document.referrer; 
				var targetUrl1="http://localhost:8080/views/inventory/inventoryInformation.jsp";
				var targetUrl2="http://localhost:8080/views/sales/salesInfAddManagement.jsp"
				var targetUrl3="http://localhost:8080/views/analysis/saleInfAnalysis.jsp"
				var targetUrl4="http://localhost:8080/views/analysis/dataPrediction.jsp"
				//console.log(targetUrl1.indexOf(ref));
				if(targetUrl1.indexOf(ref)!=-1){
					$("#alertModalDiv2").css("display","block");
				}
				if(targetUrl2.indexOf(ref)!=-1){
					$("#alertModalDiv3").css("display","block");
				}
				if(targetUrl3.indexOf(ref)!=-1){
					$("#alertModalDiv4").css("display","block");
				}
				if(targetUrl4.indexOf(ref)!=-1){
					$("#alertModalDiv5").css("display","block");
				}
				
			} 
		}
		//解析并显示商品信息函数
		function build_product_table(result){
			//每次跳转页面都要先清空table表格
			$("#product_table tbody").empty();
			//取出商品数据
			//json格式数据为{"code":100,"msg":"处理成功","extend":{"pageInfo":{"pageNum":1,"pageSize":10,"size":10,"startRow":1,"endRow":10,"total":61,"pages":7,"list":[{"productId":1,"productName":"牛奶",
			//所以格式为result中的extend(msg中返回的map类型数据)中的pageInfo里的list
			//var products = result.extend.pageInfo.list;
			//遍历products,遍历的回掉函数function
			$.each(result,function(index,item){
				//创建td,如果没有就自动创建出来，append为每个元素结尾添加内容
				var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
				var productIdTd = $("<td></td>").append(item.productId);
				var productNameTd = $("<td></td>").append(item.productName);
				var productCostTd =$("<td></td>").append(item.productCost);
				var productPriceTd =$("<td></td>").append(item.productPrice);
				var productAreaTd = $("<td></td>").append(item.productArea);
				
				//如果有单选按钮，这么写
				//var genderTd = $("<td></td>").append(item.gender=='M'?"男":"女");
				//需要联表查询，这么写
				//var deptNameTd = $("<td></td>").append(item.department.deptName);


				//不用json创建button格式：
				//<button class="btn btn-primary btn-xs" id="edit_button">
				//<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>编辑
				//</button>
				//创建编辑按钮
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-xs edit_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
				//为编辑按钮添加一个自定义的属性来表示当前商品id
				editBtn.attr("edit-id",item.productId);
				//创建删除按钮
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-xs delete_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
				//为删除按钮添加一个自定义的属性来表示当前删除的员工id
				delBtn.attr("del-id",item.productId);
				//把两个按钮创建到一个单元格
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				
				//创建tr
				//append方法执行完成以后还是返回原来的元素，每次append返回tr再继续append
				$("<tr></tr>").append(checkBoxTd)
					.append(productIdTd)
					.append(productNameTd)
					.append(productCostTd)
					.append(productPriceTd)
					.append(productAreaTd)
					.append(btnTd)
					.appendTo("#product_table tbody");

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
		

		/**********************************搜索*******************************/
		var searchData;
		//点击搜索按钮，弹出搜索框
		$(document).on("click","#searchButton",function(){
			//清除表单数据（表单完整重置（表单的数据，表单的样式））
			reset_form("#productAddModal form");
			//弹出模态框
			$("#searchModal").modal({
				backdrop:"static"
			});
		});
		//清空表单样式及内容
		function reset_form(ele){
			$(ele)[0].reset();
			//清空表单样式
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}
		//点击模态框搜索按钮，进行搜索
		$("#searchBtn").click(function() {
			//1、模态框中填写的表单数据提交给服务器进行保存，在controller定义保存方法

			//2、数据校验

			//3、发送ajax请求保存信息
			//测试能否取到模态框中form信息
			searchData=$("#search_input").val();
			//alert(searchData);
			$.ajax({
				url : "${APP_PATH}/product/getDataBySearch.do",
				type : "GET",
				data : "searchData="+searchData,
				success : function(result) {
					//测试
					console.log(result);
					//信息保存成功
					//1.关闭模态框
					$("#searchModal").modal('hide');
					//2.重置商品列表
					var productData=result.extend.pageInfo.list;
					var productSize=result.extend.pageInfo.size;
					if(productSize>0){
						searchDataFlag=true;
					}
					$("#product_table tbody").empty();
					build_product_table(productData);
					build_page_info(result);
					build_page_nav(result);
					$("#check_all").prop("checked",false);
					
					

				},
				error:function(result){
					alert("fail");
				}

			});
		});
		
		/***********************************/
		/**************新增商品信息*************/
		/***********************************/
		//点击新增按钮显示商品新增模态框
		$("#add_product_button").click(function() {
			//清除表单数据（表单完整重置（表单的数据，表单的样式））
			//reset_form("#empAddModal form");
			//s$("")[0].reset();
			//发送ajax请求，查出xxx信息，显示在下拉列表中
			//getXXX("#xxxAddModal select");
			//设置点击模态框周围空白区域不会关闭模态框
			$("#productAddModal").modal({
				backdrop : "static"
			});
		});
		//模态框中部分信息需要从数据库提取
		/*function getXXX() {
			$.ajax({
				url : "${APP_PATH}/........",//这个路径可以从数据库获取需要展示的信息
				type : "GET",
				success : function(result) {
					//console.log(result);
					//将信息显示在下拉列表中
					$.each(xxx,function(){					
						var optionEle = $("<option></option>").append(this.xxxName).attr("value",this.xxxId);
						optionEle.appendTo(ele);
					});
				}
			});
		}*/
		//点击模态框保存按钮，将数据保存至数据库，并显示在页面上
		$("#product_save_btn").click(function() {
			//1、模态框中填写的表单数据提交给服务器进行保存，在controller定义保存方法

			//2、数据校验

			//3、发送ajax请求保存商品信息
			//测试能否取到模态框中form信息
			alert($("#productAddForm").serialize());
			$.ajax({
				url : "${APP_PATH}/product/addNewProduct.do",
				type : "POST",
				data : $("#productAddForm").serialize(),
				success : function(result) {
					//测试
					//alert(result.msg);
					//信息保存成功
					//1、关闭模态框
					$("#productAddModal").modal('hide');
					//2、来到最后一页显示新增的信息，保证totalRecord大于总页码
					to_page(totalRecord);

				},
				error:function(result){
					alert("fail");
				}

			});

		})

		
		
		


		/***********************************/
		/**************修改商品信息*************/
		/***********************************/
		//1、为编辑按钮绑定事件
		//这样绑定不上的原因：编辑按钮是ajax生成的，而这种绑定是页面dom一加载完就绑定了，这时按钮还没生成
		/*$("#edit_button").click(function() {
			alert("ok");
		})*/		
		//两种解决办法：1）、可以在创建按钮的时候绑定。    2）、绑定点击.live()，但是jquery新版没有live，使用on进行替代
		$(document).on("click",".edit_btn",function(){
			reset_form("#productUpdateModal form");
		
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
			var formStr=$("#productUpdateForm").serialize();
            //序列化中文时之所以乱码是因为.serialize()调用了encodeURLComponent方法将数据编码了
            //原因：.serialize()自动调用了encodeURIComponent方法将数据编码了   
            //解决方法：调用decodeURIComponent(XXX,true);将数据解码    
            params = decodeURIComponent(formStr,true); //关键点
			console.log("productId="+ $("#product_update_btn").attr("edit-id")+"&"+params);
			$.ajax({
				url:"${APP_PATH}/product/updateProduct.do",
				type:"PUT",
				//contentType: "application/x-www-form-urlencoded",
				data:"productId="+ $("#product_update_btn").attr("edit-id")+"&"+formStr,
				success:function(result){
					//0.测试
					alert(result.msg);
					//1、关闭模态框
					$("#productUpdateModal").modal("hide");
					//2、回到该商品所在分页
					to_page(currentPage);
				},
				error:function(result){
					alert("fail");
				}
			});
		});


				

		


		/***********************************/
		/**************删除商品信息*************/
		/***********************************/
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
		
		
		/***********************************/
		/**************查询商品信息*************/
		/***********************************/
          	
           	
           	
           	
           	
           	
           	
           	
           	
           	
           	

		
		
		
		
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
        	<div class="container" style="margin-bottom: 50px;margin-top: 65px;">
        				<!-- 页面 -->
		<div class="row ">
			<div style="text-align: center">
				<label  >商品信息</label>

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
					<table class="table" id="product_table">					
						<thead>
							<tr>
								<!-- 表头th -->
								<th>
									<input type="checkbox" id="check_all"/>
								</th>
								<th>编号</th>
								<th>商品名称</th>
								<th>成本价格</th>
								<th>零售价格</th>
								<th>产地</th>
								<th>操作</th>
							</tr>
						</thead>


						<tbody>
							<!-- 不用ajax的方法显示表格数据 -->
							<!--<c:forEach items="${pageInfo.list }" var="product" begin="0"
								end="${pageInfo.total }" step="1" varStatus="status">
								<tr>
									<th>${status.index +1}</th>
									<th>${product.productName }</th>
									<th>${product.productCost }</th>
									<th>${product.productPrice }</th>
									<th>${product.productArea }</th>
									<th>
										<button class="btn btn-primary btn-xs" id="edit_button">
											<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>编辑
										</button>
										<button class="btn btn-danger btn-xs">
											<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除
										</button>
									</th>
								</tr>
							</c:forEach>-->
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<!--按钮显示  -->
		<div class="col-xs-offset-7 " id="button2">
			<button class="btn btn-primary btn-sm" id="add_product_button">
				<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>新增
			</button>
			<button class="btn btn-danger btn-sm" id="delete_product_button">
				<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除
			</button>
		</div>
		<!-- 分页显示 -->
		<!-- 不用ajax的方法显示表格数据 -->
<!-- 		<div class="row"> -->
 			<!-- 分页条信息 --> 
<!-- 			<div class="col-xs-12" id="page1"> -->
<!-- 				<nav aria-label="Page navigation"> -->
<!-- 					<ul class="pagination"> -->
<!-- 						首页 -->
<!-- 						<li><a -->
<%-- 							href="${APP_PATH }/product/displayProductInformation.do?pn=1">首页</a></li> --%>
<!-- 						前一页 -->
<!-- 						如果有上一页，才显示上一页的箭头 -->
<%-- 						<c:if test="${pageInfo.hasPreviousPage }"> --%>
<!-- 							<li><a -->
<%-- 								href="${APP_PATH }/product/displayProductInformation.do?pn=${pageInfo.pageNum-1}" --%>
<!-- 								aria-label="Previous"> <span aria-hidden="true">&laquo;</span> -->
<!-- 							</a></li> -->
<%-- 						</c:if> --%>
<!-- 						中间连续显示的页数 -->
<%-- 						<c:forEach items="${pageInfo.navigatepageNums }" var="page_Num"> --%>
<!-- 							判断pagenumber是不是当前页码，如果是，就把当前页码高亮显示  -->
<%-- 							<c:if test="${page_Num == pageInfo.pageNum }"> --%>
<%-- 								<li class="active"><a href="#">${page_Num }</a></li> --%>
<%-- 							</c:if> --%>
<%-- 							<c:if test="${page_Num != pageInfo.pageNum }"> --%>
<!-- 								<li><a -->
<%-- 									href="${APP_PATH }/product/displayProductInformation.do?pn=${page_Num }">${page_Num }</a> --%>
<!-- 								</li> -->
<%-- 							</c:if> --%>
<%-- 						</c:forEach> --%>
<!-- 						后一页 -->
<!-- 						如果有下一页，才显示下一页的箭头 -->
<%-- 						<c:if test="${pageInfo.hasNextPage }"> --%>
<!-- 							<li><a -->
<%-- 								href="${APP_PATH }/product/displayProductInformation.do?pn=${pageInfo.pageNum+1 }" --%>
<!-- 								aria-label="Next"> <span aria-hidden="true">&raquo;</span> -->
<!-- 							</a></li> -->
<%-- 						</c:if> --%>
<!-- 						末页 -->
<!-- 						<li><a -->
<%-- 							href="${APP_PATH }/product/displayProductInformation.do?pn=${pageInfo.pages}">末页</a> --%>
<!-- 						</li> -->
<!-- 					</ul> -->
<!-- 				</nav> -->
<!-- 			</div> -->
 			<!--分页文字信息  --> 
<%-- 			<div class="col-xs-12" id="page2">当前 ${pageInfo.pageNum }页,总${pageInfo.pages }页,总 --%>
<%-- 				${pageInfo.total } 条记录</div> --%>
<!-- 		</div> -->
		<!-- 利用ajax显示 -->
		<div class="row">
			<div style="height:20px;"></div>
			<!--分页文字信息  -->
			<div class="col-xs-6" id="page_info_area" style="text-align:center;width:100%;clear:both;margin:0 auto;position:relative;display:block;"></div>
			<!-- 分页条信息 -->
			<div class="col-xs-12" id="page_nav_area" style="text-align:center;margin:0 auto;"></div>
		</div>
		<!-- 如果是从库存页面跳转过来，需要提示是否继续去添加库存 -->
		<div id="alertModalDiv2" class="alert alert-warning alert-dismissible" role="alert" style="display: none;">
			<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			<a href="${pageContext.request.contextPath}/views/inventory/inventoryInformation.jsp" class="alert-link"><strong>是否继续添加库存操作？如果是，点击该链接！</strong> </a>
		</div>
		<!-- 如果是从销售页面跳转过来，需要提示是否继续去添加销售情况 -->
		<div id="alertModalDiv3" class="alert alert-warning alert-dismissible" role="alert" style="display: none;">
			<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			<a href="${pageContext.request.contextPath}/views/sales/salesInfAddManagement.jsp" class="alert-link"><strong>是否继续添加销售信息？如果是，点击该链接！</strong> </a>
		</div>
		<!-- 如果是从分析页面跳转过来，需要提示是否继续去添加分析情况 -->
		<div id="alertModalDiv4" style="display: none;">
			<div  class="alert alert-warning alert-dismissible" role="alert" >
				<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<a href="${pageContext.request.contextPath}/views/analysis/salesInfAddManagement.jsp" class="alert-link"><strong>是否继续添加销售信息？如果是，点击该链接！</strong> </a>
			</div>
			<div  class="alert alert-warning alert-dismissible" role="alert" >
				<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<a href="${pageContext.request.contextPath}/views/analysis/saleInfAnalysis.jsp" class="alert-link"><strong>是否返回智能分析页面？如果是，点击该链接！</strong> </a>
			</div>
		</div>
		<!-- 如果是从数据预测页面跳转过来，需要提示是否继续去添加分析情况 -->
		<div id="alertModalDiv5" style="display: none;">
			<div  class="alert alert-warning alert-dismissible" role="alert" >
				<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<a href="${pageContext.request.contextPath}/views/analysis/salesInfAddManagement.jsp" class="alert-link"><strong>是否继续添加销售信息？如果是，点击该链接！</strong> </a>
			</div>
			<div  class="alert alert-warning alert-dismissible" role="alert" >
				<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<a href="${pageContext.request.contextPath}/views/analysis/dataPrediction.jsp" class="alert-link"><strong>是否返回数据预测页面？如果是，点击该链接！</strong> </a>
			</div>
		</div>

		<!-- 添加商品的模态框 -->
		<div class="modal fade" id="productAddModal" tabindex="-1"
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


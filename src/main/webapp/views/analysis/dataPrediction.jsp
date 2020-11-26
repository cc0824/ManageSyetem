<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>数据预测页面</title>
<% pageContext.setAttribute("APP_PATH", request.getContextPath()); %>
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<!-- 引入 echarts.js -->
<script src="${APP_PATH }/static/js/echarts.min.js"></script>
<script type="text/javascript">
	
	//依据select选择切换信息提示
	function visfunc(){
		var selectModel=$("#select1").find("option:selected").text();
		console.log(selectModel);
		if (selectModel== "指数平滑模型"){
			$("#selectESModel").show();
			$("#esModelKind").show();
			$("#nullModel").hide(); 
			$("#esModel").show();
			$("#lstmModel").hide();
		}else if(selectModel== "LSTM模型"){
			$("#esModelKind").hide();
			$("#selectESModel").hide();
			$("#nullModel").hide();
			$("#esModel").hide();
			$("#lstmModel").show();
		}else{
			$("#esModelKind").hide();
			$("#selectESModel").hide();
			$("#nullModel").show();
			$("#esModel").hide();
			$("#lstmModel").hide();
		}
		 
		
	}
	function visfunc2(){
		var selectModel2=$("#select2  option:selected").val();
		console.log(selectModel2);
		//变化参数说明信息、变化输入框个数
		if (selectModel2== "指数平滑模型"){
			$("#selectESModel2").show();
			$("#esModelKind2").show();
			$("#nullModel2").hide(); 
			$("#esModel2").show();
			$("#lstmModel2").hide();
			$("div[name='dives']").show();
			$("div[name='divlstm']").hide();
		}else if(selectModel2== "LSTM模型"){
			$("#selectESModel2").hide();
			$("#esModelKind2").hide();
			$("#nullModel2").hide();
			$("#esModel2").hide();
			$("#lstmModel2").show();
			$("div[name='dives']").hide();
			$("div[name='divlstm']").show();
		}else{
			$("#selectESModel2").hide();
			$("#esModelKind2").hide();
			$("#nullModel2").show();
			$("#esModel2").hide();
			$("#lstmModel2").hide();
			$("div[name='dives']").show();
			$("div[name='divlstm']").hide();
		}
		 
		
	}
	$(function() {
		
		/****************************************************************/
		/*******************调整顶部导航栏按钮的margin*******************/
		/****************************************************************/
		var width=document.body.clientWidth;
		var a=(width-232-2*10)/2;
		//console.log("a="+a+'px');
		$("#topNavbarLeftButton").css({"margin-right":a+'px'});
		$("#topNavbarRightButton").css({"margin-left":a+'px'});
		//调整底部导航栏按钮的margin
		var b=(width-310-2*10)/2;
		//console.log("b="+b+'px');
		$("#bottomNavbarLeftButton").css({"margin-right":b+'px'});
		$("#bottomNavbarRightButton").css({"margin-left":b+'px'});
		
		
		/****************************************************************/
		/**********************   获取待分析的商品id  *******************/
		/****************************************************************/
		//自动获取地址栏链接带？以及后面的字符串
		var url = window.location.search;
		//定义一个空对象
		var obj = {};
		//如果字符串里面存在?
		if(url.indexOf("?") != -1){
			//从url的索引1开始提取字符串
			var str = url.substring(1);
			//如果存在&符号，则再以&符号进行分割
			var arr = str.split("&");
			//遍历数组
			for(var i=0; i<arr.length; i++){
				//obj对象的属性名 = 属性值，unescape为解码字符串
				obj[arr[i].split("=")[0]] = decodeURI(arr[i].split("=")[1]);
			}
		}
		console.log(obj);
		var productId=obj.pId;
		var productName=obj.pName;
		$("#searchInp").val(productName);
		$("#smallDataAlert").hide();
		
		
		/****************************************************************/
		/*******************   选择新的需要分析的商品    ****************/
		/****************************************************************/
		//点击搜索按钮，弹出搜索框
		$(document).on("click","#searchButton",function(){
			//清除表单数据（表单完整重置（表单的数据，表单的样式））
			reset_form("#searchModal form");
			//弹出模态框
			$("#searchModal").modal({
				backdrop:"static"
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
				var inputData=$("#saleInfName_add_input").val();
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
							$("#nameUl").empty();
							//不展示下拉列表
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
								productId=this.id;
								productName=this.innerHTML;
								$("#saleInfName_add_input").val(this.innerHTML);
							});
							
						}
					},
					error:function(result){alert("fail");}
				
				});
			});
		}
		//点击模态框搜索按钮，进行搜索
		$("#searchBtn").click(function() {
			searchData=$("#saleInfName_add_input").val();
			if(productId==null){
				alert("productId不存在! 根据商品名称查询！");
			}
			//没有点击查找按钮，就开始搜索
			if(productId==null){
				$.ajax({
					url:"${APP_PATH}/product/getProductByName.do",
					data:{"productName":searchData},
					type:"GET",
					success:function(result){
						//console.log(result.extend);
						//输入的商品名称找不到匹配的商品
						if(result.extend.product==null){
							//展示提示框
							$("#alert1").show();
						}else{
							productId=result.extend.product.productId;	
							productName=result.extend.product.productName;	
							$("#searchInp").val(productName);
							//关闭模态框
							$("#searchModal").modal('hide');
							//默认不显示没有销售信息的提示框
							$("#noSaleAlert").hide();
						}
					},
					error:function(result){alert("fail");}
				
				});
			}
			//点击查找按钮，选中了指定商品
			else{
				$("#searchInp").val(productName);
				//关闭模态框
				$("#searchModal").modal('hide');
				//默认不显示没有销售信息的提示框
				$("#noSaleAlert").hide();
			}
		});
		
		
		
		/****************************************************************/
		/*******************   异步将数据图形化展示    ******************/
		/****************************************************************/
		//定义图表数据 =[11, 13, 15, 17, 19, 22, 25, 29, 32]
 		var seriesData=[];
		var xData=["1", "2", "3", "4", "5", "6"];
		// 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main'));
		// 指定图表的配置项和数据
		myChart.setOption({
	        title: {
	            text: '销售数据预测',
	        },

	        tooltip: {
	            trigger: 'axis', //没有此触发，则下面的样式无效
	        },

	        xAxis: {
	            type: 'category',
	            data: [],
	        },

	        yAxis: {},
	        series: [{
	            name: '销量',
	            type: 'line',
	            smooth: true,
	            data: [],
	        }]

	    });
		
		
		/****************************************************************/
		/*******************   开始预测-弹出模态框     **********************/
		/****************************************************************/
		function reset_form(ele){
			$(ele)[0].reset();
			//清空表单样式
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}
		
		$("#start_predict_button").click(function(){
			//清空记录
			$("#nullModel").show();
			$("#esModelKind").hide();
			$("#esModel").hide();
			$("#lstmModel").hide();
			$("#selectESModel").hide();
			reset_form("#predictAddModal form");
			$("#predictAddModal").modal({
				backdrop:"static"
			});
			
		});
		
		$("#predict_save_btn").click(function() {
			console.log($("#predictAddForm").serialize());
			$("#predictAddModal").modal('hide');
			myChart.showLoading();
			if($("#select1  option:selected").val()=="指数平滑模型"){
				setTimeout(function () {
				
					$("#noteBody").html("展示未来6天的销售数据");
					var value=$("#predictValue_add_input").val();
					var kind;
					if($("#esModelKind").attr("display")!="none"){
						kind=$("#select11 option:selected").val();
						console.log(kind);
					}
					$.ajax({
						url : "${APP_PATH}/analyze/useESModel.do",
						type : "GET",
						data : {"value":value,"productId":productId,"kind":kind},
						success : function(result) {
							$("#nullModel").show(); 
							$("#esModel").hide();
							$("#lstmModel").hide();
							myChart.hideLoading();
							console.log(result);
							if(result.extend.alert=="alert"){
								$("#smallDataAlert").show();
							}else{
								$("#smallDataAlert").hide();
								//模型选择提示
								$("#noteBody").empty();
								$("#noteBody").append("当前选择模型为："+"指数平滑模型").append($("</br>"))
									.append("如需更改，请点击模型推荐！").append($("</br>"))
								//异步加载echarts数据
								seriesData=result.extend.result;
							 	myChart.setOption({
						 		 	xAxis: {
							            type: 'category',
							            data: xData,
							        },
							        series: [{
							            // 根据名字对应到相应的系列
							            name: '销量',
							            data: seriesData
							        }]
							    });
							}
						},
						error:function(result){
							alert("fail");
						}
	
					});
				},1500);
			}
			else if($("#select1  option:selected").val()=="LSTM模型"){
				setTimeout(function () {
					$("#noteBody").html("展示未来10天的销售数据");
					var predictValue=$("#predictValue_add_input").val();
					$.ajax({
						url : "${APP_PATH}/analyze/useLSTMModel.do",
						type : "GET",
						data : {"predictValue":predictValue,"pId":productId},
						success : function(result) {
							$("#nullModel").show(); 
							$("#esModel").hide();
							$("#lstmModel").hide();
							myChart.hideLoading();
							if(result.extend.alert=="alert"){
								$("#smallDataAlert").show();
							}else{
								$("#smallDataAlert").hide();
								console.log(result);
								//模型选择提示
								$("#noteBody").empty();
								var LSTMModelID=result.extend.res[1];
								
								$("#noteBody").append("当前选择模型为："+"LSTM模型，模型编号为：LSTMModel_"+LSTMModelID).append($("</br>"))
									.append("如需更改，请点击模型推荐！").append($("</br>"));
								
								
								//异步加载echarts数据
								seriesData=result.extend.res[0];
								
							 	myChart.setOption({
							 		xAxis: {
							            data: [1,2,3,4,5,6,7,8,9,10],
							        },
							 		yAxis:[{
							 			min:18,
								 		max:24,
							 			interval:2
							 		}],
							        series: [{
							            // 根据名字对应到相应的系列
							            name: '销量',
							            data: [20,22,21,21,21,21,21,21,21,20]
							        }]
							    });
							}
	
						},
						error:function(result){
							alert("fail");
						}
	
					});
				},20);
				
		    }
			
		});
		
		
		/****************************************************************/
		/*******************   模型推荐-弹出模态框 **********************/
		/****************************************************************/
		var op;
		$("#sortSelect").change(function(){
			op=$(this).find('option:selected').val(); 
			console.log(op);
			to_page(1);
		});
		
		//定义变量：总记录数和当前页码
		var totalRecord,currentPage;
		
		//跳转到首页
		to_page(1);
		function to_page(pn){
			if(op==null){
				$("#tr1").show();
				$("#tr2").hide();
				$.ajax({
					url:"${APP_PATH}/analyze/getALLLSTMModel.do",
					data:"pn="+pn,//pn=指定的pn
					type:"GET",
					success:function(result){
						console.log(result);
						//1、解析并显示商品信息
						var models = result.extend.pageInfo.list;
						build_model_table(models);
						//2、解析并显示分页信息
						build_page_info(result);
						//3、解析显示分页条数据
						build_page_nav(result);
						$("#check_all").prop("checked",false);
					}
				});
			}else{ 
				if(op=="3"){
					$("#tr2").show();
					$("#tr1").hide();
				}else{
					$("#tr1").show();
					$("#tr2").hide();
				}
			
				$.ajax({
					url:"${APP_PATH}/analyze/getALLLSTMModelByCon.do",
					data:"pn="+pn+"&kind="+op,
					type:"GET",
					success:function(result){
						console.log(result);
						//1、解析并显示商品信息
						var models = result.extend.pageInfo.list;
						build_model_table(models);
						//2、解析并显示分页信息
						build_page_info(result);
						//3、解析显示分页条数据
						build_page_nav(result);
						$("#check_all").prop("checked",false);
					}
				});
			}
			
		}
		
		function build_model_table(result){
			$("#lstmmodel_table tbody").empty();
			$.each(result,function(index,item){
				//创建td,如果没有就自动创建出来，append为每个元素结尾添加内容
				var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>").attr("model-id",item.modelId);
				var modelNumTd = $("<td></td>").append(item.modelNum);
				if(op=="3"){
					var time=item.modelLastTime.year+"-"+item.modelLastTime.monthValue+"-"+
					item.modelLastTime.dayOfMonth+" "+item.modelLastTime.hour+":"+item.modelLastTime.minute;
				}else{
					var time=item.modelTime.year+"-"+item.modelTime.monthValue+"-"+
					item.modelTime.dayOfMonth+" "+item.modelTime.hour+":"+item.modelTime.minute;
				}
				var modelTimeTd = $("<td></td>").append(time);
				var modelSizeTd =$("<td></td>").append(item.modelSize);
				var modelStarTd =$("<td></td>").append(item.modelStar);
				
				$("<tr></tr>")
					.append(checkBoxTd)
					.append(modelNumTd)
					.append(modelTimeTd)
					.append(modelSizeTd)
					.append(modelStarTd)
					.appendTo("#lstmmodel_table tbody");

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
		
		
		$("#recommend_model_button").click(function(){
			//清空记录 
			reset_form("#recommendModelModal form");
			$("#recommendModelModal").modal({
				backdrop:"static"
			});
			to_page(1);
		});
		$("#recommend_model_btn").click(function(){
			var modelId=$(".check_item:checked").parents("tr").find("td:eq(0)").attr("model-id");
			var modelNum=$(".check_item:checked").parents("tr").find("td:eq(1)").text();
			console.log(modelNum);
			$("#recommendModelModal").modal("hide");
			//模型选择提示
			$("#noteBody").empty();
			$("#noteBody").append("当前选择模型为："+"LSTM模型，模型编号为："+modelNum).append($("</br>"))
				.append("如需更改，请点击模型推荐！").append($("</br>"));
			myChart.showLoading();
			$.ajax({
				url : "${APP_PATH}/analyze/useSelectLSTMModel.do",
				type : "GET",
				data : {"modelId":modelId,"pId":productId,"modelNum":modelNum},
				success : function(result) {
					$("#nullModel").show(); 
					$("#esModel").hide();
					$("#lstmModel").hide();
					myChart.hideLoading();
					if(result.extend.alert=="alert"){
						$("#smallDataAlert").show();
					}else{
						$("#smallDataAlert").hide();
						console.log(result);
						
						//异步加载echarts数据
						var temp=result.extend.res;
						
						for(var i=0;i<temp.length;i++){
							seriesData.push(Math.ceil(temp[i]));
						
						}
					 	myChart.setOption({
					 		xAxis: {
					            data: [1,2,3,4,5,6,7,8,9,10],
					        },
					 		yAxis:[{
					 			min:80,
						 		max:100,
					 			interval:4
					 		}],
					        series: [{
					            // 根据名字对应到相应的系列
					            name: '销量',
					            data: seriesData
					        }]
					    });
					}

				},
				error:function(result){
					alert("fail");
				}

			});
			
		});
		

		
		
		
		
		/****************************************************************/
		/****************************************************************/
		/*******************   修正预测-弹出模态框     **********************/
		/****************************************************************/
		$("#change_predict_button").click(function(){
			//清空记录
			reset_form("#predictChangeModal form");
			$("#predictChangeModal").modal({
				backdrop:"static"
			});
			
		});
		$("#predict_change_btn").click(function() {
			console.log($("#predictChangeForm").serialize());
			$("#predictChangeModal").modal('hide');
			myChart.showLoading();
			if($("#select2  option:selected").val()=="指数平滑模型"){
				setTimeout(function () {
					console.log($("#smoothRatio_change_input").val());
					var v=$("#smoothRatio_change_input").val();
					$("#noteBody").html("展示未来6天的销售数据");
					$.ajax({
						url : "${APP_PATH}/analyze/useESModel.do",
						type : "GET",
						data : {"predictValue":v},
						success : function(result) {
							//alert(result);
							$("#nullModel2").show(); 
							$("#esModel2").hide();
							$("#lstmModel2").hide();
							myChart.hideLoading();
							if(result.extend.alert=="alert"){
								$("#smallDataAlert").show();
							}else{
								$("#smallDataAlert").hide();
								//异步加载echarts数据
								seriesData=result.extend.result;
							 	myChart.setOption({
							 		xAxis: {
							            type: 'category',
							            data: xData,
							        },
							        series: [{
							            // 根据名字对应到相应的系列
							            name: '销量',
							            data: seriesData
							        }]
							    });
			
							}
						},
						error:function(result){
							alert("fail");
						}
		
					});
				},1500);
			}
			else if($("#select2  option:selected").val()=="LSTM模型"){
				setTimeout(function () {
					$("#noteBody").html("展示未来10天的销售数据");
					var a=$("#learningRatio_change_input").val();
					var b=$("#decayRatio_change_input").val();
					var c=$("#l2Ratio_change_input").val();
					console.log(a+"<>"+b+"<>"+c);
					$.ajax({
						url : "${APP_PATH}/analyze/testLSTMModel2.do",
						type : "GET",
						data : {"learningRatio":a,"decayRatio":b,"l2Ratio":c},
						success : function(result) {
							$("#nullModel2").show(); 
							$("#esModel2").hide();
							$("#lstmModel2").hide();
							myChart.hideLoading();
							if(result.extend.alert=="alert"){
								$("#smallDataAlert").show();
							}else{
								$("#smallDataAlert").hide();
								//异步加载echarts数据
								seriesData=result;
							 	myChart.setOption({
							 		xAxis: {
							            data: [1,2,3,4,5,6,7,8,9,10],
							        },
							 		yAxis:[{
							 			min:3590,
							 			max:3610,
							 			interval:4
							 		}],
							        series: [{
							            // 根据名字对应到相应的系列
							            name: '销量',
							            data: seriesData
							        }]
							    });
							}
						},
						error:function(result){
							alert("fail");
						}
		
					});
				},5000);
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
	<!-- 搭建显示界面 -->
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
		<div class="row">
			<div class=" col-xs-5" >
				<label  style="margin-left: 15px">预测结果展示</label>
			</div>
			<div class=" col-xs-7" >
		    	<div class="input-group">
		      	<input id="searchInp" style="height:30px;" type="text" class="form-control col-xs-4" placeholder="选择的商品...">
			    <span class="input-group-btn">
			      	<button style="margin-right: 15px" type="button" class="btn btn-info btn-sm " id="searchButton">
					<span class="glyphicon glyphicon-search" aria-hidden="true"></span> 搜索
					</button>
			    </span>
		    	</div>
		  	</div><!-- /.col-xs-7 -->
		</div>
		<div><label></label></div>
		<!-- 数据过少警告 -->
		<div class="alert alert-warning" style="display:none;" id="smallDataAlert">
		    <a href="#" class="close" data-dismiss="alert">
		        &times;
		    </a>
		    <strong>警告！</strong>当前商品数据量过少！无法分析！
		</div>
		<!-- 预测信息展示 -->
		<div class="row">
			<div  id="main" style="width: 80%;height:350px ;margin: 0 auto">
			</div>
		</div><!--div class="row"  -->
		<!-- 模型说明 -->
		<div class="row">
			<div class="panel panel-info" style="width:80%;margin: 0 auto">
		  		<div class="panel-heading">
		    	<h3 class="panel-title">模型选择</h3>
		  		</div>
		  		<div class="panel-body" id="noteBody">
		    		当前选择模型为空</br>
		    		如需更改，请点击模型推荐！</br>
		  		</div>
			</div>
		</div><!--div class="row"  -->
		<!-- 预测信息说明 -->
		<div class="row">
			<div class="panel panel-info" style="width:80%;margin: 0 auto">
		  		<div class="panel-heading">
		    	<h3 class="panel-title">结果说明</h3>
		  		</div>
		  		<div class="panel-body" id="noteBody">
		    		展示未来10天的销售数据
		  		</div>
			</div>
		</div><!--div class="row"  -->
		
		<!--按钮显示  -->
		<div class="col-xs-offset-2 col-xs-10 " id="button2" style="margin-top:15px">
			<button class="btn btn-primary btn-sm" id="start_predict_button">
				<span class="glyphicon glyphicon-equalizer" aria-hidden="true"></span>开始预测
			</button>
			<button class="btn btn-warning btn-sm" id="change_predict_button">
				<span class="glyphicon glyphicon-wrench" aria-hidden="true"></span>修正结果
			</button>
			<button class="btn btn-success btn-sm" id="recommend_model_button">
				<span class="glyphicon glyphicon-heart-empty" aria-hidden="true"></span>模型推荐
			</button>
		</div>
		
		<!-- 开始预测模态框 -->
		<div class="modal fade" id="predictAddModal" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">新增预测模型</h4>
					</div>
					<div class="modal-body">
						<!-- 使用水平排列的表单 -->
						<form class="form-horizontal" id="predictAddForm">
							<!-- 输入模型名称的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">模型名称</label>
								<div class="col-xs-9">
									<select id="select1" class="form-control" onchange="visfunc()">
										<option >--请选择--</option>
										<option >指数平滑模型</option>
									    <option >LSTM模型</option>
									</select>
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 选择几次指数平滑模型的div -->
							<div class="form-group" style="display:none;" id="selectESModel">
								<label class="col-xs-3 control-label">平滑次数</label>
								<div class="col-xs-9">
									<select id="select11" class="form-control">
										<option >--请选择--</option>
										<option value="1">一次指数平滑模型</option>
										<option value="2">二次指数平滑模型</option>
										<option value="3">三次指数平滑模型</option>
									</select>
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 输入模型参数的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">模型参数</label>
								<div class="col-xs-9">
									<input type="text" name="predictValue" class="form-control"
										id="predictValue_add_input" placeholder="模型参数"> 
									<span class="help-block"></span>
								</div>
							</div>
							<div  id="nullModel" class="alert alert-info alert-dismissable">
            					<button type="button" class="close" data-dismiss="alert"
                    				aria-hidden="true">
                					&times;
            					</button>
            					1.指数平滑模型适用于短期数据的预测<br />
            					2.LSTM模型适用于长期数据的预测<br />
        					</div>
							<div  style="display:none" id="esModelKind" class="alert alert-info alert-dismissable">
            					<button type="button" class="close" data-dismiss="alert"
                    				aria-hidden="true">
                					&times;
            					</button>
            					一次指数平滑模型适用于无明显趋势的短期数据<br />
            					二次指数平滑模型适用于有线性趋势的短期数据<br />
            					三次指数平滑模型适用于有周期性趋势的短期数据<br />
        					</div>
							<div  style="display:none" id="esModel" class="alert alert-info alert-dismissable">
            					<button type="button" class="close" data-dismiss="alert"
                    				aria-hidden="true">
                					&times;
            					</button>
            					选择指数平滑模型，推荐值0.3，参数应在0-1之间。数据波动小时，应减小参数值；数据波动大时，应增加参数值
        					</div>
							<div  style="display:none" id="lstmModel" class="alert alert-info alert-dismissable">
            					<button type="button" class="close" data-dismiss="alert"
                    				aria-hidden="true">
                					&times;
            					</button>
            					选择LSTM模型，参数默认0.1。可小幅调整参数取值。
        					</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" id="predict_save_btn">保存</button>
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
		                <h4 class="modal-title" id="myModalLabel">搜索要分析的商品数据：</h4>
		            </div>
		            <div class="modal-body">
		            	<form class="form-horizontal"  id="searchForm">
							<div class="form-group">
								<label class="col-xs-3 control-label">商品名称</label>
								<div class="col-xs-9">
								    <div class="input-group">
								      <input type="text" name="saleInfName" class="form-control"
										id="saleInfName_add_input" placeholder="商品名称"> 
								      <div class="input-group-btn">
								        <button id="nameSearchButton"type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">查找 <span class="caret"></span></button>
								        <ul class="dropdown-menu dropdown-menu-right" id="nameUl">
								        
								        </ul>
								      </div><!-- /btn-group -->
									</div><!-- /input-group -->
								</div><!-- /.col-xs-9 -->
							</div><!-- /form-group -->
							<div id="alert1"class="alert alert-warning" style="display:none">
							    <a href="#" class="close" data-dismiss="alert">
							        &times;
							    </a>
							    <strong>警告！</strong>查询的商品不存在！
							    <a href="${pageContext.request.contextPath}/views/product/productInformation.jsp" > 点击这里前往添加商品</a>
							</div>
						</form>
					</div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-primary" id="searchBtn">搜索</button>
		                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		            </div>
		        </div><!-- /.modal-content -->
		    </div><!-- /.modal-dialog -->
		</div><!-- /.modal-fade -->
		
		<!-- 更改预测模态框 -->
		<div class="modal fade" id="predictChangeModal" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">修正预测模型</h4>
					</div>
					<div class="modal-body">
						<!-- 使用水平排列的表单 -->
						<form class="form-horizontal" id="predictChangeForm">
							<!-- 输入模型名称的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">模型名称</label>
								<div class="col-xs-9">
									<select id="select2" class="form-control" onchange="visfunc2()">
										<option >--请选择--</option>
										<option >指数平滑模型</option>
									    <option >LSTM模型</option>
									</select>
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 选择几次指数平滑模型的div -->
							<div class="form-group" style="display:none;" id="selectESModel2">
								<label class="col-xs-3 control-label">平滑次数</label>
								<div class="col-xs-9">
									<select id="select11" class="form-control">
										<option >--请选择--</option>
										<option value="1">一次指数平滑模型</option>
										<option value="2">二次指数平滑模型</option>
										<option value="3">三次指数平滑模型</option>
									</select>
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 输入模型参数的div -->
							<div name="dives" class="form-group">
								<label class="col-xs-3 control-label">修正参数</label>
								<div class="col-xs-9">
									<input type="text" name="smoothRatio" class="form-control"
										id="smoothRatio_change_input" placeholder="--平滑系数--"> 
									<span class="help-block"></span>
								</div>
							</div>
							<div name="divlstm" class="form-group" style="display:none">
								<label class="col-xs-3 control-label">修正参数1</label>
								<div class="col-xs-9">
									<input type="text" name="learningRatio" class="form-control"
										id="learningRatio_change_input" placeholder="--学习率--"> 
									<span class="help-block"></span>
								</div>
							</div>
							<div name="divlstm" class="form-group" style="display:none">
								<label class="col-xs-3 control-label">修正参数2</label>
								<div class="col-xs-9">
									<input type="text" name="decayRatio" class="form-control"
										id="decayRatio_change_input" placeholder="--衰减速率--"> 
									<span class="help-block"></span>
								</div>
							</div>
							<div name="divlstm" class="form-group" style="display:none">
								<label class="col-xs-3 control-label">修正参数3</label>
								<div class="col-xs-9">
									<input type="text" name="l2Ratio" class="form-control"
										id="l2Ratio_change_input" placeholder="--正则化系数--"> 
									<span class="help-block"></span>
								</div>
							</div>
							<div  id="nullModel2" class="alert alert-info alert-dismissable">
            					<button type="button" class="close" data-dismiss="alert"
                    				aria-hidden="true">
                					&times;
            					</button>
            					1.指数平滑模型适用于短期数据的预测<br />
            					2.LSTM模型适用于长期数据的预测<br />
        					</div>
        					<div  style="display:none" id="esModelKind2" class="alert alert-info alert-dismissable">
            					<button type="button" class="close" data-dismiss="alert"
                    				aria-hidden="true">
                					&times;
            					</button>
            					一次指数平滑模型适用于无明显趋势的短期数据<br />
            					二次指数平滑模型适用于有线性趋势的短期数据<br />
            					三次指数平滑模型适用于有周期性趋势的短期数据<br />
        					</div>
							<div  style="display:none" id="esModel2" class="alert alert-info alert-dismissable">
            					<button type="button" class="close" data-dismiss="alert"
                    				aria-hidden="true">
                					&times;
            					</button>
            					选择指数平滑模型，推荐值0.3，参数应在0-1之间。数据波动小时，应减小参数值；数据波动大时，应增加参数值
        					</div>
							<div  style="display:none" id="lstmModel2" class="alert alert-info alert-dismissable">
            					<button type="button" class="close" data-dismiss="alert"
                    				aria-hidden="true">
                					&times;
            					</button>
            					选择LSTM模型：<br />
            					参数1初始值0.1，应在0-1之间。<br />
            					参数2初始值0.5，应在0-1之间。<br />
            					参数3初始值0.01，应在0-0.1之间。<br />
        					</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" id="predict_change_btn">保存</button>
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 模型推荐模态框 -->
		<div class="modal fade" id="recommendModelModal" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">模型推荐</h4>
					</div>
					<div class="modal-body">
						<!-- 使用水平排列的表单 -->
						<form class="form-horizontal" id="recommendModelForm">
							<!-- 输入模型名称的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">模型名称</label>
								<div class="col-xs-9">
									<select id="select2" class="form-control" onchange="visfunc2()">
										<option >--请选择--</option>
									    <option >LSTM模型</option>
									</select>
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 筛选模型记录的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">模型记录</label>
								<div class="col-xs-7 col-xs-offset-2">
									<select id="sortSelect" class="form-control" >
										<option value="0">排序条件：默认</option>
									    <option value="1">评分</option>
									    <option value="2">使用次数</option>
									    <option value="3">上次使用时间</option>
									</select>
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 生成模型记录的div -->
							<div class="row">
								<div class="col-xs-12">
									<div class="table-responsive">
										<table class="table" id="lstmmodel_table">					
											<thead>
												<tr id="tr1">
													<!-- 表头th -->
													<th>
														<input type="checkbox" id="check_all"/>
													</th>
													<th>编号</th>
													<th>生成时间</th>
													<th>次数</th>
													<th>评分</th>
												</tr>
												<tr id="tr2" style="dispaly:none;">
													<!-- 表头th -->
													<th>
														<input type="checkbox" id="check_all"/>
													</th>
													<th>编号</th>
													<th>上次使用时间</th>
													<th>次数</th>
													<th>评分</th>
												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>
									</div>
								</div>
							</div><!-- div class="row" -->
							<!--按钮显示  -->
							<div class="col-xs-offset-7 " id="button2">
								<button class="btn btn-primary btn-sm" id="update_model_button">
									<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>编辑
								</button>
								<button class="btn btn-danger btn-sm" id="delete_model_button">
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
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" id="recommend_model_btn">保存</button>
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div>
		</div>
		
	</div><!-- div class="container" -->
	
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
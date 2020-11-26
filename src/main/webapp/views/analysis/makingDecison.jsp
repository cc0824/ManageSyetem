<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>决策助理页面</title>
<% pageContext.setAttribute("APP_PATH", request.getContextPath()); %>
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<!-- 引入 echarts.js -->
<script src="${APP_PATH }/static/js/echarts.min.js"></script>
<!-- 引入bootstrap评分插件 -->
<link href="${APP_PATH }/static/css/star-rating.min.css" media="all" rel="stylesheet" type="text/css">
<script src="${APP_PATH }/static/js/star-rating.min.js" type="text/javascript"></script>
<script type="text/javascript">
	
	function visfunc(){
		var flag=$("#select11  option:selected").val();
		console.log(flag);
		$("#infDiv").hide();
		$("#noProductId").hide();
		$("#showinf_table td").remove();
		if(flag==2){
			$("#selectProductDiv").show();
		}else{
			$("#selectProductDiv").hide();
			
		}
		$("#check_all").prop("checked",true);
		$(".check_item").prop("checked",true);
	}
	function visfunc2(){
		var flag=$("#select12  option:selected").val();
		console.log(flag);
		
		if(flag==2){
			$("#modelNumDiv").hide();
		}else{
			$("#modelNumDiv").show();
			
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
		/*********************** 点击模型推荐按钮  **********************/
		/****************************************************************/
		$("#recommend_model_button").click(function(){
			reset_form("#recommendModelModal form");
			$("#tr1").show();
			$("#tr2").hide();
			$("#decisiontreemodel_table tbody").empty();
			$("#recommendModelModal").modal({
				backdrop:"static"
			});
			
		});
		var op;
		$("#sortSelect").change(function(){
			op=$(this).find('option:selected').val(); 
			console.log(op);
			if(op!=999){
				console.log("展示模型...");
				to_page2(1);
			}
		});
		var totalRecord2,currentPage2;
		function to_page2(pn){
			if(op=="3"){
				$("#tr2").show();
				$("#tr1").hide();
			}else{
				$("#tr1").show();
				$("#tr2").hide();
			}
			
			$.ajax({
				url:"${APP_PATH}/analyze/getAllDTModelByCon.do",
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
					$("#check_all2").prop("checked",false);
				}
			});
			
		}
		function build_model_table(result){
			$("#decisiontreemodel_table tbody").empty();
			$.each(result,function(index,item){
				//创建td,如果没有就自动创建出来，append为每个元素结尾添加内容
				var checkBoxTd = $("<td></td>").append($("<input type='checkbox' class='check_item'/>").attr("model-id",item.treeModelId));
				var modelNumTd = $("<td></td>").append(item.treeModelNum);
				if(op=="3"){
					var time=item.treeModelLastTime.year+"-"+item.treeModelLastTime.monthValue+"-"+
					item.treeModelLastTime.dayOfMonth+" "+item.treeModelLastTime.hour+":"+item.treeModelLastTime.minute;
				}else{
					//debugger;
					var time=item.treeModelTime.year+"-"+item.treeModelTime.monthValue+"-"+
					item.treeModelTime.dayOfMonth+" "+item.treeModelTime.hour+":"+item.treeModelTime.minute;
				}
				var modelTimeTd = $("<td></td>").append(time);
				var modelSizeTd =$("<td></td>").append(item.treeModelSize);
				var modelStarTd =$("<td></td>").append(item.treeModelStar);
				
				$("<tr></tr>")
					.append(checkBoxTd)
					.append(modelNumTd)
					.append(modelTimeTd)
					.append(modelSizeTd)
					.append(modelStarTd)
					.appendTo("#decisiontreemodel_table tbody");

			});
		}
		var selectModelId;//选中的模型id
		var selectModelNum;
		$("#recommend_model_btn").click(function(){
			//关闭模态框
			$("#recommendModelModal").modal('hide');
			$.each($(".check_item:checked"),function(){
				//this表示被选中的元素
				selectModelNum = $(this).parents("tr").find("td:eq(1)").text();
				//alert($(this).parents("tr").find("td:eq(1)").text());
				selectModelId = $(this).attr("model-id");
			});
			console.log(selectModelId+","+selectModelNum);
			//将模型说明部分做修改
			$("#noteBody").text("综合分析当前数据，判断决策结果。当前指定决策模型编号为："+selectModelNum);
		});
		
		//编辑
// 		$("#update_model_button").click(function(){
// 			//1.重置
// 			reset_form("#treeModelUpdateModal form");
// 			//2、查出模型信息
// 			//getSelectTreeModel($(this).attr("model-id"));
// 			//3、把模型的id传递给模态框的更新按钮
// 			$("#treeModel_update_btn").attr("model-id",$(this).attr("model-id"));
// 			//弹出模态框
// 			$("#treeModelUpdateModal").modal({
// 				//backdrop:"static"
// 			});
// 		});
// 		function getSelectTreeModel(id){
// 			$.ajax({
// 				url:"${APP_PATH}/analyze/getProductById.do",
// 				data:"id="+id,
// 				type:"GET",
// 				success:function(result){
// 					//console.log(result);
// 					//拿到返回的数据
// 					var productData=result.extend.product;
// 					//给input框赋值
// 					$("#productName_update_input").val(productData.productName);
// 					$("#productCost_update_input").val(productData.productCost);
// 					$("#productPrice_update_input").val(productData.productPrice);
// 					$("#productArea_update_input").val(productData.productArea);

// 				}
// 			});
// 		}
// 		//点击修改按钮，更新商品信息
// 		$("#product_update_btn").click(function(){
// 			//1、验证输入格式
			
// 			//2、发送ajax'请求保存信息
// 			var formStr=$("#productUpdateForm").serialize();
//             //序列化中文时之所以乱码是因为.serialize()调用了encodeURLComponent方法将数据编码了
//             //原因：.serialize()自动调用了encodeURIComponent方法将数据编码了   
//             //解决方法：调用decodeURIComponent(XXX,true);将数据解码    
//             params = decodeURIComponent(formStr,true); //关键点
// 			console.log("productId="+ $("#product_update_btn").attr("edit-id")+"&"+params);
// 			$.ajax({
// 				url:"${APP_PATH}/product/updateProduct.do",
// 				type:"PUT",
// 				//contentType: "application/x-www-form-urlencoded",
// 				data:"productId="+ $("#product_update_btn").attr("edit-id")+"&"+formStr,
// 				success:function(result){
// 					//0.测试
// 					alert(result.msg);
// 					//1、关闭模态框
// 					$("#productUpdateModal").modal("hide");
// 					//2、回到该商品所在分页
// 					to_page(currentPage);
// 				},
// 				error:function(result){
// 					alert("fail");
// 				}
// 			});
// 		});

		
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
			reset_form("#predictAddModal form");
			if(selectModelNum!=null){
				//开始预测：选择指定模型、模型编号
				$("#modelNumDiv").show();
				$('#select12 option:eq(1)').attr('selected','selected');
				$("#modelNum_add_input").val(selectModelNum);
			}
			$("#infDiv").hide();
			$("#noProductId").hide();
			$("#predictAddModal").modal({
				backdrop:"static"
			});
			//动态展示下拉列表
			displaySelect();
			
		});
		
		var productId;
		var productName;
		//动态展示下拉列表
		function displaySelect(){
			//需要先输入关键词，再点击查询按钮再查数据
			$("#nameSearchButton").bind("click",function(){
				//debugger;
				var inputData=$("#productName_add_input").val();
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
								$("#productName_add_input").val(this.innerHTML);
								$("#noProductId").hide();
							});
							
						}
					},
					error:function(result){alert("fail");}
				
				});
			});
		}
		$("#alertDiv").click(function() {
			console.log("oj");
			$("#showinf_table td").remove();
			//不选择商品
			var flag=$("#select11  option:selected").val();
			if(flag==1){
				$("#infDiv").show();
				productId==null;
				to_page(1);
			}
			//选择商品，但还没选定
			else if(productId==null&&flag==2){
				$("#noProductId").show();
			}
			//选择商品，并且选定
			else if(productId!=null&&flag==2){
				$("#infDiv").show();
				to_page(1);
			}
			
			
		});
		
		//定义变量：总记录数和当前页码
		var totalRecord,currentPage;
		function to_page(pn){
			var ajaxData;
			if(productId==null){
				ajaxData="pn="+pn+"&productId="+0;
			}else{
				ajaxData="pn="+pn+"&productId="+productId;
			}
			$.ajax({
				url:"${APP_PATH}/analyze/getTreeDataSource.do",
				data:ajaxData,
				type:"GET",
				success:function(result){
					console.log(result);
					//1、解析并显示商品信息
					var infs = result.extend.pageInfo.list;
					build_data_table(infs);
					//2、解析并显示分页信息
					//build_page_info(result);
					//3、解析显示分页条数据
					//build_page_nav(result);
					$("#check_all").prop("checked",true);
				}
			});
			
		}
		//解析并显示数据源
		function build_data_table(result){
			//$("#showinf_table tbody").not("th").empty();
			$("#showinf_table td").remove();
			$.each(result,function(index,item){
				//var dataIdTd = $("<td></td>").append(index+1);
				var inboundCostTd=$("<td></td>").append(item.inboundCost);
				var inboundSizeTd=$("<td></td>").append(item.inboundSize);
				var inventorySizeTd=$("<td></td>").append(item.inventorySize);
				var salesPriceTd=$("<td></td>").append(item.salesPrice);
				var salesSizeTd=$("<td></td>").append(item.salesSize);
				$("#tr_1").append(inboundCostTd);
				$("#tr_2").append(inboundSizeTd);
				$("#tr_3").append(inventorySizeTd);
				$("#tr_4").append(salesPriceTd);
				$("#tr_5").append(salesSizeTd);
				
				if(index==2) {return false;}

			});
			var editBtn = $("<button></button>").addClass("btn btn-primary btn-xs edit_btn")
				.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("详情");
			//editBtn.attr("edit-id",item.productId);
			var buttonTd=$("<td></td>").append(editBtn);
			
			var editBtn2 = $("<button></button>").addClass("btn btn-primary btn-xs edit_btn")
				.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("详情");
			//editBtn.attr("edit-id",item.productId);
			var buttonTd2=$("<td></td>").append(editBtn2);
			
			var editBtn3 = $("<button></button>").addClass("btn btn-primary btn-xs edit_btn")
				.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("详情");
			//editBtn.attr("edit-id",item.productId);
			var buttonTd3=$("<td></td>").append(editBtn3);
			
			var editBtn4 = $("<button></button>").addClass("btn btn-primary btn-xs edit_btn")
				.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("详情");
			//editBtn.attr("edit-id",item.productId);
			var buttonTd4=$("<td></td>").append(editBtn4);
			
			var editBtn5 = $("<button></button>").addClass("btn btn-primary btn-xs edit_btn")
				.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("详情");
			//editBtn.attr("edit-id",item.productId);
			var buttonTd5=$("<td></td>").append(editBtn5);
			//debugger;
			$("#tr_1").append(buttonTd);
			$("#tr_2").append(buttonTd2);
			$("#tr_3").append(buttonTd3);
			$("#tr_4").append(buttonTd4);
			$("#tr_5").append(buttonTd5);
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
		/************************   获取决策树模型   ***********************/
		/****************************************************************/
		//生成ECharts图表 
		
		// 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main'));
// 	    myChart.setOption(option = {
// 	        tooltip: {
// 	            trigger: 'item',
// 	            triggerOn: 'mousemove'
// 	        },
// 	        series:[
// 	            {
// 	                type: 'tree',
// 	                data: [
	                	
// 	                ],
	
// 	                left: '2%',//到上下左右边框的距离
// 	                right: '2%',
// 	                top: '8%',
// 	                bottom: '20%',
	
// 	                symbol: 'emptyCircle',//点击节点可以折叠子树
// 	                orient: 'vertical',//horizontal，纵向/横向布局
// 	                expandAndCollapse: true,
// 	                symbolSize: [15,15],   //节点标记的大小，默认7，可以设置成单一数字，也可以指定长宽：[20,20]
	
// 	                label: { //每个节点所对应的标签的样式
// 	                    rotate: 0,//旋转
// 	                    verticalAlign: 'middle',//文字垂直对齐方式
// 	                    align: 'right',//文字水平对齐方式，默认自动。可选：top，center，bottom
// 	                    fontSize: 15
	                    
// 	                },
	
// 	                leaves: {  //叶子节点的特殊配置
// 	                    label: {
// 	                        position: 'bottom',
// 	                        rotate: -90,
// 	                        verticalAlign: 'middle',
// 	                        align: 'left'
// 	                    }
// 	                },
	
// 	                animationDurationUpdate: 750 //数据更新动画的时长
// 	            }
// 	        ]
// 		});
	    
		//选择决策因素
		//完成全选/全不选功能
		$("#check_all").click(function(){
			//attr获取checked是undefined;用prop修改和读取dom原生属性的值
			//$(this).prop("checked")获取全选按钮的选中状态
			$(".check_item").prop("checked",$(this).prop("checked"));
		});
		
		//每页的单选框都被选中后，全选按钮也被选中
		$(document).on("click",".check_item",function(){
			var flag = $(".check_item:checked").length==$(".check_item").length;
			$("#check_all").prop("checked",flag);
		})
		//动态展示下拉列表
		//需要先输入关键词，再点击查询按钮再查数据
		$("#numSearchButton").bind("click",function(){
			//debugger;
			var inputData=$("#modelNum_add_input").val();
			console.log(inputData);
			//每次点击查找都要清除上次展示的数据
			$("#nameUl2").empty();
			$.ajax({
				url:"${APP_PATH}/analyze/getAllDTModelByCon2.do",
				data:{"inputData":inputData,"kind":"0"},
				type:"GET",
				success:function(result){
					console.log(result);
					//输入的模型名称关键词找不到匹配的商品
					if(result.extend.models.length==0){
						$("#numUl2").empty();
						//不展示下拉列表
						$("#numSearchButton").dropdown('toggle');
						//展示提示框
						//$("#alert12").show();
					}else{
						//$("#alert12").hide();
						$("#numUl2").empty();
						//生成下拉列表
						$.each(result.extend.models,function(index,item){ 
							var getLi=$("<li></li>").append($("<a></a>").attr("modelid",item.treeModelId).attr("modelnum","selectLLi2").append(item.treeModelNum));
							$("#numUl2").append(getLi);
						});
						//选中li
						$("[modelnum='selectLLi2']").bind("click",function(){
							console.log("选中id"+this.id);
							console.log("选中值"+this.innerHTML);
							selectModelId=this.id;
							selectModelNum=this.innerHTML;
							$("#modelNum_add_input").val(this.innerHTML);
							//$("#noModelNumId2").hide();
						});
						
					}
				},
				error:function(result){alert("fail");}
			
			});
		});
		
		//点击保存按钮
		$("#predict_save_btn").click(function() {
			//是否选则商品
			var flag1=$("#select11  option:selected").val();
			console.log("是否要选择商品：1不选，2选--"+flag1);
			if(flag1==2&&productId==null){
				$("#noProductId").show();
			}else{
				console.log("如果选中商品：null未选择，数字选--"+productId);
				//选中因素
				var checkedInput="";
				var test2=[];
				for(var i=0;i<$(".check_item").length;i++){
					if($(".check_item")[i].checked==true){
						checkedInput=checkedInput+"&cI["+i+"]="+$(".check_item")[i].id;
						test2.push($(".check_item")[i].id);
					}
				}
				console.log(checkedInput);
				//var ajaxData="flag="+flag1+"&productId="+productId+checkedInput;
				var ajaxData="flag="+flag1+"&productId="+productId+"&test2="+test2;
				console.log(ajaxData);
				$("#predictAddModal").modal("hide");
				myChart.showLoading();
				
				$.ajax({
					url: "${APP_PATH }/analyze/makingDecision.do",
					type: "GET",
					data: ajaxData,
					success : function(result) {
						//console.log(result);
						myChart.hideLoading();
						//异步加载echarts数据
						var data=result.extend.result;
						selectModelId=data[2];
						seriesData=data[1];
						console.log(data);
						var mydata={"children":[{"children":[],"name":"判断条件：feature 2 <= 2.60，属于类型：0.0"},{"children":[{"children":[],"name":"判断条件：feature 2 <= 4.85，属于类型：2.0"},{"children":[],"name":"判断条件：feature 2 > 4.85，属于类型：1.0"}],"name":"判断条件：feature 2 > 2.60"}],"name":"当前模型编号为dtc_f8c225833485，参与判断的属性共有5个，最多经过2次判断。"};
						
						$("#starRow").show();
						myChart.setOption(option = {
						       
								tooltip: {
					 		    	trigger: 'item',
				 		            triggerOn: 'mousemove',
				 		            position: 'top',
				 		            formatter: function(value) { 
				                		var str="";
				                      	//debugger;
				                      	if(value.dataIndex==1) return "模型说明";
				                	  	if(typeof value !== 'string'){
				                			str = value.data.name.toString();
				                		}
				                      	var splits=str.split("，");
				                      	var res="";
				                      	if(splits.length==2){
				                      		res=splits[0]+"<br/>"+splits[1];
				                      	}else{
				                      		res=splits[0];
				                      	}
				                      	return res;  
				 		            }
				 		        },
				 		        legend: {
				 		            data:['属性'],
				 		            orient: 'vertical',
						            x:'right',      //可设定图例在左、右、居中
						            y:'top',     //可设定图例在上、下、居中
						            padding:[0,0,0,0], 
				 		        },
				 		        series:[{
					            	type: 'tree',
					            	name: '属性',
					                data: [mydata],

					                left: '2%',//到上下左右边框的距离
					                right: '2%',
					                top: '8%',
					                bottom: '20%',

					                symbol: 'emptyCircle',//点击节点可以折叠子树
					                orient: 'vertical',//horizontal，纵向/横向布局
					                expandAndCollapse: false,
					                symbolSize: [15,15],   //节点标记的大小，默认7，可以设置成单一数字，也可以指定长宽：[20,20]

					                label: { //每个节点所对应的标签的样式
					                	position: 'top',
					                    rotate: 0,//旋转
					                    verticalAlign: 'bottom',//文字垂直对齐方式
					                    align: 'center',//文字水平对齐方式，默认自动。可选：top，center，bottom
					                    fontSize: 15,
					                    distance: 5,
					                   	formatter:function(value) { 
					                		var str="";
					                      	//debugger;
					                      	if(value.dataIndex==1) return "模型说明";
					                	  	if(typeof value !== 'string'){
					                			str = value.data.name.toString();
					                		}
					                      	var splits=str.split("，");
					                      	var res="";
					                      	if(splits.length==2){
					                      		temp=splits[1].split("：");
					                      		res=temp[1];
					                      		//res=temp[0]+"："+"<br/>"+temp[1];
					                      	}
					                      	return res;  
					                  	}
					                  	
					                },

					                leaves: {  //叶子节点的特殊配置
					                    label: {
					                        position: 'bottom',
					                        //rotate: -90,
					                        verticalAlign: 'top',
					                        align: 'middle',
					                        distance: 5
					                    }
					                },

					                animationDurationUpdate: 750 //数据更新动画的时长
				 		        }]
						});//setOption
					}
				});
			}
			
			
			//showinf_table
			//{"children":[{"children":[],"name":"判断条件：feature 2 <= 2.5999999999999996，属于类型：0.0"},{"children":[{"children":[],"name":"判断条件：feature 2 <= 4.85，属于类型：2.0"},{"children":[],"name":"判断条件：feature 2 > 4.85，属于类型：1.0"}],"name":"判断条件：feature 2 > 2.5999999999999996"}],"name":"当前模型编号为dtc_f8c225833485，参与判断的属性共有5个，最多经过2次判断。"}
			
		});
		

		/****************************************************************/
		/**********************   打分插件    **************************/
		/****************************************************************/
		$('.rb-rating').rating({
            'showCaption': false,//是否显示打分文字
            'showClear': false,//是否显示清除按钮
            'stars': '5',
            'min': '0',
            'max': '5',
            'step': '1',
            'size': 'xs',
            'starCaptions': {
            	0: 'status:nix', 
            	1: 'status:wackelt', 
            	2: 'status:geht', 
            	3: 'status:laeuft'
            }//自定义打分文字
        });
		var curStar;
		$("#check_star_button").click(function(){
			width=$(".filled-stars").css("width");
			curStar=parseInt(width)/34;
			console.log("treeModelId="+selectModelId+"&treeModelStar="+curStar);
			$("#starRow").css("display","none");
			var ajaxdata;
			if(treeModelId==null){
				ajaxdata="treeModelStar="+curStar;
			}
			else{
				ajaxdata="treeModelId="+selectModelId+"&treeModelStar="+curStar;
			}
			$.ajax({
				url:"${APP_PATH}/analyze/updateDTModelStar.do",
				data:ajaxdata,
				type:"PUT",
				success:function(result){
					console.log(result);
				}
			});
			
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
#showinf_table th,td{text-align:center}
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
			<a  href="#"  style="font-size:18px;font-color:rgb(51,122,183)">智能决策</a>
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
		<!-- 预测信息展示 -->
		<div class="jumbotron" style="padding: 15px 15px;">
			<div  id="main" style="width: 80%;height:350px ;margin: 0 auto">
			</div>
		</div><!--div class="row"  -->
		
		
		<!-- 打分说明 -->
		<div class="row" id="starRow" style="display: none;">
			<div class="panel panel-info" style="width:80%;margin: 0 auto">
		  		<div class="panel-heading">
		    	<h3 class="panel-title">对当前模型是否满意？</h3>
		  		</div>
		  		<div class="panel-body" id="starBody">
		  			<div style="width:70%;float:left;">
						<input required class="rb-rating" type="text" value="" title="">
					</div>
		  			<div style="width:30%;float:right;padding-top: 5px;padding-bottom: 5px">
			    		<button class="btn btn-info btn-sm" id="check_star_button">
							<span class="glyphicon glyphicon-star" aria-hidden="true"></span>确认
						</button>
					</div>
		  		</div>
			</div>
		</div><!--div class="row"  -->
		
		<!-- 模型说明 -->
		<div class="row" >
			<div class="panel panel-info" style="width:80%;margin: 0 auto">
		  		<div class="panel-heading">
		    	<h3 class="panel-title">决策说明：</h3>
		  		</div>
		  		<div class="panel-body" id="noteBody">
		    		综合分析当前数据，判断决策结果。当前未指定决策模型！</br>
		  		</div>
			</div>
		</div><!--div class="row"  -->
		
		<!--按钮显示  -->
		<div class="col-xs-offset-2 col-xs-10 " id="button2" style="margin-top:15px">
			<button class="btn btn-primary btn-sm" id="start_predict_button">
				<span class="glyphicon glyphicon-equalizer" aria-hidden="true"></span>开始预测
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
						<h4 class="modal-title" id="myModalLabel">智能决策模型</h4>
					</div>
					<div class="modal-body">
						<!-- 使用水平排列的表单 -->
						<form class="form-horizontal" id="predictAddForm">
							<!-- 是否使用当前指定的模型 -->
							<div class="form-group">
								<label class="col-xs-3 control-label">指定模型</label>
								<div class="col-xs-9">
									<select id="select12" class="form-control" onchange="visfunc2()">
										<option value="2">--不指定模型--</option>
										<option value="1">--指定模型--</option>
									</select>
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 输入模型编号的div -->
							<div class="form-group" style="display: none;" id="modelNumDiv">
								<label class="col-xs-3 control-label">模型编号</label>
								<div class="col-xs-9">
<!-- 									<select  class="form-control" > -->
<!-- 										<option value="1">--TreeModel001--</option> -->
<!-- 										<option value="2">--不指定模型--</option> -->
<!-- 									</select> -->
<!-- 									<span class="help-block"></span> -->
									<div class="input-group">
								      <input type="text" name="modelNum" class="form-control"
										id="modelNum_add_input" placeholder="模型编号"> 
								      <div class="input-group-btn">
								        <button id="numSearchButton"type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">查找 <span class="caret"></span></button>
								        <ul class="dropdown-menu dropdown-menu-right" id="numUl2">
								        
								        </ul>
								      </div><!-- /btn-group -->
									</div><!-- /input-group -->
								</div>
							</div>
							
							<!-- 是否指定商品 -->
							<div class="form-group">
								<label class="col-xs-3 control-label">决策范围</label>
								<div class="col-xs-9">
									<select id="select11" class="form-control" onchange="visfunc()">
										<option >--请选择--</option>
										<option value="1">不指定商品</option>
										<option value="2">指定商品</option>
									</select>
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 输入模型名称的div -->
							<div class="form-group" style="display: none;" id="selectProductDiv">
								<label class="col-xs-3 control-label">商品名称</label>
								<div class="col-xs-9">
								    <div class="input-group">
								      <input type="text" name="productName" class="form-control"
										id="productName_add_input" placeholder="商品名称"> 
								      <div class="input-group-btn">
								        <button id="nameSearchButton"type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">查找 <span class="caret"></span></button>
								        <ul class="dropdown-menu dropdown-menu-right" id="nameUl">
								        
								        </ul>
								      </div><!-- /btn-group -->
									</div><!-- /input-group -->
								</div><!-- /.col-xs-9 -->
							</div>
							
							<div  id="noProductId" class="alert alert-warning alert-dismissable" style="display:none;">
            					<button type="button" class="close" data-dismiss="alert"
                    				aria-hidden="true">
                					&times;
            					</button>
            					请先选择商品！
        					</div>
							<div  id="alertDiv" class="alert alert-info alert-dismissable">
            					<button type="button" class="close" data-dismiss="alert"
                    				aria-hidden="true">
                					&times;
            					</button>
            					请点击蓝色区域，选择需要考虑的因素
        					</div>
        					
        					<div class="row" id="infDiv" style="display:node;">
								<div class="col-xs-12">
									<div class="table-responsive">
										<table class="table" id="showinf_table">					
											<thead>
												<tr >
													<!-- 表头th -->
													<th>
														<input type="checkbox" id="check_all" />
													</th>
													<th>因素选择</th>
													<th colspan="3">数据展示 </th>
													<th>操作</th>
												</tr>
											</thead>
											<tbody>
												<tr id="tr_1">
													<th>
													<input type="checkbox" id="check1" checked class='check_item'/>
													</th>
         											<th>进货价</th>
         										</tr>
												<tr id="tr_2">
													<th>
													<input type="checkbox" id="check2" checked class='check_item'/>
													</th>
         											<th>进货量</th>
         										</tr>
												<tr id="tr_3">
													<th>
													<input type="checkbox" id="check3" checked class='check_item'/>
													</th>
         											<th>库存量</th>
         										</tr>
												<tr id="tr_4">
													<th>
													<input type="checkbox" id="check4" checked class='check_item'/>
													</th>
         											<th>销售价</th>
         										</tr>
												<tr id="tr_5">
													<th>
													<input type="checkbox" id="check5" checked class='check_item'/>
													</th>
         											<th>销售量</th>
         										</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div><!-- div class="row" -->
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
						<button type="button" class="btn btn-primary" id="predict_save_btn">保存</button>
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
									<select id="select2" class="form-control" >
										<option >--请选择模型--</option>
									    <option >决策树模型</option>
									</select>
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 筛选模型记录的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">模型记录</label>
								<div class="col-xs-7 col-xs-offset-2">
									<select id="sortSelect" class="form-control" >
										<option value="999">--请选择排序条件--</option>
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
										<table class="table" id="decisiontreemodel_table">					
											<thead>
												<tr id="tr1">
													<!-- 表头th -->
													<th>
														<input type="checkbox" id="check_all2"/>
													</th>
													<th>编号</th>
													<th>生成时间</th>
													<th>次数</th>
													<th>评分</th>
												</tr>
												<tr id="tr2" style="dispaly:none;">
													<!-- 表头th -->
													<th>
														<input type="checkbox" id="check_all2"/>
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
		
		<!-- 模型修改的模态框 -->
		<div class="modal fade" id="treeModelUpdateModal" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel2">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="myModalLabel2">修改商品信息</h4>
					</div>
					<div class="modal-body">
						<!-- 使用水平排列的表单 -->
						<form class="form-horizontal" id="treeModelUpdateForm" >
							<div class="form-group">
								<label class="col-xs-3 control-label">模型编号</label>
								<div class="col-xs-9">
 									<input type="text" name="treeModelNum" class="form-control"
										id="treeModelNum_update_input" placeholder="模型编号">
									<span class="help-block"></span>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-3 control-label">生成时间</label>
								<div class="col-xs-9">
 									<input type="text" name="treeModelTime" class="form-control"
										id="treeModelTime_update_input" placeholder="生成时间">
									<span class="help-block"></span>
								</div>
							</div>
							
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" id="treeModel_update_btn">修改</button>
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
				<a href="${pageContext.request.contextPath}/views/mainHome.jsp">首页 </a>
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
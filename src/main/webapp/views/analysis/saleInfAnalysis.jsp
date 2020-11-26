<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>智能分析页面</title>
<% pageContext.setAttribute("APP_PATH", request.getContextPath()); %>
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="${APP_PATH }/static/js/jquery.actual.js"></script>
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<!-- 引入 echarts.js -->
<script src="${APP_PATH }/static/js/echarts.min.js"></script>
<!-- js自动补全 -->
<script src="${APP_PATH }/static/js/plumen.js"></script>
<script type="text/javascript">
	
	$(function() {
		
		/****************************************************************/
		/*******************调整顶部导航栏按钮的margin  *******************/
		/****************************************************************/
		var width=document.body.clientWidth;
		var a=(width-232-2*10)/2;
		console.log("a="+a+'px');
		$("#topNavbarLeftButton").css({"margin-right":a+'px'});
		$("#topNavbarRightButton").css({"margin-left":a+'px'});
		//调整底部导航栏按钮的margin
		var b=(width-310-2*10)/2;
		//console.log("b="+b+'px');
		$("#bottomNavbarLeftButton").css({"margin-right":b+'px'});
		$("#bottomNavbarRightButton").css({"margin-left":b+'px'});
		
		
		/****************************************************************/
		/***********************  选择要分析的商品   ***********************/
		/****************************************************************/
		var searchData;
		var productId;
		var productName;

		//定义变量：总记录数、当前页码、共几页
		var totalRecord,currentPage,totalPage;
		
		
		//点击搜索按钮，弹出搜索框
		$(document).on("click","#searchButton",function(){
			//清除表单数据（表单完整重置（表单的数据，表单的样式））
			reset_form("#searchModal form");
			//弹出模态框
			$("#searchModal").modal({
				backdrop:"static"
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
				//console.log(inputData);
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
							//展示提示框
							$("#alert1").show();
							//不展示下拉列表
							$("#nameSearchButton").dropdown('toggle');
						}else{
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
							
							//清空表格
							$("#product_table tbody").empty();
							$("#productPrice_table tbody").empty();
							//关闭模态框
							$("#searchModal").modal('hide');
							//默认不显示没有销售信息的提示框
							$("#noSaleAlert").hide();
							//跳转到首页
							to_page(1);
						}
					},
					error:function(result){alert("fail");}
				
				});
			}else{
				//清空表格
				$("#product_table tbody").empty();
				$("#productPrice_table tbody").empty();
				//关闭模态框
				$("#searchModal").modal('hide');
				//默认不显示没有销售信息的提示框
				$("#noSaleAlert").hide();
				//跳转到首页
				to_page(1);
			}
		});
		
		
		/****************************************************************/
		/*******************   异步将数据图形化展示    **********************/
		/****************************************************************/
		$("#change_data_button").click(function(){
			//console.log(seriesData);
			//弹出图表化数据的模态框
			$("#changeDataModal").modal({
				backdrop:"static"
			});
		});
		//移除之前的echarts实例
		document.getElementById('main').removeAttribute('_echarts_instance_');
		// 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main'));
		//获取隐藏元素的div宽度
		var myChartWidth=parseInt($("#EchartHeader").actual('outerWidth')*0.9)+"px";
		console.log(myChartWidth);
		myChart.resize({height:"300px"});
		myChart.resize({width:myChartWidth});
 		$("#main div").css("margin","0 auto");
		// 指定图表的配置项和数据
		xData=[ ];
		seriesData=[ ];
		var predictData=[];
		myChart.setOption({
			//直角坐标系定位
			grid:{
				left:'10%',
				right:'10%'
			},
			//提示框组件
			tooltip: {
		        trigger: 'axis',//没有此触发，则下面的样式无效
		        position: function (pt) {//提示框位置，不设置是跟随鼠标位置
		            return [pt[0], '10%'];
		        }
		    },
		    //标题
		    title: {
		        left: 'center',
		        text: '销售数据'
		    },
	        //工具栏组件
			toolbox: {
		        feature: {
		            dataZoom: {
		                yAxisIndex: 'none' //数据区域缩放
		            },
		            restore: {},//配置项还原
		            saveAsImage: {}//保存为图片
		        }
		    },
		    xAxis: {
		        type: 'category',//适用于离散的类目数据
		        boundaryGap: false,//坐标轴两边留白策略
		        data: []
		    },
		    yAxis: {
		        type: 'value',//适用于连续数据
		        boundaryGap: [0, '100%']//分别表示数据最小值和最大值的延伸范围
		    },
		 	//这个dataZoom组件，若未设置xAxisIndex或yAxisIndex，则默认控制x轴。
	        dataZoom: [{
	        	id: 'dataZoomX1',
	            type: 'inside',//inside能在坐标系内进行拖动，以及用滚轮（或移动触屏上的两指滑动）进行缩放
	            xAxisIndex: 0, //控制x轴
	            start: 90,//数据窗口范围的起始、结束百分比
	            end: 100
	        }, {
	        	id: 'dataZoomX2',
	        	type: 'slider',//slider只能拖动 dataZoom 组件导致窗口变化
	        	xAxisIndex: 0, //控制x轴
	        	start: 90,
	            end: 100,
	            handleIcon: 'M10.7,11.9v-1.3H9.3v1.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4v1.3h1.3v-1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
	            handleSize: '80%',
	            handleStyle: {
	                color: '#fff',
	                shadowBlur: 3,
	                shadowColor: 'rgba(0, 0, 0, 0.6)',
	                shadowOffsetX: 2,
	                shadowOffsetY: 2
	            }
	        }],
		    series: [{
	            name: '销量',
	            type: 'line',
	            smooth: true,
	            symbol: 'none',
	            sampling: 'average',
	            itemStyle: {
	                color: 'rgb(255, 70, 131)'
	            },
	            areaStyle: {
	                color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
	                    offset: 0,
	                    color: 'rgb(255, 158, 68)'
	                }, {
	                    offset: 1,
	                    color: 'rgb(255, 70, 131)'
	                }])
	            },
	            data: []
	        }]
	    });
		
		

		/****************************************************************/
		/****************** 商品信息、历史价格、销量信息表 *****************/
		/****************************************************************/
		//跳转页面函数		
		function to_page(pn){
			var pnAndId;
			if(productId==null){
				pnAndId="pn="+pn;
			}else{
				pnAndId="pn="+pn+"&id="+productId;
			}
			//alert("ajax="+productId);
			$.ajax({
				url:"${APP_PATH}/analyze/displaySelectProduct.do",
				data:pnAndId,
				type:"GET",
				success:function(result){
					//console.log("查询结果");
					console.log(result);
					//1、解析并显示商品信息
					build_product_table(result.extend.pageInfo.list[0].product);
					if(result.extend.pageInfo.list[0].salesPrice==null
							&&result.extend.pageInfo.list[0].salesSize==null) {
						//跳转
						var url="${APP_PATH}/views/sales/salesInfAddManagement.jsp?productId="+productId
						//console.log(url);
						$("#addSaleHref").attr("href",url);
						$("#noSaleAlert").show();
						//2、解析并显示销售信息，为表赋值0
						$("#productPrice_table tbody").empty();
						var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
						var salesPriceTd = $("<td></td>").append("0.0");
						var salesSizeTd = $("<td></td>").append("0");
							
						//创建tr
						//append方法执行完成以后还是返回原来的元素，每次append返回tr再继续append
						$("<tr></tr>").append(checkBoxTd)
							.append(salesPriceTd)
							.append(salesSizeTd)
							.appendTo("#productPrice_table tbody");
						//3、解析并显示分页信息
						build_page_info(result);
						//4、解析显示分页条数据
						build_page_nav(result);
						$("#check_all").prop("checked",false);
					}else{
						//debugger;
						//1、生成图表的数据
						build_echarts();
						//2、解析并显示销售信息
						build_sale_table(result);
						//3、解析并显示分页信息
						build_page_info(result);
						//4、解析显示分页条数据
						build_page_nav(result);
						$("#check_all").prop("checked",false);
						
						// 通过 setTimeout 模拟异步加载，确保一定是xData被赋值后才更新echarts
					    setTimeout(function () {
					    	console.log(xData);
							console.log(seriesData);
							myChart.setOption({
						 		xAxis: {
						            data: xData//xData["1","2","3"]
						        },
						        series: [{
						            // 根据名字对应到相应的系列
						            name: '销量',
						            data: seriesData//seriesData["10","20","30"]
						        }]
						    })
					    }, 1000);
					}
				}
			});
		}
		
		var tem="";
		//生成图表的数据
		function build_echarts(){
			//debugger;
			$.ajax({
				url:"${APP_PATH}/sales/getSelectProductAllSaleInfByProductId.do",
				data:"productId="+productId,
				type:"GET",
				success:function(result2){
					var saleList=result2.extend.salelist;
					predictData=saleList;
					console.log(saleList);
					$.each(saleList,function(index,item){
						//debugger;
						//console.log("index="+index+",item="+item.salesSize);
						var temp=parse_time(item.salesTime);
						if(temp==null){
							xData.push("0");
						}else{
							xData.push(temp.toString());
						}
						seriesData.push(item.salesSize.toString());
					});
					console.log(xData);
					console.log(seriesData);
				}
			});
		}
		
		//解析并显示商品信息函数
		function build_product_table(result){
			$("#product_table tbody").empty();
			var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
			var productIdTd = $("<td></td>").append(result.productId);
			var productNameTd = $("<td></td>").append(result.productName);
			var productAreaTd = $("<td></td>").append(result.productArea);
			
			//创建编辑按钮
			var editBtn = $("<button></button>").addClass("btn btn-primary btn-xs edit_btn")
							.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
			//为编辑按钮添加一个自定义的属性来表示当前商品id
			editBtn.attr("edit-id",result.productId);
			//创建删除按钮
			var delBtn = $("<button></button>").addClass("btn btn-danger btn-xs delete_btn")
							.append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
			//为删除按钮添加一个自定义的属性来表示当前删除的员工id
			delBtn.attr("del-id",result.productId);
			//把两个按钮创建到一个单元格
			var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
			
						
			//创建tr
			//append方法执行完成以后还是返回原来的元素，每次append返回tr再继续append
			$("<tr></tr>").append(checkBoxTd)
				.append(productIdTd)
				.append(productNameTd)
				.append(productAreaTd)
				.append(btnTd)
				.appendTo("#product_table tbody");
		}
		//解析日期格式{year:2020,month:"MARCH",dayOfMonth:1}
		function parse_time(result){
			if(result==null) return null;
			var temp="";
			var month="";
			switch(result.month.toLowerCase()){
				case "january" : {month="01"; break;}
				case "february" : {month="02"; break;}
				case "march" : {month="03"; break;}
				case "april" : {month="04"; break;}
				case "may" : {month="05"; break;}
				case "june" : {month="06"; break;}
				case "july" : {month="07"; break;}
				case "august" : {month="08"; break;}
				case "september" : {month="09"; break;}
				case "october" : {month="10"; break;}
				case "november" : {month="11"; break;}
				case "december" : {month="12"; break;}
			}
			temp=result.year+"-"+month+"-"+result.dayOfMonth;
			return temp;
		}
		//解析并显示指定商品的销售信息
		function build_sale_table(result){
			//每次跳转页面都要先清空table表格
			$("#productPrice_table tbody").empty();
			$.each(result.extend.pageInfo.list,function(index,item){
				//console.log(item.salesTime);
				//创建td,如果没有就自动创建出来，append为每个元素结尾添加内容
				var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
				var salesPriceTd = $("<td></td>").append(item.salesPrice);
				var salesSizeTd = $("<td></td>").append(item.salesSize);
				
				//解析日期格式{year:2020,month:"MARCH",dayOfMonth:1}
				var time=parse_time(item.salesTime);
				var salesTimeTd = $("<td></td>").append(time);
				
				//创建销售详情按钮
				var sdetailBtn = $("<button></button>").addClass("btn btn-primary btn-xs detail_btn")
								.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("销售详情");
				//为编辑按钮添加一个自定义的属性来表示当前商品id
				sdetailBtn.attr("sdetail-id",item.salesId);
				//把按钮创建到一个单元格
				var btnTd = $("<td></td>").append(sdetailBtn);
				
				//创建tr
				//append方法执行完成以后还是返回原来的元素，每次append返回tr再继续append
				$("<tr></tr>").append(checkBoxTd)
					.append(salesPriceTd)
					.append(salesSizeTd)
					.append(salesTimeTd)
					.append(btnTd)
					.appendTo("#productPrice_table tbody");

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
		/*************** 修改商品、删除商品、查看销售详情  ******************/
		/****************************************************************/
		
		//修改
		$(document).on("click",".edit_btn",function(){ 
			reset_form("#productUpdateModal form");
			//1、查出商品信息
			getSelectProduct($(this).attr("edit-id"));			
			//2、把商品的id传递给模态框的更新按钮
			$("#product_update_btn").attr("edit-id",$(this).attr("edit-id"));
			$("#productUpdateModal").modal({
				backdrop:"static"
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
			//console.log("productId="+ $("#product_update_btn").attr("edit-id")+"&"+params);
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
			//console.log(productId);
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
		
		//查看并修改销售详情
		$(document).on("click",".detail_btn",function(){ 
			//1、清空模态框
			reset_form("#saleDetailModal form");
			//2、查出销售详情
			getSelectSaleInf($(this).attr("sdetail-id"));			
			//3、把销售详情的id传递给模态框的更新按钮
			$("#saleDetail_update_btn").attr("sdetail-id",$(this).attr("sdetail-id"));
			//4、弹出模态框
			$("#saleDetailModal").modal({
				backdrop:"static"
			});
		});
		
		function getSelectSaleInf(id){
			$.ajax({
				url:"${APP_PATH}/sales/getSelectProductSaleInfBySalesId.do",
				data:"salesId="+id,
				type:"GET",
				success:function(result){
					console.log(result);
					//拿到返回的数据
					var saleData=result.extend.saleInfo;
					//给input框赋值
					$("#salesPrice_detail_input").val(saleData.salesPrice);
					$("#salesSize_detail_input").val(saleData.salesSize);

				}
			});
		}
		
		//点击修改按钮，更新商品销售信息
		$("#saleDetail_update_btn").click(function(){
			var formStr=$("#saleDetailForm").serialize();
			$.ajax({
				url:"${APP_PATH}/sales/updateSaleInf.do",
				type:"PUT",
				data:"salesId="+ $("#saleDetail_update_btn").attr("sdetail-id")+"&"+formStr,
				success:function(result){
					//0.测试
					alert(result.msg);
					//1、关闭模态框
					$("#saleDetailModal").modal("hide");
					//2、回到该商品所在分页
					to_page(currentPage);
				},
				error:function(result){
					alert("fail");
				}
			});
		});
		
		//删除销售详情

		
		
		
		/****************************************************************/
		/******************* 点击预测按钮进行数据预测 **********************/
		/****************************************************************/
		$("#predict_data_button").click(function(){
			window.location.href="${APP_PATH}/views/analysis/dataPrediction.jsp?pId="+productId+"&pName="+productName;
			
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
	<nav class="navbar navbar-default navbar-fixed-top" >
	<div class="container-fluid" >
		<div class="navbar-header" style="text-align:center;">
			<button type="button" class="btn btn-default btn-lg" onclick="javascript:history.back(-1)" id="topNavbarLeftButton">
        		<span class="glyphicon glyphicon-arrow-left"></span>
    		</button>
			<a  href="#"  style="font-size:18px;font-color:rgb(51,122,183)">智能分析</a>
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
				<label  >商品售价信息</label>

				<button type="button" class="btn btn-info btn-sm col-xs-offset-7" id="searchButton">
					<span class="glyphicon glyphicon-search" aria-hidden="true"></span> 选择商品
				</button>
			</div>
		</div>
		<div><label></label></div>
		<!-- 商品售价信息展示 -->
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
								<th>id</th>
								<th>名称</th>
								<th>产地</th>
								<th>操作</th>
							</tr>
						</thead>


						<tbody>
							
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-xs-12">
				<div class="table-responsive">
					<table class="table" id="productPrice_table">					
						<thead>
							<tr>
								<!-- 表头th -->
								<th>
									<input type="checkbox" id="check_all"/>
								</th>
								<th>售价</th>
								<th>销量</th>
								<th>日期</th>
								<th>操作</th>
							</tr>
						</thead>


						<tbody>
							
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<!--警告显示  -->
		<div class="alert alert-info alert-dismissable" id="noSaleAlert" style="display: none;">
            <button type="button" class="close" data-dismiss="alert"
                    aria-hidden="true">
                &times;
            </button>
            	当前商品暂无销售信息！
            <a href="#" id="addSaleHref"
            	 style="color: #31708F" class="alert-link">————> 前往添加销售信息</a>
						
        </div>
		<div class="alert alert-info alert-dismissable" id="addSaleAlert" style="display: none;">
            <button type="button" class="close" data-dismiss="alert"
                    aria-hidden="true">
                &times;
            </button>
            <a href="#" id="addSaleHref"
            	 style="color: #31708F" class="alert-link">————> 前往添加销售信息</a>
        </div>
		<!--按钮显示  -->
		<div class="col-xs-offset-5 " id="button2">
			<button class="btn btn-primary btn-sm" id="change_data_button">
				<span class="glyphicon glyphicon-signal" aria-hidden="true"></span>图表
			</button>
			<button class="btn btn-success btn-sm" id="predict_data_button">
				<span class="glyphicon glyphicon-equalizer" aria-hidden="true"></span>预测
			</button>
			<button class="btn btn-danger btn-sm" id="delete_data_button">
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
				</div><!-- /.modal-content -->
			</div><!-- /.modal-divlog -->
		</div><!-- /.modal-fade -->
		
		<!-- 销售详情的模态框 -->
		<div class="modal fade" id="saleDetailModal" tabindex="-1"
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
						<form class="form-horizontal" id="saleDetailForm" >
							<!-- 修改售价的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">商品售价</label>
								<div class="col-xs-9">
									<!-- 不想让商品信息被修改  将input替换成静态控件 -->
 									<input type="text" name="salesPrice" class="form-control"
										id="salesPrice_detail_input" placeholder="商品售价">
									<span class="help-block"></span>
								</div>
							</div>
							<!-- 修改销量的div -->
							<div class="form-group">
								<label class="col-xs-3 control-label">商品销量</label>
								<div class="col-xs-9">
									<!-- 不想让商品信息被修改  将input替换成静态控件 -->
 									<input type="text" name="salesSize" class="form-control"
										id="salesSize_detail_input" placeholder="商品销量">
									<span class="help-block"></span>
								</div>
							</div>

						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" id="saleDetail_update_btn">修改</button>
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-divlog -->
		</div><!-- /.modal-fade -->
		
		<!-- 图形化数据的模态框 -->
		<div class="modal fade" id="changeDataModal" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header" id="EchartHeader">
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">图形化数据信息</h4>
					</div>
					<div class="modal-body">
						<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
<!--     					<div id="main" style="width:300px;height:200px"></div> -->
    					<div id="main" ></div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" id="xxx">保存</button>
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
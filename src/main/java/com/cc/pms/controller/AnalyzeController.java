package com.cc.pms.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.cc.pms.bean.DailyData;
import com.cc.pms.bean.LSTMModel;
import com.cc.pms.bean.LSTMModelRecord;
import com.cc.pms.bean.Msg;
import com.cc.pms.bean.Product;
import com.cc.pms.bean.ProductPriceSale;
import com.cc.pms.bean.SaleInf;
import com.cc.pms.bean.TreeModel;
import com.cc.pms.bean.TreeModelData;
import com.cc.pms.component.LogAnnotation;
import com.cc.pms.service.AnalyzeService;
import com.cc.pms.service.ProductService;
import com.cc.pms.service.SalesService;
import com.cc.pms.utils.clustertUtil.KMeansCluster1;
import com.cc.pms.utils.decisionTreeUtil.LoadDataUtil;
import com.cc.pms.utils.decisionTreeUtil.ParseJsonUtil;
import com.cc.pms.utils.decisionTreeUtil.TrainModelUtil;
import com.cc.pms.utils.decisionTreeUtil.TransformDataUtil;
import com.cc.pms.utils.lstmUtil.CreateCSVUtil;
import com.cc.pms.utils.lstmUtil.DataIteratorUtil;
import com.cc.pms.utils.lstmUtil.LSTMUtil2;
import com.cc.pms.utils.lstmUtil.LSTMWorkUtil;
import com.cc.pms.utils.predictUtil.ExponentialSmoothing1;
import com.cc.pms.utils.predictUtil.ExponentialSmoothing2;
import com.cc.pms.utils.predictUtil.ExponentialSmoothing3;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import net.sf.json.JSONArray;

/**
 * 1.实现数据分析以及智能决策等相关Ai功能
 * @author cc
 *
 */
@Controller
@RequestMapping("/analyze")
public class AnalyzeController {
	@Autowired
	private AnalyzeService analyzeService;
	@Autowired
	private ProductService productService;
	@Autowired
	private SalesService salesService;
	
	static Logger logger = Logger.getLogger(AnalyzeController.class);
	
	/**
	 * 0.0获取决策树需要的数据
	 * @param productId
	 * @param pn
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/getTreeDataSource",method=RequestMethod.GET)
	@LogAnnotation(value="获取树模型")
	public Msg getTreeDataSource(@RequestParam(value="productId")Integer productId,@RequestParam(value="pn",defaultValue="1")Integer pn) {
		PageHelper.startPage(pn, 5);
		List<TreeModelData> list=analyzeService.getTreeModelData(productId);
		PageInfo page=new PageInfo(list,5);
		return Msg.success().add("pageInfo", page);
	}
	/**
	 * 1.0测试
	 */
	@ResponseBody
	@RequestMapping(value="/test",method=RequestMethod.GET)
	public Msg test() {
		try {
			Thread.currentThread().sleep(5000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		return Msg.success();
	}
	
	/**
	 * 1.1 生成决策树模型
	 * @throws IOException 
	 */
	@ResponseBody
	@RequestMapping(value="/makingDecision",method=RequestMethod.GET)
	public Msg trainDecisionTreeModel(HttpServletRequest req) throws IOException {
		String flag=req.getParameter("flag");
		String url=req.getPathInfo();
		System.out.println(req.getParameter("test2"));
		//System.out.println("flag="+flag+",productId="+productId+",checkedList="+checkedList);
		analyzeService.trainDecisionTreeModel();     
		List<Object> result=analyzeService.predictByDecisionTreeModel();
		return Msg.success().add("result", result);
	}
	
	/**
	 * 1.2使用决策树模型
	 * @throws IOException 
	 * @throws FileNotFoundException 
	 */
	@ResponseBody
	@RequestMapping(value="/makingDecisionByModel",method=RequestMethod.GET)
	public Msg predictByDecisionTreeModel() throws FileNotFoundException, IOException{
		List<Object> result=analyzeService.predictByDecisionTreeModel();
		return Msg.success().add("result", result);

	}
	/**
	 * 1.3查看所有决策树模型
	 */
	@ResponseBody
	@RequestMapping(value="/getAllTreeModel",method=RequestMethod.GET)
	public Msg getAllTreeModel(){
		List<TreeModel> treeList= analyzeService.getAllTreeModel();
		return Msg.success().add("treeList", treeList);
	}
	/**
	 * 1.3推荐模型——依据条件
	 */
	@ResponseBody
	@RequestMapping(value="/getAllDTModelByCon",method=RequestMethod.GET)
	public Msg getAllDTModelByCon(@RequestParam(value="kind")Integer kind,@RequestParam(value="pn",defaultValue="1")Integer pn) {
		PageHelper.startPage(pn, 5);
		List<TreeModel> models=new ArrayList<>();
		if(kind==0) models=analyzeService.getAllTreeModel();
		if(kind==1) models=analyzeService.getAllTreeModelByStar();
		if(kind==2) models=analyzeService.getAllTreeModelBySize();
		if(kind==3) models=analyzeService.getAllTreeModelByLastUse();
		PageInfo page=new PageInfo(models,5);
		return Msg.success().add("pageInfo", page);
	}
	/**
	 * 1.3推荐模型——依据输入的关键字和kind
	 */
	@ResponseBody
	@RequestMapping(value="/getAllDTModelByCon2",method=RequestMethod.GET)
	public Msg getAllDTModelByCon2(@RequestParam(value="kind")Integer kind,@RequestParam(value="inputData")String inputData) {
		List<TreeModel> models=new ArrayList<>();
		if(kind==0) models=analyzeService.getAllTreeModelByInput(inputData);
		return Msg.success().add("models", models);
	}
	/**
	 * 1.4将树模型转换成json
	 */
	@ResponseBody
	@RequestMapping(value="/getJsonTreeModel",method=RequestMethod.GET)
	public JSONObject getJsonTreeModel() {
		String tree=ParseJsonUtil.mainMethod();
		JSONObject treeJson = JSON.parseObject(tree);
		System.out.println(treeJson);
		return treeJson;
	}
	/**
	 * 1.5为树模型打分
	 */
	@ResponseBody
	@RequestMapping(value="/updateDTModelStar",method=RequestMethod.PUT)
	public Msg updateDTModelStar(Integer treeModelId,Integer treeModelStar) {
		System.out.println(treeModelId);
		System.out.println(treeModelStar);
		int res=analyzeService.updateDTModelStar(treeModelId,treeModelStar);
		return Msg.success().add("res",res);
	}
	/**
	 * 1.6 修改
	 */
	@ResponseBody
	@RequestMapping(value="/getDTModelById",method=RequestMethod.GET)
	public Msg getDTModelById(Integer treeModelId) {
		TreeModel tmodel=analyzeService.getDTModelById(treeModelId);
		return Msg.success().add("res",tmodel);
	}
	@ResponseBody
	@RequestMapping(value="/updateDTModelById",method=RequestMethod.PUT)
	public Msg updateDTModelById(TreeModel model) {
		analyzeService.updateDTModelById(model);
		return Msg.success();
	}
	/**
	 * 2.1 指数平滑测试
	 */
	@ResponseBody
	@RequestMapping(value="/useESModel",method=RequestMethod.GET)
	public Msg useESModel(HttpServletResponse response,HttpServletRequest request) {
		//平滑系数
		double r=Double.parseDouble(request.getParameter("value"));
		System.out.println(r);
		//选择商品
		Integer id=Integer.parseInt(request.getParameter("productId"));
		System.out.println(id);
		Integer kind=Integer.parseInt(request.getParameter("kind"));
		System.out.println("kind="+kind);
		//数据列
		List<Integer> slist=salesService.getSelectProductSalesSize(id);
		System.out.println(slist);
		if(slist.size()<3) {
			return Msg.success().add("alert", "alert");
		}
		//分析
		List<Double> result=new ArrayList<Double>();
		if(kind==1) {
			result=ExponentialSmoothing1.predict(r,slist);
		}else if(kind==2) {
			result=ExponentialSmoothing2.predict(r,slist);
		}else if(kind==3) {
			result=ExponentialSmoothing3.predict(r,slist);
		}
		
		response.setContentType("text/html;charset=utf-8");
		response.setCharacterEncoding("utf-8");
		return Msg.success().add("result", result);
	}
	/**
	 * 3.1 聚类测试
	 * @throws FileNotFoundException 
	 */
	@ResponseBody
	@RequestMapping(value="/testCluster",method=RequestMethod.GET)
	public String testCluster(HttpServletResponse response) throws FileNotFoundException {
		response.setContentType("text/html;charset=utf-8");
		response.setCharacterEncoding("utf-8");
		String result=KMeansCluster1.test();
		return result;
	}
	
	/**
	 * 4.1LSTM测试——不选择模型
	 * @throws IOException 
	 */
	@ResponseBody
	@RequestMapping(value="/useLSTMModel",method=RequestMethod.GET)
	public Msg useLSTMModel(HttpServletResponse response,@RequestParam(value="predictValue")Double predictValue,
			@RequestParam(value="pId")Integer pId) throws IOException {
		System.out.println(predictValue);
		System.out.println(pId);
		//测试拿到数据
		List<DailyData> dataList=salesService.getDailyDataByProductId(3);
		System.out.println(dataList);
		if(dataList.size()<3) {
			return Msg.success().add("alert", "alert");
		}
		//生成csv文件
		ArrayList<String> headList=new ArrayList<>();
		headList.add("inboundCost");
		headList.add("inventorySize");
		headList.add("salesPrice");
		headList.add("salesSize");
		headList.add("dayOfWeek");
		headList.add("dayOfYear");
		headList.add("salesTime");
		CreateCSVUtil.createCSV(headList,dataList);
		//LSTM...
		ArrayList<Object> res=LSTMWorkUtil.useLSTMNoSelect();
		//将此次使用记录保存到数据库
		LSTMModel model=new LSTMModel((String) res.get(1),LocalDateTime.now(),1);
		analyzeService.insertLSTMModel(model);
		
		response.setContentType("text/html;charset=utf-8");
		response.setCharacterEncoding("utf-8");
		//List<Double> result=LSTMUtil2.test();
		return Msg.success().add("res", res);
	}
	/**
	 * 4.2LSTM测试：详细参数选择
	 */
	@ResponseBody
	@RequestMapping(value="/testLSTMModel2",method=RequestMethod.GET)
	public List<Double> testLSTMModel2(HttpServletResponse response,HttpServletRequest request) {
		String learningRatio=request.getParameter("learningRatio");
		String decayRatio=request.getParameter("decayRatio");
		String l2Ratio=request.getParameter("l2Ratio");
		System.out.println("learningRatio="+learningRatio+"decayRatio="+"l2Ratio="+l2Ratio);
		response.setContentType("text/html;charset=utf-8");
		response.setCharacterEncoding("utf-8");
		List<Double> result=LSTMUtil2.test2( );
		return result;
	}
	
	/**
	 * 4.3默认推荐模型——依据模型生成时间
	 */
	@ResponseBody
	@RequestMapping(value="/getALLLSTMModel",method=RequestMethod.GET)
	public Msg getALLLSTMModel(@RequestParam(value="pn",defaultValue="1")Integer pn) {
		PageHelper.startPage(pn, 5);
		List<LSTMModel> models=analyzeService.getAllLSTMModel();
		PageInfo page=new PageInfo(models,5);
		return Msg.success().add("pageInfo", page);
	}
	/**
	 * 4.4推荐模型——依据其他条件
	 */
	@ResponseBody
	@RequestMapping(value="/getALLLSTMModelByCon",method=RequestMethod.GET)
	public Msg getALLLSTMModelByCon(@RequestParam(value="kind")Integer kind,@RequestParam(value="pn",defaultValue="1")Integer pn) {
		PageHelper.startPage(pn, 5);
		List<LSTMModel> models=new ArrayList<>();
		if(kind==0) models=analyzeService.getAllLSTMModel();
		if(kind==1) models=analyzeService.getAllLSTMModelByStar();
		if(kind==2) models=analyzeService.getAllLSTMModelBySize();
		if(kind==3) models=analyzeService.getAllLSTMModelByLastUse();
		PageInfo page=new PageInfo(models,5);
		return Msg.success().add("pageInfo", page);
	}
	/**
	 * 4.5使用选择的模型进行预测
	 */
	@ResponseBody
	@RequestMapping(value="/useSelectLSTMModel",method=RequestMethod.GET)
	public Msg useSelectLSTMModel(HttpServletResponse response,@RequestParam(value="modelNum")String modelNum,
			@RequestParam(value="pId")Integer pId,@RequestParam(value="modelId")Integer mId) throws IOException {
		System.out.println(modelNum);
		System.out.println(mId);
		System.out.println(pId);
		//测试拿到数据
		List<DailyData> dataList=salesService.getDailyDataByProductId(pId);
		System.out.println(dataList);
		if(dataList.size()<3) {
			return Msg.success().add("alert", "alert");
		}
		//生成csv文件
		ArrayList<String> headList=new ArrayList<>();
		headList.add("inboundCost");
		headList.add("inventorySize");
		headList.add("salesPrice");
		headList.add("salesSize");
		headList.add("dayOfWeek");
		headList.add("dayOfYear");
		headList.add("salesTime");
		CreateCSVUtil.createCSV(headList,dataList);
		//LSTM...
		ArrayList<String> res=LSTMWorkUtil.useLSTMWithSelect(modelNum);
		//将此次使用记录保存到数据库
		LSTMModelRecord record=new LSTMModelRecord(mId,LocalDateTime.now());
		analyzeService.insertLSTMModelRecord(record);
		//更新当前模型的使用次数
		analyzeService.updateLSTMModelById(mId);
		//选择模型
		return Msg.success().add("res", res);
	}
	
	/**
	 * 5.1在智能分析模块提取想要的商品数据：id、商品名称、进货价、进货量、销售价、销售量
	 */
	@ResponseBody
	@RequestMapping(value="/displaySelectProduct",method = RequestMethod.GET)
	public Msg displaySelectProduct(Integer id,@RequestParam(value="pn",defaultValue="1")Integer pn) throws Exception{
		PageHelper.startPage(pn, 10);
		System.out.println("id="+id);
		//Product p =productService.getSelectProductWithSaleInf(id);
		//System.out.println(p);
		//List<Product> plist=new ArrayList<>();
		//plist.add(p);
		//PageInfo page=new PageInfo(plist,5);
		List<SaleInf> sales=salesService.getSelectProductSaleInf(id);
		PageInfo page=new PageInfo(sales,5);
		return Msg.success().add("pageInfo", page);
		
	}
	
	/**
	 * 5.2提取销量数据——List<>
	 */
	@ResponseBody
	@RequestMapping(value="/displaySalesSize",method = RequestMethod.GET)
	public Msg displaySalesSize(Integer id) {
		List<Integer> salesSizeList=salesService.getSelectProductSalesSize(id);		
		return Msg.success().add("salesSizeList",salesSizeList);
	}
	

}

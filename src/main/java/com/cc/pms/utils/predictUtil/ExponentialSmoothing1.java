package com.cc.pms.utils.predictUtil;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * 	一次指数平滑法
 * 	只适用于水平型历史数据的预测，而不适用于斜坡型线性趋势历史数据的预测
 * 	系数α的确定
 * 		指数平滑法的计算中，关键是α的取值大小，但α的取值又容易受主观影响，因此合理确定α的取值方法十分重要
 * 		一般来说，如果数据波动较大，α值应取大一些，可以增加近期数据对预测结果的影响。如果数据波动平稳，α值应取小一些
 * 	理论界认为有如下三种方法
 * 	1.经验判断法
 *		这种方法主要依赖于时间序列的发展趋势和预测者的经验做出判断
 *		当时间序列呈现较稳定的水平趋势时，应选较小的α值，一般可在0.05～0.20之间取值
 *		当时间序列有波动，但长期趋势变化不大时，可选稍大的α值，常在0.1～0.2之间取值
 *		当时间序列波动很大，长期趋势变化幅度较大，呈现明显且迅速的上升或下降趋势时
 *			宜选择较大的α值，如可在0.6～0.8间选值，以使预测模型灵敏度高些，能迅速跟上数据的变化
 *		当时间序列数据是上升（或下降）的发展趋势类型，α应取较大的值，在0.6~1之间
 *	2.试算法
 *		根据具体时间序列情况，参照经验判断法，来大致确定额定的取值范围
 *			然后取几个α值进行试算，比较不同α值下的预测标准误差，选取预测标准误差最小的α
 *	3.折中法
 *		在实际应用中预测者应结合对预测对象的变化规律做出定性判断且计算预测误差
 *		并要考虑到预测灵敏度和预测精度是相互矛盾的，必须给予二者一定的考虑，采用折中的α值
 * @author cc
 *
 */
public class ExponentialSmoothing1 {

	public static void main(String[] args) {
		Integer[] datas= {0,10,15,8,20,10,16,18,20,22,24,20,26};
		List<Integer> input=Arrays.asList(datas);
		System.out.println(input);
		Stream<Double> map = input.stream().map(x -> x*1.0);
		List<Double> dataList=map.collect(Collectors.toList());
		System.out.println(dataList);
//		Double datas[]= {0.0,10.0,15.0,8.0,20.0,10.0};
//		List<Double> dataList=addFormatData(datas);
//		List<Double> result=singleExponentialSmoothingMethod(dataList,0.3);
//		System.out.println(result);
//		Double datas2[]= {15.0,13.0,9.0,25.0,17.0,21.0,19.0,23.0,25.0};
		

	}
	public static List<Double> predict(double r,List<Integer> input){
		System.out.println(input);
		List<Double> res=new ArrayList<Double>();
		for(Integer in:input) {
			double rin=in.doubleValue();
			res.add(rin);
		}
		List<Double> result=singleExponentialSmoothingMethod(res,r);
		return result;
		
	}
	
	/**
	 * 	添加并格式化数据t-yt
	 */
	public static List addFormatData(Double datas[]) {
		List<Double> dataList=new LinkedList<>();
		for(Double data:datas) {
			dataList.add(data);
		}
		return dataList;
	}
	/**
	 * 	预测数据——一次指数平滑法
	 * 	@param dataList:观测数据
	 * 	@param a:加权系数
	 * 	@return list
	 */
	public static List<Double> singleExponentialSmoothingMethod(List<Double> dataList,Double a) {
		//预测结果list
		List<Double> s1=new ArrayList<>();
		//数据个数小于20，取前三次数据的平均值为初始值s[0]，或者也可以取第一次实际值为初始值
		//数据个数大于20，取所有数据的平均值为初始值s[0]，或者也可以取第一次实际值为初始值
		Double initialData=(double) ((dataList.get(1)+dataList.get(2)+dataList.get(3))/3);
		//标志位left
		int left=0;
		//保留1位小数
		DecimalFormat decimalFormat=new DecimalFormat("#.#");
		s1.add(0, Double.valueOf(decimalFormat.format(initialData)));
		for(int i=1;i<dataList.size();i++) {
			Double preData=s1.get(left);
			Double nextData=a*dataList.get(i)+(1-a)*preData;
			s1.add(i, Double.valueOf(decimalFormat.format(nextData)));
			left++;
			if(left+1==dataList.size()) {
				ExponentialSmoothing3.last.add(s1.get(left));
			}
		}
		return s1;
		
	}

	

}

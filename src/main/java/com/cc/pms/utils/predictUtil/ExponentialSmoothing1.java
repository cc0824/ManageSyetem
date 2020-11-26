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
 * 	һ��ָ��ƽ����
 * 	ֻ������ˮƽ����ʷ���ݵ�Ԥ�⣬����������б��������������ʷ���ݵ�Ԥ��
 * 	ϵ������ȷ��
 * 		ָ��ƽ�����ļ����У��ؼ��Ǧ���ȡֵ��С��������ȡֵ������������Ӱ�죬��˺���ȷ������ȡֵ����ʮ����Ҫ
 * 		һ����˵��������ݲ����ϴ󣬦�ֵӦȡ��һЩ���������ӽ������ݶ�Ԥ������Ӱ�졣������ݲ���ƽ�ȣ���ֵӦȡСһЩ
 * 	���۽���Ϊ���������ַ���
 * 	1.�����жϷ�
 *		���ַ�����Ҫ������ʱ�����еķ�չ���ƺ�Ԥ���ߵľ��������ж�
 *		��ʱ�����г��ֽ��ȶ���ˮƽ����ʱ��Ӧѡ��С�Ħ�ֵ��һ�����0.05��0.20֮��ȡֵ
 *		��ʱ�������в��������������Ʊ仯����ʱ����ѡ�Դ�Ħ�ֵ������0.1��0.2֮��ȡֵ
 *		��ʱ�����в����ܴ󣬳������Ʊ仯���Ƚϴ󣬳���������Ѹ�ٵ��������½�����ʱ
 *			��ѡ��ϴ�Ħ�ֵ�������0.6��0.8��ѡֵ����ʹԤ��ģ�������ȸ�Щ����Ѹ�ٸ������ݵı仯
 *		��ʱ���������������������½����ķ�չ�������ͣ���Ӧȡ�ϴ��ֵ����0.6~1֮��
 *	2.���㷨
 *		���ݾ���ʱ��������������վ����жϷ���������ȷ�����ȡֵ��Χ
 *			Ȼ��ȡ������ֵ�������㣬�Ƚϲ�ͬ��ֵ�µ�Ԥ���׼��ѡȡԤ���׼�����С�Ħ�
 *	3.���з�
 *		��ʵ��Ӧ����Ԥ����Ӧ��϶�Ԥ�����ı仯�������������ж��Ҽ���Ԥ�����
 *		��Ҫ���ǵ�Ԥ�������Ⱥ�Ԥ�⾫�����໥ì�ܵģ�����������һ���Ŀ��ǣ��������еĦ�ֵ
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
	 * 	��Ӳ���ʽ������t-yt
	 */
	public static List addFormatData(Double datas[]) {
		List<Double> dataList=new LinkedList<>();
		for(Double data:datas) {
			dataList.add(data);
		}
		return dataList;
	}
	/**
	 * 	Ԥ�����ݡ���һ��ָ��ƽ����
	 * 	@param dataList:�۲�����
	 * 	@param a:��Ȩϵ��
	 * 	@return list
	 */
	public static List<Double> singleExponentialSmoothingMethod(List<Double> dataList,Double a) {
		//Ԥ����list
		List<Double> s1=new ArrayList<>();
		//���ݸ���С��20��ȡǰ�������ݵ�ƽ��ֵΪ��ʼֵs[0]������Ҳ����ȡ��һ��ʵ��ֵΪ��ʼֵ
		//���ݸ�������20��ȡ�������ݵ�ƽ��ֵΪ��ʼֵs[0]������Ҳ����ȡ��һ��ʵ��ֵΪ��ʼֵ
		Double initialData=(double) ((dataList.get(1)+dataList.get(2)+dataList.get(3))/3);
		//��־λleft
		int left=0;
		//����1λС��
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

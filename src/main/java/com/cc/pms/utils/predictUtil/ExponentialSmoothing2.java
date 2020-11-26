package com.cc.pms.utils.predictUtil;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

/**
 * 	����ָ��ƽ����
 * 	�����ƶ�ƽ������ԭ����ȫ�����ڶ���ָ��ƽ����
 *	������б���͵���ʷ����
 *		��ʷ���ݺ�һ��ָ��ƽ��ֵ�Ĳ�ֵ��һ��ָ��ƽ��ֵ�Ͷ���ָ��ƽ��ֵ�Ĳ�ֵ������ͬ
 * @author cc
 *
 */
public class ExponentialSmoothing2 {
	private double ratio;
	
	public double getRatio() {
		return ratio;
	}

	public void setRatio(double ratio) {
		this.ratio = ratio;
	}
	
	public ExponentialSmoothing2() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static List<Double> computeIndex(List<Double> data,Double r){
		//����2λС��
		DecimalFormat decimalFormat=new DecimalFormat("#.##");
		Double a=2*data.get(0)-data.get(1);
		Double b=r*(data.get(0)-data.get(1))/(1-r);
		List<Double> returnList=new ArrayList<>();
		returnList.add(0,Double.valueOf(decimalFormat.format(a)));
		returnList.add(1,Double.valueOf(decimalFormat.format(b)));
		return returnList;
	}
	public static List<Double> predict(double r,List<Integer> input){
		System.out.println(input);
		List<Double> res=new ArrayList<Double>();
		for(Integer in:input) {
			double rin=in.doubleValue();
			res.add(rin);
		}
		List<Double> result=doubleExponentialSmoothingMethod(res,r);
		return result;
	}
	public static void main(String[] args) {
		//�趨ƽ��ϵ��
		ExponentialSmoothing2 e2=new ExponentialSmoothing2();
		e2.setRatio(0.3);
		WriteUtil.writeFile(e2.getRatio());
		//��������
		Double datas[]= {0.0,10.0,15.0,8.0,20.0,10.0,16.0,18.0,20.0,22.0,24.0};
		//��������
		//Double datas[]= {0.0,15.0,16.0,17.3,18.1,19.9,17.5,17.4,16.3,15.4,17.2,16.9,18.8,20.3};
		WriteUtil.writeFileWithList("���ݣ�", Arrays.asList(datas));
		List<Double> dataList=addFormatData(datas);
		List<Double> result=doubleExponentialSmoothingMethod(dataList,e2.getRatio());
		WriteUtil.writeFileWithList("���Σ�",result);
		WriteUtil.writeFileWithList("���һ����������ƽ��ֵ��", ExponentialSmoothing3.last);
		List<Double> ratioList=computeIndex(ExponentialSmoothing3.last,e2.getRatio());
		WriteUtil.writeFileWithList("Ԥ�⹫ʽϵ��a/b��", ratioList);
		WriteUtil.writeFile("y="+ratioList.get(0)+"+"+ratioList.get(1)+"*T");


	}
	/**
	 * 	�������t-yt
	 */
	public static List addFormatData(Double datas[]) {
		List<Double> dataList=new LinkedList<>();
		for(Double data:datas) {
			dataList.add(data);
		}
		return dataList;
	}
	/**
	 * 	Ԥ�����ݡ�������ָ��ƽ����
	 * 	@param dataList:�۲�����
	 * 	@param a:��Ȩϵ��
	 * 	@return
	 */
	public static List<Double> doubleExponentialSmoothingMethod(List<Double> dataList,Double a) {
		//Ԥ����list
		List<Double> s2=new ArrayList<>();
		//ȡǰ�������ݵ�ƽ��ֵΪ��ʼֵs[0]������Ҳ����ȡ��һ��ʵ��ֵΪ��ʼֵ
		Double initialData=(double) ((dataList.get(1)+dataList.get(2)+dataList.get(3))/3);
		//��־λleft
		int left=0;
		//����1λС��
		DecimalFormat decimalFormat=new DecimalFormat("#.#");
		s2.add(0, Double.valueOf(decimalFormat.format(initialData)));
		//ȡ��һ��ָ��ƽ������Ԥ��ֵ
		List<Double> s1=ExponentialSmoothing1.singleExponentialSmoothingMethod(dataList, a);
		WriteUtil.writeFileWithList("һ�Σ�",s1);
		for(int i=1;i<dataList.size();i++) {
			Double preData=s2.get(left);
			Double nextData=a*s1.get(i)+(1-a)*preData;
			s2.add(i, Double.valueOf(decimalFormat.format(nextData)));
			left++;
			if(left+1==dataList.size()) {
				ExponentialSmoothing3.last.add(s2.get(left));
			}
		}
		return s2;
	}


}

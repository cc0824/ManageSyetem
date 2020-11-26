package com.cc.pms.utils.predictUtil;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

/**
 * 	����ָ��ƽ����
 * 		֧��������
 * @author cc
 *
 */
public class ExponentialSmoothing3 {
	//������ƽ���������һ��Ԥ��ֵ
	public static List<Double> last=new ArrayList<>();
	private double ratio;
	
	public double getRatio() {
		return ratio;
	}

	public void setRatio(double ratio) {
		this.ratio = ratio;
	}
	
	

	public ExponentialSmoothing3() {
		super();
		// TODO Auto-generated constructor stub
	}
	public static List<Double> predict(double r,List<Integer> input){
		System.out.println(input);
		List<Double> res=new ArrayList<Double>();
		for(Integer in:input) {
			double rin=in.doubleValue();
			res.add(rin);
		}
		List<Double> result=tripleExponentialSmoothingMethod(res,r);
		return result;
	}
	public static List<Double> computeIndex(List<Double> data,Double r){
		//����2λС��
		DecimalFormat decimalFormat=new DecimalFormat("#.##");
		Double a=3*data.get(0)-3*data.get(1)+data.get(2);
		Double b=r*((6-5*r)*data.get(0)-2*(5-4*r)*data.get(1)+(4-3*r)*data.get(2))/(2*(1-r)*(1-r));
		Double c=r*r*(data.get(0)-2*data.get(1)+data.get(2))/(2*(1-r)*(1-r));
		List<Double> returnList=new ArrayList<>();
		returnList.add(0,Double.valueOf(decimalFormat.format(a)));
		returnList.add(1,Double.valueOf(decimalFormat.format(b)));
		returnList.add(2,Double.valueOf(decimalFormat.format(c)));
		return returnList;
	}

	public static void main(String[] args) {
		//�趨ƽ��ϵ��
		ExponentialSmoothing3 e3=new ExponentialSmoothing3();
		e3.setRatio(0.3);
		WriteUtil.writeFile(e3.getRatio());
		//��������
		//Double datas[]= {0.0,10.0,15.0,8.0,20.0,10.0,16.0,18.0,20.0,22.0,24.0};
		//��������
		Double datas[]= {0.0,15.0,16.0,17.3,18.1,19.9,17.5,17.4,16.3,15.4,17.2,16.9,18.8,20.3};
		WriteUtil.writeFileWithList("���ݣ�", Arrays.asList(datas));
		List<Double> dataList=addFormatData(datas);
		List<Double> result=tripleExponentialSmoothingMethod(dataList,e3.getRatio());
		WriteUtil.writeFileWithList("���Σ�",result);
		WriteUtil.writeFileWithList("���һ����������ƽ��ֵ��", last);
		List<Double> ratioList=computeIndex(last,e3.getRatio());
		WriteUtil.writeFileWithList("Ԥ�⹫ʽϵ��a/b/c��", ratioList);
		WriteUtil.writeFile("y="+ratioList.get(0)+"+"+ratioList.get(1)+"*T+"+ratioList.get(2)+"*T^2");

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
	public static List<Double> tripleExponentialSmoothingMethod(List<Double> dataList,Double a) {
		//Ԥ����list
		List<Double> s3=new ArrayList<>();
		//ȡǰ�������ݵ�ƽ��ֵΪ��ʼֵs[0]������Ҳ����ȡ��һ��ʵ��ֵΪ��ʼֵ
		Double initialData=(double) ((dataList.get(1)+dataList.get(2)+dataList.get(3))/3);
		//����1λС��
		DecimalFormat decimalFormat=new DecimalFormat("#.#");
		s3.add(0, Double.valueOf(decimalFormat.format(initialData)));
		//��־λleft
		int left=0;
		//ȡ�ö���ָ��ƽ������Ԥ��ֵ
		List<Double> s2=ExponentialSmoothing2.doubleExponentialSmoothingMethod(dataList, a);
		WriteUtil.writeFileWithList("���Σ�",s2);
		for(int i=1;i<dataList.size();i++) {
			Double preData=s3.get(left);
			Double nextData=a*s2.get(i)+(1-a)*preData;
			s3.add(i, Double.valueOf(decimalFormat.format(nextData)));
			left++;
			if(left+1==dataList.size()) {
				last.add(s3.get(left));
			}
		}
		return s3;
	}

}

package com.cc.pms.utils.lstmUtil;

import org.nd4j.linalg.api.ndarray.INDArray;
import org.nd4j.linalg.dataset.DataSet;
import org.nd4j.linalg.dataset.api.DataSetPreProcessor;
import org.nd4j.linalg.dataset.api.iterator.DataSetIterator;
import org.nd4j.linalg.factory.Nd4j;

import com.cc.pms.bean.DailyData;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.NoSuchElementException;
/**
 * 	数据源是倒叙排序，需要先反转一次
 * 	代码中对数据的各个维度进行了归一化处理：
 *		方法是记录每个维度的最大值，构造特征向量与标签时用原始数值除以最大值，得到0-1之间的数
 *		归一化的好处在于使训练过程收敛变快
 * 	如果不归一化：
 * 		
 * 	@author cc
 *
 */
public class DataIteratorUtil implements DataSetIterator{

	//6维向量
    private static final int VECTOR_SIZE=6;
    //每批次的训练数据组数
    private int batchNum;
    //每组训练数据长度(DailyData的个数)
    private int exampleLength;
    //数据集
    private List<DailyData> dataList;
    //存放剩余数据组的index信息
    private List<Integer> dataRecord;
    
    private double []maxNum;

    public DataIteratorUtil(){
        dataRecord=new ArrayList<>();
    }
    
    //加载数据并初始化
    public boolean loadData(String fileName,int batchNum,int exampleLength){
        this.batchNum=batchNum;
        this.exampleLength=exampleLength;
        maxNum=new double[6];
        try{
        	//加载文件中的股票数据
            readDataFromFile(fileName);
        }catch (Exception e){
            e.printStackTrace();
            return false;
        }
        //重置训练批次列表
        resetDataRecord();
        return true;
    }
    
    //重置训练批次列表
    private void resetDataRecord(){
        dataRecord.clear();
        int total=dataList.size()/exampleLength+1;
        for(int i=0;i<total;i++){
            dataRecord.add(i*exampleLength);
        }
    }

    //从文件中读取股票数据
    public List<DailyData> readDataFromFile(String fileName)throws  IOException{
        dataList= new ArrayList<>();
        FileInputStream  fis=new FileInputStream(fileName);
        BufferedReader in = new BufferedReader(new InputStreamReader(fis,"UTF-8"));
        String line0 =in.readLine();
        String line=in.readLine();
        for (int i = 0; i < maxNum.length; i++) {
            maxNum[i]=0;
        }
        //System.out.println("read data ...");
        while (line!=null){
        	//读取每一行数据
            String [] strArr=line.split(",");
            if(strArr.length>=5) {
                DailyData data= new DailyData();
                //获得最大值信息，用于归一化
                double [] nums= new double[6];
                for(int j=0;j<6;j++){
                	nums[j] =Double.valueOf(strArr[j]);
				    if(nums[j]>maxNum[j]){
				    	maxNum[j]=nums[j];
				    }
				}
                //构造data对象，nums是double类型
                data.setInboundCost(String.valueOf(nums[0]));
                data.setInventorySize((int)nums[1]);
                data.setSalesPrice(String.valueOf(nums[2]));
                data.setSalesSize((int)nums[3]);
                data.setDayOfWeek((int)nums[4]);
                data.setDayOfYear((int)nums[5]);
                dataList.add(data);
            }
            line=in.readLine();
        }
        in.close();
        fis.close();
        return dataList;
    }
    

    public double [] getMaxArr(){

        return this.maxNum;
    }

    public void reset(){
        resetDataRecord();
    }
    public boolean hasNext(){
        return dataRecord.size()>0;
    }
    public DataSet next(){
        return  next(batchNum);
    }

    public int batch(){
        return batchNum;
    }
    public int cursor(){
        return totalExamples() - dataRecord.size();
    }
    public int numExamples(){
        return  totalExamples();

    }
    public void  setPreProcessor(DataSetPreProcessor preProcessor){
        throw  new UnsupportedOperationException("not implemented  ");

    }

    public DataSetPreProcessor getPreProcessor() {
        return null;
    }

    public int totalExamples(){
        return (dataList.size())/ exampleLength;

    }

    public int inputColumns(){
        return  dataList.size();

    }
    public  int totalOutcomes(){
        return 1;
    }

    public boolean resetSupported() {
        return false;
    }

    public boolean asyncSupported() {
        return false;
    }

    public  List<String > getLabels(){
        throw new UnsupportedOperationException("Not Implemented   ");
    }


    public void remove(){
        throw new UnsupportedOperationException(   );

    }
    
    //获得接下来一次的训练数据集
    public DataSet next(int num ){

        if (dataRecord.size() <=0) {
            throw new NoSuchElementException();

        }
        int actualBatchSize =Math.min(num,dataRecord.size());//1,[0,5,10,15,20]
        int actualLength=Math.min(exampleLength,dataList.size()-dataRecord.get(0)-1);//5,22-0-1

        System.out.println("l==="+"  "+actualLength+"  exampleLength :="+exampleLength+"  batchsize:="+actualBatchSize);
        System.out.println("datalist="+dataList.size()+"  dataRecord  "+dataRecord.get(0));
        //VECTOR_SIZE=6  actualLength=5  input=6*5的矩阵 默认值0.0
        INDArray input =Nd4j.create(new int[] {actualBatchSize,VECTOR_SIZE,actualLength},'f');
        //label=1*5的矩阵  默认值0.0
        INDArray label=Nd4j.create(new int[] {actualBatchSize,1,actualLength},'f');
        if (actualLength <1) {
             label=Nd4j.create(new int[] {actualBatchSize,1,1},'f');
        }

        DailyData nextData=null,curData=null;
        //获取每批次的训练数据和标签数据
        for (int i = 0; i < actualBatchSize; i++) {//i<1
            int index= dataRecord.remove(0);//0
            int endIndex= Math.min(index+exampleLength,dataList.size()-1);//5
            curData=dataList.get(index);
            for (int j = index  ; j <endIndex ; j++) {
            	//获取数据信息
                nextData=dataList.get(j+1);
                //构造训练向量
                int c= endIndex-j-1;//4=5-0-1
                input.putScalar(new int[]{i,0,c},Double.valueOf(curData.getInboundCost())/maxNum[0]);
                input.putScalar(new int [] {i,1,c},Double.valueOf(curData.getInventorySize())/maxNum[1]);
                input.putScalar(new int []{i,2,c},Double.valueOf(curData.getSalesPrice())/maxNum[2]);
                input.putScalar(new int []{i,3,c},Double.valueOf(curData.getSalesSize())/maxNum[3]);
                input.putScalar(new int []{i,4,c},Double.valueOf(curData.getDayOfWeek())/maxNum[4]);
                input.putScalar(new int []{i,5,c},Double.valueOf(curData.getDayOfYear())/maxNum[5]);
                //构造label向量，输出标识列
                label.putScalar(new int []{i,0,c},nextData.getSalesSize()/maxNum[3]);
                curData=nextData;
            }
            if(dataRecord.size()<=0){
                break;
            }
        }

        return new DataSet(input,label);
    }

}


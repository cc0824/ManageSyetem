package com.cc.pms.utils.lstmUtil;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.util.ArrayList;

import org.deeplearning4j.nn.api.OptimizationAlgorithm;
import org.deeplearning4j.nn.conf.ComputationGraphConfiguration;
import org.deeplearning4j.nn.conf.ComputationGraphConfiguration.GraphBuilder;
import org.deeplearning4j.nn.conf.MultiLayerConfiguration;
import org.deeplearning4j.nn.conf.NeuralNetConfiguration;
import org.deeplearning4j.nn.conf.Updater;
import org.deeplearning4j.nn.conf.layers.ActivationLayer;
import org.deeplearning4j.nn.conf.layers.GravesLSTM;
import org.deeplearning4j.nn.conf.layers.GravesLSTM.Builder;
import org.deeplearning4j.nn.conf.layers.RnnOutputLayer;
import org.deeplearning4j.nn.multilayer.MultiLayerNetwork;
import org.deeplearning4j.nn.weights.WeightInit;
import org.deeplearning4j.optimize.listeners.ScoreIterationListener;
import org.deeplearning4j.util.ModelSerializer;
import org.nd4j.linalg.activations.Activation;
import org.nd4j.linalg.api.ndarray.INDArray;
import org.nd4j.linalg.dataset.DataSet;
import org.nd4j.linalg.factory.Nd4j;
import org.nd4j.linalg.lossfunctions.LossFunctions;

public class LSTMWorkUtil {
    private static final int IN_NUM=6;//输入层节点个数，因为单个向量是6维的
    private static final int OUT_NUM=1;//输出层节点个数，用于预测第二天的某个属性
    //比如有1000个数据，这个数据集可能太大了，全部跑一次再调参很慢
    //于是可以分成100个为一个数据集，这样有10份数据
    //batch_size=100，每100个数据组成的数据集叫batch，整个训练集中的batch个数为10，batchNum=10
    //每跑完一个batch都要更新参数，这个过程叫一个iteration迭代
    //1个epoch就代表跑完这10个batch（10个iteration）的过程，这个过程完整过了1遍训练集中的所有样本
    //100个epoch就代表网络模型传递（训练）整个数据集100次
    private static final int Epochs=30;

    private static final int lstmLayer1Size=50;//2个隐藏层，设置隐藏层节点个数
    private static final int lstmLayer2Size=100;


    /**
     * 	生成网络模型  nIn=IN_NUM  nOut=OUT_NUM
     * 	通过调整参数来寻找最优的拟合效果或训练速率：
     * 		比如隐含层单元数目、激活函数、学习速率、正则化因子
     * 	@param nIn
     * 	@param nOut
     * 	@return
     */
    public static MultiLayerNetwork getNexModel(int nIn,int nOut){
    	//网络配置
        MultiLayerConfiguration conf=new NeuralNetConfiguration.Builder()
                .optimizationAlgo(OptimizationAlgorithm.STOCHASTIC_GRADIENT_DESCENT).iterations(1)//随机梯度下降算法
                .learningRate(0.1)//学习速率
                .rmsDecay(0.5)//衰减率
                .seed(12345)
                .regularization(true)//是否使用正则化（l1，l2），Dropout等
                .l2(0.001)//权重的L2正则化系数
                .weightInit(WeightInit.XAVIER)//初始化权重
                .updater(Updater.RMSPROP)//梯度优化算法
                .list()//创建ListBuilder
                //隐藏层1，配置输入输出节点个数，配置激活函数
                .layer(0,new GravesLSTM.Builder().nIn(nIn).nOut(lstmLayer1Size)
                        .activation("tanh").build())
                //隐藏层2
                .layer(1,new GravesLSTM.Builder().nIn(lstmLayer1Size).nOut(lstmLayer2Size)
                        .activation("tanh").build())
                //输出层
                .layer(2,new RnnOutputLayer.Builder(LossFunctions.LossFunction.MSE)
                        .activation(Activation.IDENTITY).nIn(lstmLayer2Size).nOut(nOut).build())
                .pretrain(false)//数据预处理
                .backprop(true)//反向传播
                .build();
        //应用配置
        MultiLayerNetwork net =new MultiLayerNetwork(conf);
        //在使用网络前必须初始化网络
        net.init();
        //使用ScoreIterationListener来监听每次迭代训练后的得分，@param printIterations打印分数的频率
        net.setListeners(new ScoreIterationListener(1));
        return net;

    }
    
    //训练网络
    //数据集迭代器将数据加载到神经网络中，并帮助组织批处理、转换和掩码
    public static ArrayList<String> train(MultiLayerNetwork net,DataIteratorUtil iterator){
    	ArrayList<String> res=new ArrayList<>();
    	//总共训练次数：Epochs
        for (int i = 0; i < Epochs; i++) {
            DataSet dataSet=null;
            while (iterator.hasNext()){
                dataSet=iterator.next();//生成数据集
                net.fit(dataSet);//拟合
            }
            iterator.reset();
            
            System.out.println();
            System.out.println("=======>完成 第"+i+"次完整训练");
            
            INDArray initArray=getInitArray(iterator);
            System.out.println("预测结果： ");
            //预测之后10个序列的输出
            for (int j = 0; j < 10; j++) {
                INDArray output=net.rnnTimeStep(initArray);
                System.out.println(output.getDouble(0)*iterator.getMaxArr()[3]+" ");
                if(i==Epochs-1) {
                	res.add(output.getDouble(0)*iterator.getMaxArr()[3]+" ");
                }
            }
            

            System.out.println();
            net.rnnClearPreviousState();
        }
        return res;
    }
    //初始化数据向量
    private  static INDArray getInitArray(DataIteratorUtil iter){
        double [] maxNums=iter.getMaxArr();
        INDArray initArray= Nd4j.zeros(1,6,1 );
        initArray.putScalar(new int [] {0,0,0},6.5/maxNums[0]);
        initArray.putScalar(new int[] {0,1,0},87.0/maxNums[1]);
        initArray.putScalar(new int[]{0,2,0},8.0/maxNums[2]);
        initArray.putScalar(new int[]{0,3,0},10.0/maxNums[3]);
        initArray.putScalar(new int []{0,4,0},7.0/maxNums[4]);
        initArray.putScalar(new int []{0,5,0},61.0/maxNums[5]);
        return  initArray;
    }
    /**
     * 1.不选择模型，新生成模型
     * @throws IOException
     */
    public static ArrayList<Object> useLSTMNoSelect() throws IOException{
    	//加载数据、训练模型
    	String inputFile="C:/Users/18379/Desktop/testCSV.csv";
        DataIteratorUtil iterator= new DataIteratorUtil();
        int batchNum =1;//每批次的训练数据组数
        int exampleLength=5;//每组训练数据长度(DailyData的个数)
        iterator.loadData(inputFile,batchNum,exampleLength);
        MultiLayerNetwork net=getNexModel(IN_NUM,OUT_NUM);
        //保存模型，先要找到最后一次模型编号
        String path = "D:/Eclipse_Workspace/SSM-PMS/src/main/resources/data/model";
        File file=new File(path);
        String[] names=file.list();
        String[] lastName=names[names.length-1].split("\\.");
        int lastNameId=Integer.valueOf(lastName[0].substring(9))+1;
        String newNameId=String.format("%03d", lastNameId);
        System.out.println(newNameId);
        File locationToSave = new File("D:/Eclipse_Workspace/SSM-PMS/src/main/resources/data/model/LSTMModel".concat(newNameId).concat(".zip"));
        ModelSerializer.writeModel(net, locationToSave, true);
        //训练模型
        ArrayList<String> preData= train(net,iterator);
        ArrayList<Object> res=new ArrayList<>();
        res.add(preData);
        res.add("LSTMModel"+newNameId);
        return res;
    }
    /**
     * 2.选择模型，不新生成模型
     * @throws IOException
     */
    public static ArrayList<String> useLSTMWithSelect(String modelNum) throws IOException{
    	//加载数据
    	String inputFile="C:/Users/18379/Desktop/testCSV.csv";
    	DataIteratorUtil iterator= new DataIteratorUtil();
    	int batchNum =1;//每批次的训练数据组数
    	int exampleLength=5;//每组训练数据长度(DailyData的个数)
    	iterator.loadData(inputFile,batchNum,exampleLength);
    	//加载模型
    	File locationToSave = new File("D:/Eclipse_Workspace/SSM-PMS/src/main/resources/data/model/".concat(modelNum).concat(".zip"));
    	MultiLayerNetwork net = ModelSerializer.restoreMultiLayerNetwork(locationToSave);
    	//训练模型
    	return train(net,iterator);
    }

    public static void main(String[] args) throws IOException{
    	ArrayList<Object> res=useLSTMNoSelect();
    	System.out.println(res);
    }
}


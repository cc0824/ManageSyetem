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
    private static final int IN_NUM=6;//�����ڵ��������Ϊ����������6ά��
    private static final int OUT_NUM=1;//�����ڵ����������Ԥ��ڶ����ĳ������
    //������1000�����ݣ�������ݼ�����̫���ˣ�ȫ����һ���ٵ��κ���
    //���ǿ��Էֳ�100��Ϊһ�����ݼ���������10������
    //batch_size=100��ÿ100��������ɵ����ݼ���batch������ѵ�����е�batch����Ϊ10��batchNum=10
    //ÿ����һ��batch��Ҫ���²�����������̽�һ��iteration����
    //1��epoch�ʹ���������10��batch��10��iteration���Ĺ��̣����������������1��ѵ�����е���������
    //100��epoch�ʹ�������ģ�ʹ��ݣ�ѵ�����������ݼ�100��
    private static final int Epochs=30;

    private static final int lstmLayer1Size=50;//2�����ز㣬�������ز�ڵ����
    private static final int lstmLayer2Size=100;


    /**
     * 	��������ģ��  nIn=IN_NUM  nOut=OUT_NUM
     * 	ͨ������������Ѱ�����ŵ����Ч����ѵ�����ʣ�
     * 		���������㵥Ԫ��Ŀ���������ѧϰ���ʡ���������
     * 	@param nIn
     * 	@param nOut
     * 	@return
     */
    public static MultiLayerNetwork getNexModel(int nIn,int nOut){
    	//��������
        MultiLayerConfiguration conf=new NeuralNetConfiguration.Builder()
                .optimizationAlgo(OptimizationAlgorithm.STOCHASTIC_GRADIENT_DESCENT).iterations(1)//����ݶ��½��㷨
                .learningRate(0.1)//ѧϰ����
                .rmsDecay(0.5)//˥����
                .seed(12345)
                .regularization(true)//�Ƿ�ʹ�����򻯣�l1��l2����Dropout��
                .l2(0.001)//Ȩ�ص�L2����ϵ��
                .weightInit(WeightInit.XAVIER)//��ʼ��Ȩ��
                .updater(Updater.RMSPROP)//�ݶ��Ż��㷨
                .list()//����ListBuilder
                //���ز�1��������������ڵ���������ü����
                .layer(0,new GravesLSTM.Builder().nIn(nIn).nOut(lstmLayer1Size)
                        .activation("tanh").build())
                //���ز�2
                .layer(1,new GravesLSTM.Builder().nIn(lstmLayer1Size).nOut(lstmLayer2Size)
                        .activation("tanh").build())
                //�����
                .layer(2,new RnnOutputLayer.Builder(LossFunctions.LossFunction.MSE)
                        .activation(Activation.IDENTITY).nIn(lstmLayer2Size).nOut(nOut).build())
                .pretrain(false)//����Ԥ����
                .backprop(true)//���򴫲�
                .build();
        //Ӧ������
        MultiLayerNetwork net =new MultiLayerNetwork(conf);
        //��ʹ������ǰ�����ʼ������
        net.init();
        //ʹ��ScoreIterationListener������ÿ�ε���ѵ����ĵ÷֣�@param printIterations��ӡ������Ƶ��
        net.setListeners(new ScoreIterationListener(1));
        return net;

    }
    
    //ѵ������
    //���ݼ������������ݼ��ص��������У���������֯������ת��������
    public static ArrayList<String> train(MultiLayerNetwork net,DataIteratorUtil iterator){
    	ArrayList<String> res=new ArrayList<>();
    	//�ܹ�ѵ��������Epochs
        for (int i = 0; i < Epochs; i++) {
            DataSet dataSet=null;
            while (iterator.hasNext()){
                dataSet=iterator.next();//�������ݼ�
                net.fit(dataSet);//���
            }
            iterator.reset();
            
            System.out.println();
            System.out.println("=======>��� ��"+i+"������ѵ��");
            
            INDArray initArray=getInitArray(iterator);
            System.out.println("Ԥ������ ");
            //Ԥ��֮��10�����е����
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
    //��ʼ����������
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
     * 1.��ѡ��ģ�ͣ�������ģ��
     * @throws IOException
     */
    public static ArrayList<Object> useLSTMNoSelect() throws IOException{
    	//�������ݡ�ѵ��ģ��
    	String inputFile="C:/Users/18379/Desktop/testCSV.csv";
        DataIteratorUtil iterator= new DataIteratorUtil();
        int batchNum =1;//ÿ���ε�ѵ����������
        int exampleLength=5;//ÿ��ѵ�����ݳ���(DailyData�ĸ���)
        iterator.loadData(inputFile,batchNum,exampleLength);
        MultiLayerNetwork net=getNexModel(IN_NUM,OUT_NUM);
        //����ģ�ͣ���Ҫ�ҵ����һ��ģ�ͱ��
        String path = "D:/Eclipse_Workspace/SSM-PMS/src/main/resources/data/model";
        File file=new File(path);
        String[] names=file.list();
        String[] lastName=names[names.length-1].split("\\.");
        int lastNameId=Integer.valueOf(lastName[0].substring(9))+1;
        String newNameId=String.format("%03d", lastNameId);
        System.out.println(newNameId);
        File locationToSave = new File("D:/Eclipse_Workspace/SSM-PMS/src/main/resources/data/model/LSTMModel".concat(newNameId).concat(".zip"));
        ModelSerializer.writeModel(net, locationToSave, true);
        //ѵ��ģ��
        ArrayList<String> preData= train(net,iterator);
        ArrayList<Object> res=new ArrayList<>();
        res.add(preData);
        res.add("LSTMModel"+newNameId);
        return res;
    }
    /**
     * 2.ѡ��ģ�ͣ���������ģ��
     * @throws IOException
     */
    public static ArrayList<String> useLSTMWithSelect(String modelNum) throws IOException{
    	//��������
    	String inputFile="C:/Users/18379/Desktop/testCSV.csv";
    	DataIteratorUtil iterator= new DataIteratorUtil();
    	int batchNum =1;//ÿ���ε�ѵ����������
    	int exampleLength=5;//ÿ��ѵ�����ݳ���(DailyData�ĸ���)
    	iterator.loadData(inputFile,batchNum,exampleLength);
    	//����ģ��
    	File locationToSave = new File("D:/Eclipse_Workspace/SSM-PMS/src/main/resources/data/model/".concat(modelNum).concat(".zip"));
    	MultiLayerNetwork net = ModelSerializer.restoreMultiLayerNetwork(locationToSave);
    	//ѵ��ģ��
    	return train(net,iterator);
    }

    public static void main(String[] args) throws IOException{
    	ArrayList<Object> res=useLSTMNoSelect();
    	System.out.println(res);
    }
}


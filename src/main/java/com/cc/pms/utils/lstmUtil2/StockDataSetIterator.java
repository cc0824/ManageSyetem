package com.cc.pms.utils.lstmUtil2;

import com.cc.pms.bean.DailyData;
import com.google.common.collect.ImmutableMap;
import com.opencsv.CSVReader;
import javafx.util.Pair;
import org.nd4j.linalg.api.ndarray.INDArray;
import org.nd4j.linalg.dataset.DataSet;
import org.nd4j.linalg.dataset.api.DataSetPreProcessor;
import org.nd4j.linalg.dataset.api.iterator.DataSetIterator;
import org.nd4j.linalg.factory.Nd4j;

import java.io.FileReader;
import java.io.IOException;
import java.util.*;

public class StockDataSetIterator implements DataSetIterator {

    //种类+index
    private final Map<PriceCategory, Integer> featureMapIndex = ImmutableMap.of(PriceCategory.INBCOST, 0, PriceCategory.INVSIZE, 1,
            PriceCategory.SALPRICE, 2, PriceCategory.SALSIZE, 3);

    private final int VECTOR_SIZE = 6; //5维向量
    private int miniBatchSize; 
    private int exampleLength = 22; //默认每个月工作22天
    private int predictLength = 1; //默认预测下一天的数据

    //min
    private double[] minArray = new double[VECTOR_SIZE];
    //max
    private double[] maxArray = new double[VECTOR_SIZE];

    //预测数据属性种类
    private PriceCategory category;

    private LinkedList<Integer> exampleStartOffsets = new LinkedList<>();

    //训练数据
    private List<DailyData> train;
    //测试数据
    private List<Pair<INDArray, INDArray>> test;

    public StockDataSetIterator (String filename, String symbol, int miniBatchSize, int exampleLength, double splitRatio, PriceCategory category) {
        List<DailyData> stockDataList = readStockDataFromFile(filename, symbol);
        this.miniBatchSize = miniBatchSize;
        this.exampleLength = exampleLength;
        this.category = category;
        int split = (int) Math.round(stockDataList.size() * splitRatio);
        train = stockDataList.subList(0, split);
        test = generateTestDataSet(stockDataList.subList(split, stockDataList.size()));
        initializeOffsets();
    }


    private void initializeOffsets () {
        exampleStartOffsets.clear();
        int window = exampleLength + predictLength;
        for (int i = 0; i < train.size() - window; i++) { exampleStartOffsets.add(i); }
    }

    public List<Pair<INDArray, INDArray>> getTestDataSet() { return test; }

    public double[] getMaxArray() { return maxArray; }

    public double[] getMinArray() { return minArray; }

    public double getMaxNum (PriceCategory category) { return maxArray[featureMapIndex.get(category)]; }

    public double getMinNum (PriceCategory category) { return minArray[featureMapIndex.get(category)]; }

    @Override
    public DataSet next(int num) {
        if (exampleStartOffsets.size() == 0) throw new NoSuchElementException();
        int actualMiniBatchSize = Math.min(num, exampleStartOffsets.size());
        INDArray input = Nd4j.create(new int[] {actualMiniBatchSize, VECTOR_SIZE, exampleLength}, 'f');
        INDArray label;
        if (category.equals(PriceCategory.ALL)) label = Nd4j.create(new int[] {actualMiniBatchSize, VECTOR_SIZE, exampleLength}, 'f');
        else label = Nd4j.create(new int[] {actualMiniBatchSize, predictLength, exampleLength}, 'f');
        for (int index = 0; index < actualMiniBatchSize; index++) {
            int startIdx = exampleStartOffsets.removeFirst();
            int endIdx = startIdx + exampleLength;
            DailyData curData = train.get(startIdx);
            DailyData nextData;
            for (int i = startIdx; i < endIdx; i++) {
                int c = i - startIdx;
                input.putScalar(new int[] {index, 0, c}, (Double.valueOf(curData.getInboundCost()) - minArray[0]) / (maxArray[0] - minArray[0]));
                input.putScalar(new int[] {index, 1, c}, (Double.valueOf(curData.getInventorySize()) - minArray[1]) / (maxArray[1] - minArray[1]));
                input.putScalar(new int[] {index, 2, c}, (Double.valueOf(curData.getSalesPrice()) - minArray[2]) / (maxArray[2] - minArray[2]));
                input.putScalar(new int[] {index, 3, c}, (Double.valueOf(curData.getSalesSize()) - minArray[3]) / (maxArray[3] - minArray[3]));
                input.putScalar(new int[] {index, 4, c}, (Double.valueOf(curData.getDayOfWeek()) - minArray[4]) / (maxArray[4] - minArray[4]));
                input.putScalar(new int[] {index, 5, c}, (Double.valueOf(curData.getDayOfYear()) - minArray[4]) / (maxArray[4] - minArray[4]));
                nextData = train.get(i + 1);
                if (category.equals(PriceCategory.ALL)) {
                    label.putScalar(new int[] {index, 0, c}, (Double.valueOf(nextData.getInboundCost()) - minArray[1]) / (maxArray[1] - minArray[1]));
                    label.putScalar(new int[] {index, 1, c}, (Double.valueOf(nextData.getInventorySize()) - minArray[1]) / (maxArray[1] - minArray[1]));
                    label.putScalar(new int[] {index, 2, c}, (Double.valueOf(nextData.getSalesPrice()) - minArray[2]) / (maxArray[2] - minArray[2]));
                    label.putScalar(new int[] {index, 3, c}, (Double.valueOf(nextData.getSalesSize()) - minArray[3]) / (maxArray[3] - minArray[3]));
                    label.putScalar(new int[] {index, 4, c}, (Double.valueOf(nextData.getDayOfWeek()) - minArray[4]) / (maxArray[4] - minArray[4]));
                    label.putScalar(new int[] {index, 5, c}, (Double.valueOf(nextData.getDayOfYear()) - minArray[4]) / (maxArray[4] - minArray[4]));
                } else {
                    label.putScalar(new int[]{index, 0, c}, feedLabel(nextData));
                }
                curData = nextData;
            }
            if (exampleStartOffsets.size() == 0) break;
        }
        return new DataSet(input, label);
    }

    private double feedLabel(DailyData data) {
        double value;
        switch (category) {
            case INBCOST: value = (Double.valueOf(data.getInboundCost()) - minArray[0]) / (maxArray[0] - minArray[0]); break;
            case INVSIZE: value = (Double.valueOf(data.getInventorySize()) - minArray[1]) / (maxArray[1] - minArray[1]); break;
            case SALPRICE: value = (Double.valueOf(data.getSalesPrice()) - minArray[2]) / (maxArray[2] - minArray[2]); break;
            case SALSIZE: value = (Double.valueOf(data.getSalesSize()) - minArray[3]) / (maxArray[3] - minArray[3]); break;
            default: throw new NoSuchElementException();
        }
        return value;
    }

    @Override public int totalExamples() { return train.size() - exampleLength - predictLength; }

    @Override public int inputColumns() { return VECTOR_SIZE; }

    @Override public int totalOutcomes() {
        if (this.category.equals(PriceCategory.ALL)) return VECTOR_SIZE;
        else return predictLength;
    }

    @Override public boolean resetSupported() { return false; }

    @Override public boolean asyncSupported() { return false; }

    @Override public void reset() { initializeOffsets(); }

    @Override public int batch() { return miniBatchSize; }

    @Override public int cursor() { return totalExamples() - exampleStartOffsets.size(); }

    @Override public int numExamples() { return totalExamples(); }

    @Override public void setPreProcessor(DataSetPreProcessor dataSetPreProcessor) {
        throw new UnsupportedOperationException("Not Implemented");
    }

    @Override public DataSetPreProcessor getPreProcessor() { throw new UnsupportedOperationException("Not Implemented"); }

    @Override public List<String> getLabels() { throw new UnsupportedOperationException("Not Implemented"); }

    @Override public boolean hasNext() { return exampleStartOffsets.size() > 0; }

    @Override public DataSet next() { return next(miniBatchSize); }
    
    private List<Pair<INDArray, INDArray>> generateTestDataSet (List<DailyData> stockDataList) {
    	//stockDataList：用于预测的分割部分 2
    	int window = exampleLength + predictLength;//22+1
    	List<Pair<INDArray, INDArray>> test = new ArrayList<>();
    	for (int i = 0; i < stockDataList.size() ; i++) {//改i < stockDataList.size() - window; 
    		INDArray input = Nd4j.create(new int[] {exampleLength, VECTOR_SIZE}, 'f');//22行，每行6个0.00
    		for (int j = i; j < i + 2; j++) {//j < i + exampleLength;
    			DailyData stock = stockDataList.get(j);
    			input.putScalar(new int[] {j - i, 0}, (Double.valueOf(stock.getInboundCost()) - minArray[0]) / (maxArray[0] - minArray[0]));
    			input.putScalar(new int[] {j - i, 1}, (Double.valueOf(stock.getInventorySize()) - minArray[1]) / (maxArray[1] - minArray[1]));
    			input.putScalar(new int[] {j - i, 2}, (Double.valueOf(stock.getSalesPrice()) - minArray[2]) / (maxArray[2] - minArray[2]));
    			input.putScalar(new int[] {j - i, 3}, (Double.valueOf(stock.getSalesSize()) - minArray[3]) / (maxArray[3] - minArray[3]));
    			input.putScalar(new int[] {j - i, 4}, (Double.valueOf(stock.getDayOfWeek()) - minArray[4]) / (maxArray[4] - minArray[4]));
    			input.putScalar(new int[] {j - i, 4}, (Double.valueOf(stock.getDayOfYear()) - minArray[4]) / (maxArray[4] - minArray[4]));
    		}
    		DailyData stock = stockDataList.get(i + exampleLength);
            INDArray label;
            if (category.equals(PriceCategory.ALL)) {
                label = Nd4j.create(new int[]{VECTOR_SIZE}, 'f'); // ordering is set as 'f', faster construct
                label.putScalar(new int[] {0}, Double.valueOf(stock.getInboundCost()));
                label.putScalar(new int[] {1}, Double.valueOf(stock.getInventorySize()));
                label.putScalar(new int[] {2}, Double.valueOf(stock.getSalesPrice()));
                label.putScalar(new int[] {3}, Double.valueOf(stock.getSalesSize()));
                label.putScalar(new int[] {4}, Double.valueOf(stock.getDayOfWeek()));
                label.putScalar(new int[] {5}, Double.valueOf(stock.getDayOfYear()));
            } else {
                label = Nd4j.create(new int[] {1}, 'f');
                switch (category) {
                    case INBCOST: label.putScalar(new int[] {0}, Double.valueOf(stock.getInboundCost())); break;
                    case INVSIZE: label.putScalar(new int[] {0}, Double.valueOf(stock.getInventorySize())); break;
                    case SALPRICE: label.putScalar(new int[] {0}, Double.valueOf(stock.getSalesPrice())); break;
                    case SALSIZE: label.putScalar(new int[] {0}, Double.valueOf(stock.getSalesSize())); break;
                    default: throw new NoSuchElementException();
                }
                
            }
    		test.add(new Pair<>(input, label));
    	}
    	return test;
    }

	private List<DailyData> readStockDataFromFile (String filename, String symbol) {
        List<DailyData> stockDataList = new ArrayList<>();
        try {
            for (int i = 0; i < maxArray.length; i++) { // initialize max and min arrays
                maxArray[i] = Double.MIN_VALUE;
                minArray[i] = Double.MAX_VALUE;
            }
            List<String[]> list = new CSVReader(new FileReader(filename)).readAll(); // load all elements in a list
            for (String[] arr : list) {
            	if (arr[1].equals("inventorySize")) continue;
                double[] nums = new double[VECTOR_SIZE];
                for (int i = 0; i < arr.length - 1; i++) {
                    nums[i] = Double.valueOf(arr[i]);
                    if (nums[i] > maxArray[i]) maxArray[i] = nums[i];
                    if (nums[i] < minArray[i]) minArray[i] = nums[i];
                }
                stockDataList.add(new DailyData(nums[0], nums[1], nums[2], nums[3], nums[4],nums[5]));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return stockDataList;
    }
}


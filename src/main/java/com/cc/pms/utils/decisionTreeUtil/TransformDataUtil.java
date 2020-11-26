package com.cc.pms.utils.decisionTreeUtil;
/**
 * 2.转换数据格式
 * @author cc
 *
 */

import static org.apache.spark.sql.types.DataTypes.DoubleType;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.spark.ml.feature.StringIndexer;
import org.apache.spark.ml.feature.StringIndexerModel;
import org.apache.spark.ml.feature.VectorAssembler;
import org.apache.spark.ml.feature.VectorIndexer;
import org.apache.spark.ml.feature.VectorIndexerModel;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.functions;

public class TransformDataUtil {
	public static void main(String[] args) {
		String fileRoot = "D:/Eclipse_Workspace/SSM-PMS/src/main/resources/data/formatdata";
		File file=new File(fileRoot);
		deleteAllByPath(file);
	}
	/**
	 * 	删除某个目录下所有文件及文件夹
	 * @param rootFilePath 根目录
	 * @return boolean
	 */
	private static boolean deleteAllByPath(File rootFilePath) {
	    File[] needToDeleteFiles = rootFilePath.listFiles();
	    if (needToDeleteFiles == null) {
	        return true;
	    }
	    for (int i = 0; i < needToDeleteFiles.length; i++) {
	        if (needToDeleteFiles[i].isDirectory()) {
	            deleteAllByPath(needToDeleteFiles[i]);
	        }
	        try {
	            Files.delete(needToDeleteFiles[i].toPath());
	        } catch (IOException e) {
	            return false;
	        }
	    }
	    return true;
	}

	/**
	 * 	将有用的数据转换成特征向量
	 * @param dataset
	 * @return
	 * @throws FileNotFoundException
	 */
	public static List<Object> transformData(Dataset<Row> dataset) throws FileNotFoundException{
		Dataset<Row> data1 = dataset.select(
				functions.col("SepalLengthCm"),
				functions.col("SepalWidthCm"),
				functions.col("PetalLengthCm"),
				functions.col("PetalWidthCm"),
				functions.when(functions.col("Species").equalTo("Iris-setosa"), 1)
                	.when(functions.col("Species").equalTo("Iris-versicolor"), 2)
                	.when(functions.col("Species").equalTo("Iris-virginica"), 3)
                	.cast(DoubleType).as("SpeciesNum")
		);
		//data1.select("*").show(6,false);
		
		//将有用的数据转换成特征向量
		VectorAssembler assembler = new VectorAssembler()
                .setInputCols(new String[]{"SepalLengthCm", "SepalWidthCm", "PetalLengthCm","PetalWidthCm"})
                .setOutputCol("Features");
        Dataset<Row> data2 = assembler.transform(data1);
        //data2.show(6,false);
        
        //删除生成的数据文件
        String path = "src/main/resources/formatdata";
        File file = new File(path);
		deleteAllByPath(file);
        data2.write().format("parquet").save("src/main/resources/formatdata/formatirisdata");
        
        
		//使用StringIndexer将字符型的label变成index
		StringIndexerModel labelIndexer = new StringIndexer()
				  .setInputCol("SpeciesNum")
				  .setOutputCol("SpeciesIndex")
				  .fit(data2);
        
        // 自动识别分类的特征，并对它们进行索引
        // 具有大于5个不同的值的特征被视为连续。
        VectorIndexerModel featureIndexer = new VectorIndexer()
                .setInputCol("Features")
                .setOutputCol("FeaturesIndex")
                //.setMaxCategories(3)
                .fit(data2);
        List<Object> list=new ArrayList<>();
        list.add(0, data2);
        list.add(1,labelIndexer);
        list.add(2,featureIndexer);
		return list;
		
	}

}
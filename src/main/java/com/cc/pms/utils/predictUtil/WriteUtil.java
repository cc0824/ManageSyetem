package com.cc.pms.utils.predictUtil;

import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class WriteUtil {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		List<Double> list=new ArrayList<>();
		list.add(10.000001);
		list.add(11.1);
		//writeFileWithList("数据：",list);
		int a=2;
		System.out.println(a*1.0);

	}
	/**
	 * @param name 标题
	 * @param list 数据
	 */
	@SuppressWarnings("unchecked")
	public static void writeFileWithList(String name,List<? extends Number> list) {
		//1.创建源
		FileWriter fw = null;
        try {
            fw = new FileWriter("src\\com\\cc\\predictionAlgorithm\\result.txt", true);//路径一定要用"\\"
            fw.write(name+" ");
            for(Object data:list) {
            	//输出12位
            	fw.write(String.format("%-12s", data.toString()));
            }
            fw.write("\n");
            fw.flush();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (fw != null) {
                try {
                    fw.close();
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
        }
	}
	
	public static void writeFile(Double index) {
		//1.创建源
		FileWriter fw = null;
        try {
            fw = new FileWriter("src\\com\\cc\\predictionAlgorithm\\result.txt", true);//路径一定要用"\\"
            fw.write("平滑指数a="+index+"\n");
            fw.flush();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (fw != null) {
                try {
                    fw.close();
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
        }
	}
	public static void writeFile(String content) {
		//1.创建源
		FileWriter fw = null;
		try {
			fw = new FileWriter("src\\com\\cc\\predictionAlgorithm\\result.txt", true);//路径一定要用"\\"
			fw.write(content+"\n");
			fw.flush();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (fw != null) {
				try {
					fw.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}

}


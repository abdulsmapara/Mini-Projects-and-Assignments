package com.code.abdulsmapara;
import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;

import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;



public class AverageSalary {

public static class MapperClass extends
  Mapper<LongWritable, Text, Text, FloatWritable> {
 public void map(LongWritable key, Text empRecord, Context con)
   throws IOException, InterruptedException {
  String[] word = empRecord.toString().split("\\t");
  String gender = word[3];
  try {
   Float salary = Float.parseFloat(word[8]);
   con.write(new Text(gender), new FloatWritable(salary));
  } catch (Exception e) {
   e.printStackTrace();
  }
 }
}

public static class ReducerClass extends
  Reducer<Text, FloatWritable, Text, Text> {
 public void reduce(Text key, Iterable<FloatWritable> valueList,
   Context con) throws IOException, InterruptedException {
  try {
   Float total = (float) 0;
   int count = 0;
   for (FloatWritable var : valueList) {
    total += var.get();
    System.out.println("reducer " + var.get());
    count++;
   }
   Float avg = (Float) total / count;
   String out = "Total: " + total + " and " + "Average: " + avg;
   con.write(key, new Text(out));
  } catch (Exception e) {
   e.printStackTrace();
  }
 }
}

public static void main(String[] args) {
		 Configuration conf = new Configuration();
		 try {
			  Job job = new Job(conf, "AverageSalary");
			  job.setJarByClass(AverageSalary.class);
			  job.setMapperClass(MapperClass.class);
			  job.setReducerClass(ReducerClass.class);
			  job.setOutputKeyClass(Text.class);
			  job.setOutputValueClass(FloatWritable.class);
			   Path p1 = new Path(args[0]);
			   Path p2 = new Path(args[1]);
			   FileInputFormat.addInputPath(job, p1);
			   FileOutputFormat.setOutputPath(job, p2);
			  
			  System.exit(job.waitForCompletion(true) ? 0 : 1);
		 }catch (Exception e) {
			 e.printStackTrace();
		 } 

	}
}

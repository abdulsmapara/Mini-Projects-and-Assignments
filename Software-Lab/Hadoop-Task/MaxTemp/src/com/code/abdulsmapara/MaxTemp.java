package com.code.abdulsmapara;
import org.apache.hadoop.fs.Path;

import java.io.IOException;
import java.util.Iterator;

import org.apache.hadoop.conf.*;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.*;
import org.apache.hadoop.util.*;


public class MaxTemp extends Configured implements Tool{
      public int run(String[] args) throws Exception
      {
            
            JobConf conf = new JobConf(getConf(), MaxTemp.class);
            conf.setJobName("MaxTemp");

         
            conf.setOutputKeyClass(Text.class);
            
            conf.setOutputValueClass(DoubleWritable.class);

            
            conf.setMapperClass(HighestMapper.class);
            conf.setReducerClass(HighestReducer.class);
            
            Path inp = new Path(args[0]);
            Path out = new Path(args[1]);
            
            FileInputFormat.addInputPath(conf, inp);
            FileOutputFormat.setOutputPath(conf, out);

            JobClient.runJob(conf);
            return 0;
      }
     
      public static void main(String[] args) throws Exception
      {
           
        int res = ToolRunner.run(new Configuration(), new MaxTemp(),args);
            System.exit(res);
      }
}

class HighestMapper extends MapReduceBase implements Mapper<LongWritable, Text, Text, DoubleWritable>
{
            public static final int MISSING = 9999;
     
            public void map(LongWritable key, Text value, OutputCollector<Text, DoubleWritable> output, Reporter reporter) throws IOException
      {
            String line = value.toString();
            String year = line.substring(15,19);               
            double temperature;                    
            if (line.charAt(87)=='+')
                        temperature = Double.parseDouble(line.substring(88, 92));
            else
                        temperature = Double.parseDouble(line.substring(87, 92));       
           
            String quality = line.substring(92, 93);
            if(temperature != MISSING && quality.matches("[01459]"))
            output.collect(new Text(year),new DoubleWritable(temperature));
                 
            }
       
}


class HighestReducer extends MapReduceBase implements Reducer<Text, DoubleWritable, Text, DoubleWritable>
{
      
      public void reduce(Text key, Iterator<DoubleWritable> values, OutputCollector<Text, DoubleWritable> output, Reporter reporter) throws IOException
      {
        double max_temp = 0; 
        ; 
          while (values.hasNext())
                      {
              double current=values.next().get();
                         if ( max_temp <  current)  
                               max_temp =  current;
                      }
          output.collect(key, new DoubleWritable(max_temp/10.0));

      }

      
            
      
      
}
      
      
      
      
     

      
      
      
                         

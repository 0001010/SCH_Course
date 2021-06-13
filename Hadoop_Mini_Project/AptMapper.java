package Apt;
import java.io.IOException;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class AptMapper extends Mapper<LongWritable, Text, Text, DoubleWritable> {
	@Override
	protected void map(LongWritable key, Text value, Context context)
			throws IOException, InterruptedException{
		String line = value.toString();
		String[] items = line.split(",");
		String signgu = items[0];
		String gu = signgu.substring(6,9);
		double area = Double.parseDouble(items[5]);
		double price = Double.parseDouble(items[8]);
		double perprice = price/area*3.3;
		context.write(new Text(gu), new DoubleWritable(perprice));
	}
}

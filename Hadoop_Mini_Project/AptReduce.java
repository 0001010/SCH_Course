package Apt;
import java.io.IOException;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class AptReduce extends Reducer<Text, DoubleWritable, Text, DoubleWritable>{
	@Override
	protected void reduce(Text key, Iterable<DoubleWritable> values, Context context)
			throws IOException, InterruptedException {
		int valcount = 0;
		double valavg = 0;
		for (DoubleWritable value : values) {
			valavg += value.get();
			valcount++;
		}
		valavg /= valcount;
		context.write(key, new DoubleWritable(valavg));
	}
}
import std;
T[K] kmeans(int K, alias distancefun, T)(T[] data, int iterations = 100) {
	T[K] output;
	foreach (ref e; output) {
		e = data[uniform(0, $)];
	}
	foreach (i; 0 .. iterations) {
		int[K] counts=0;
		T[K] average=0;
		foreach (d; data) {
			int closest;
			auto minDist = typeof(distancefun(d, output[0])).max;
			foreach (j; 0 .. K) {
				auto dist = distancefun(d, output[j]);
				if (dist < minDist) {
					minDist = dist;
					closest = j;
				}
			}
			counts[closest]++;
			average[closest]+=d;
		}
		foreach(i_,ref e;average){
			if(counts[i_]!=0){
				e/=counts[i_];
			}
		}
		output=average;
	}
	return output;
}
unittest{
	float[] arr = [451, 453, 451, 450, 109, 108, 114, 503, 506, 504, 557, 557, 557, 557, 103, 103, 613, 611, 611, 119, 664, 665, 664, 664, 667, 823, 824, 877, 877, 983, 983, 931, 930, 717, 717, 715, 715, 769, 768];
	float F(float a,float b){
		return abs(a-b);
	}
	arr.kmeans!(15,F)(1000).array.sort.writeln;
}
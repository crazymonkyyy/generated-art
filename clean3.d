import std;
struct Color
{
    ubyte r; // Color red value
    ubyte g; // Color green value
    ubyte b; // Color blue value
    ubyte a; // Color alpha value
}
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
Color tocolor(char[] s){
	auto d=s.chunks(2).map!(a=>a.to!ubyte(16)).array;
	return Color(d[0],d[1],d[2],255);
}
string tohex(Color c){
    return format("%02X%02X%02X", c.r, c.g, c.b);
}
void replacebestmatch(alias distencefun,T)(ref T value,T[] pattern){
	size_t i;
	typeof(distencefun(T.init,T.init)) best;
	best=typeof(best).max;
	foreach(j,e;pattern){
		auto temp=distencefun(value,e);
		if(temp<best){
			best=temp;
			i=j;
		}
	}
	value=pattern[i];
}
void main(){
	Color[] c;
	float[] x;
	float[] y;
	foreach(d;File("ballsv1").byLine.map!(a=>a.splitter(' ').array)){
		c~=d[0].tocolor;
		x~=d[1].to!float;
		y~=d[2].to!float;
	}
	Color[] solarize=File("solarized-dark.csv").byLine.array[0].splitter(',')
			.filter!(a=>a.length>1).map!tocolor.array;
	auto distance(Color a, Color b) {
		return abs(a.r - b.r) + abs(a.g - b.g) + abs(a.b - b.b);
	}
	foreach(ref e;c){
		e.replacebestmatch!distance(solarize);
	}
	foreach(i;0..c.length){
		solarize.countUntil(c[i]).write(' ');
		((round((x[i]-450)/52)*52)+30+52/*+450*/).write(' ');
		((round((y[i]-310)/52)*52)+30/*+310*/).writeln;
	}
	//y.sort.writeln;
	//y.sort.slide(2).map!(a=>a[1]-a[0]).filter!(a=>a>10).mean.writeln;
}
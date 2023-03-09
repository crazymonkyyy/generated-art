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
unittest{
	import std;
	auto pattern=[1,3,10];
	auto arr=iota(-4,20).array;
	auto F(int a,int b){
		return abs(a-b);
	}
	foreach(ref e;arr){
		e.replacebestmatch!F(pattern);
	}
	arr.writeln;
}
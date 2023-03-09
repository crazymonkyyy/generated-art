import std;

void main(){
	foreach(s;File("data2").byLineCopy.array.sort){
		s[0..7].write;
		s=s[9..$];
		float x=0;
		float y=0;
		int count=0;
		foreach(t;s.splitter('C').map!(a=>a.splitter(' ').filter!(a=>a.length>1))){
			foreach(u;t.chunks(3).map!(a=>a.array[2]).map!(a=>a.split(',').array)){
				x+=u[0].to!float;
				y+=u[1].to!float;
				count++;
			}
	}
	(x/count).write(' ');
	(y/count).writeln;
	//count.writeln;
}}
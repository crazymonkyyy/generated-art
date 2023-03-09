import std;

void main(){
	foreach(s;File("data").byLine){
		auto i=s.countUntil('|');
		auto j=s.countUntil('C');
		s[0..i+1].write;
		s[j+1..$].writeln;
}}
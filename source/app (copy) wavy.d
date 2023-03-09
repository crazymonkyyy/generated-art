import raylib;
import std;
enum windowx=840;
enum windowy=320;
enum filename="base-16.csv";
Color tocolor(string s){
	auto d=s.chunks(2).map!(a=>a.to!ubyte(16)).array;
	return Color(d[0],d[1],d[2],255);
}

struct point{
	Vector2 pos; alias pos this;
	ubyte c;
}
enum Color[16][string] base16=(){
	Color[16][string] o;
	foreach(s;import(filename).split('\n')){
		auto a=s.splitter(',').array.to!(string[]);
		o[a[0]]=a[1..$].filter!(a=>a.length==6).map!tocolor.staticArray!16;
	}
	return o;
}();
string theme="solarized-dark";
Color color(point p){
	return base16[theme][p.c];
}
point[] points;
void main(){
	InitWindow(windowx, windowy, "Hello, Raylib-D!");
	SetWindowPosition(1800,0);
	SetTargetFPS(60);
	auto wallpaper=LoadTexture("wallpaper.png");
	foreach(d;File("ballsv4").byLine.map!(a=>a.splitter(' ').array)){
		points~=point(Vector2(d[1].to!float,d[2].to!float),d[0].to!ubyte);
	}
	//while (!WindowShouldClose()){
	foreach(k,v;base16){
	foreach(zzz;0..11){
		theme=k;
		BeginDrawing();
			ClearBackground(base16[theme][0]);
			//DrawTexture(wallpaper,0,0,Color(255,255,255,128));
			//DrawText("Hello, World!", 10,10, 20, Colors.WHITE);
			//foreach(e;points){
			//	if(e.c){
			//		DrawCircleV(e,20,e.color);
			//	} else {
			//		DrawRing(e,19,20,0,360,20,base16[theme][4]);
			//	}
			//}
			foreach(i;0..10000){
			//foreach(x;0..windowx){
			//foreach(y;0..windowy){
				auto x=uniform(0,windowx);
				auto y=uniform(0,windowy);
				ubyte c;
				float dis=9999;
				Vector2 v=Vector2(x,y);
				foreach(p;points){
					auto t=Vector2Distance(v,p);
					if(t<dis){
						dis=t;
						c=p.c;
					}
				}
				float size=9999;
				foreach(p;points){
					if(p.c!=c){
						size=min(max(size-dis,10),Vector2Distance(v,p));
					}
				}
				DrawCircleV(v,size,base16[theme][c]);
			}
			//DrawFPS(10,10);
		EndDrawing();
		//readln;
		TakeScreenshot(("wallpaper-wavy/"~theme~"-"~zzz.to!string~".png").toStringz);
	}}
	CloseWindow();
}
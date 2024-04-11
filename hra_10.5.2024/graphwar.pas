program graphwar;
uses graph,crt;
const k=50;
      hracr=20;
type Thrac=record
  x,y:integer;
  end;
var
  gd,gm:smallint;
  i,j:integer;
  hraci: array [1..2] of Thrac;
procedure panacik(panacikx,panaciky:integer);
begin
   setfillstyle(1,red);setcolor(red);
   FillEllipse(panacikx,panaciky,hracr,hracr);
end;

procedure generovanie(level:integer);
var
  randx,randy,randr,rand,pocc,rx,ry:integer;
begin
  case level of
  1:rand:=0;
  2:rand:=10;
  3:rand:=20;
  4:rand:=30;
  end;

  hraci[1].x:=100+hracr+random(((getmaxx-200)div 2)-(2*hracr));
  hraci[1].y:=100+hracr+random(getmaxy-300-(2*hracr));
  panacik(hraci[1].x,hraci[1].y);
  hraci[2].x:=(getmaxx div 2)+hracr+random(((getmaxx-100) div 2)-(2*hracr));
  hraci[2].y:=100+hracr+random(getmaxy-300-(2*hracr));
  panacik(hraci[2].x,hraci[2].y);

  setfillstyle(1,green);setcolor(green);
  for i:=1 to random(rand) do begin
      repeat
         randr:=random(100)+1;
         randx:=randr+100+random(getmaxx-200-(2*randr));
         randy:=randr+100+random(getmaxy-300-(2*randr));
         pocc:=0;
         for j:=1 to 2 do begin
             if hraci[j].x>randx then rx:=hraci[j].x-randx
             else if hraci[j].x<randx then rx:=randx-hraci[j].x
             else rx:=1;

             if hraci[j].y>randy then ry:=hraci[j].y-randy
             else if hraci[j].y<randy then ry:=randy-hraci[j].y
             else ry:=1;

             if round(sqrt(rx*rx+ry*ry))<randr+hracr+1 then pocc:=pocc+1;
         end;
      until pocc=0;
      FillEllipse(randx,randy,randr,randr);
  end;




end;

procedure pole();
var
  cislox,cisloy:integer;
  cx,cy:string;
begin
  rectangle(100,100,getmaxx-100,getmaxy-200);
  moveto((getmaxx div 2)-70,(getmaxy-100) div 2);setcolor(white);
  outtext('loading...');
  SetFillStyle(1,lightgray);      //pozadie
  bar(0,0,getmaxx,100);
  bar(0,0,100,getmaxy);
  bar(getmaxx-100,0,getmaxx,getmaxy);
  bar(0,getmaxy-200,getmaxx,getmaxy);


  SetFillStyle(1,white);
  bar(0,0,20,getmaxy);      //vlavo vonku
  bar(0,0,getmaxx,20);      //hore vonku
  bar(80,getmaxy-200,getmaxx-80,getmaxy-180);    //dole vnutri
  bar(getmaxx-100,80,getmaxx-80,getmaxy-180);    //vpravo vnutri

  setfillstyle(1,darkgray);setcolor(darkgray);
  bar(getmaxx-20,20,getmaxx,getmaxy);    //vpravo vonku
  bar(20,getmaxy-20,getmaxx,getmaxy);      //dole vonku
  bar(80,80,getmaxx-100,100);      //hore vnutri
  bar(80,80,100,getmaxy-200);      //vlavo vnutri
  line(0,getmaxy,20,getmaxy-20);     //lavy dolny roh vonku
  line(0,getmaxy,20,getmaxy);
  floodfill(10,getmaxy-5,darkgray);
  line(80,getmaxy-180,80,getmaxy-200);   //lavy dolny roh vnutri
  line(80,getmaxy-180,100,getmaxy-200);
  floodfill(90,getmaxy-190,darkgray);
  line(getmaxx,0,getmaxx-20,20);   // pravy horny roh vonku
  line(getmaxx,0,getmaxx,20);
  floodfill(getmaxx-5,10,darkgray);
  line(getmaxx-80,80,getmaxx-100,80);    //pravy horny roh vnutri
  line(getmaxx-80,80,getmaxx-100,100);
  floodfill(getmaxx-95,85,darkgray);

  setfillstyle(1,black);
  bar((getmaxx div 2)-70,(getmaxy-100) div 2,(getmaxx div 2)+30,((getmaxy-100) div 2) +20); //vymazanie "loading..."

  setcolor(yellow);                                     //osi
  line(getmaxx div 2,101,getmaxx div 2,getmaxy-201);
  line(101,(getmaxy-101) div 2,getmaxx-101,(getmaxy-101) div 2);


  setcolor(green);
  cisloy:=round((getmaxy-300)/k);              //hodnoty osi y
  str(cisloy,cy);
  moveto((getmaxx div 2)-7,90); outtext(cy);
  cy:='-'+cy;
  moveto((getmaxx div 2)-14,getmaxy-195); outtext(cy);

  cislox:=round((getmaxx-200)/k);              //hodnoty osi x
  str(cislox,cx);
  moveto(getmaxx-98,((getmaxy-100)div 2)-4); outtext(cx);
  cx:='-'+cx;
  moveto(78,((getmaxy-100)div 2)-4); outtext(cx);


  generovanie(4);


end;
begin
  randomize;
  gd:=detect;
  initgraph(gd,gm,'C:\lazarus');
  pole();

  readln();
  closegraph();







end.


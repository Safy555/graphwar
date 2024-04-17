program graphwar;
uses graph,wincrt;
const k=20;  //kolko pixelov je jeden dielik
      hracr=20; //polomer kruhu hraca
type Thrac=record
  x,y:integer;
  end;
var
  gd,gm:smallint;
  i,j,stavhry:integer;
  input:string;
  ch:char;
  hraci: array [1..2] of Thrac;
procedure panacik(panacikx,panaciky:integer;strana:string);
begin
   setfillstyle(1,red);setcolor(red);
   FillEllipse(panacikx,panaciky,hracr,hracr);
   if strana='l' then begin
        setfillstyle(1,white);setcolor(white);
        FillEllipse(panacikx-(hracr div 2),panaciky-(hracr div 4),(hracr div 4),(hracr div 4));
        setfillstyle(1,black);setcolor(black);
        FillEllipse(panacikx-(hracr div 2),panaciky-(hracr div 4),(hracr div 10),(hracr div 10))
   end
   else if strana='p' then begin
        setfillstyle(1,white);setcolor(white);
        FillEllipse(panacikx+(hracr div 2),panaciky-(hracr div 4),(hracr div 4),(hracr div 4));
        setfillstyle(1,black);setcolor(black);
        FillEllipse(panacikx+(hracr div 2),panaciky-(hracr div 4),(hracr div 10),(hracr div 10))
   end;
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
  panacik(hraci[1].x,hraci[1].y,'p');                    //generovanie panacika vlavo
  hraci[2].x:=(getmaxx div 2)+hracr+random(((getmaxx-200) div 2)-(2*hracr));
  hraci[2].y:=100+hracr+random(getmaxy-300-(2*hracr));
  panacik(hraci[2].x,hraci[2].y,'l');                    //generovanie panacika vpravo

  setfillstyle(1,green);setcolor(green);
  for i:=1 to rand do begin
      repeat
         randr:=random(80)+20;
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

function fx(input1:string; c:integer):integer;
var
  i,poc:integer;
  x,res:real;
  s1,s2:string;
begin
  x:=c/k;
  if pos('x',lowercase(input1))<1 then fx:=hraci[1].y  //konstanty napr. y=2
  else begin
    poc:=0;
    for i:=1 to length(input1) do begin
        if (input1[i]='+') or (input1[i]='-') or (input1[i]='*') or (input1[i]='/') then poc:=poc+1;
    end;

    if poc=0 then res:=-x*k    //y=x
    else begin
         for i:=1 to poc do begin
             //s1:=copy(input1,1,);




         end;
    end;
    fx:=round(res+((getmaxy-100) div 2));
  end;
end;

procedure vykreslenie();
var
  j:integer;
begin
   for j:=-((getmaxx-200) div 2) to ((getmaxx-200) div 2) do begin
       if (fx(input,j)+((getmaxy-100) div 2)<getmaxy-200) and (fx(input,j)>100) then putpixel(j+(getmaxx div 2),fx(input,j),5);
   end;
end;

procedure pole();          //pozadie
var
  cislox,cisloy:integer;
  cx,cy:string;
begin
  rectangle(100,100,getmaxx-100,getmaxy-200);
  moveto((getmaxx div 2)-70,(getmaxy-100) div 2);setcolor(white);
  outtext('loading...');

  //pozadie
  SetFillStyle(1,lightgray);
  bar(0,0,getmaxx,100);
  bar(0,0,100,getmaxy);
  bar(getmaxx-100,0,getmaxx,getmaxy);
  bar(0,getmaxy-200,getmaxx,getmaxy);

  // pole na predpis
  setfillstyle(1,black);
  bar(200,getmaxy-120,getmaxx-200,getmaxy-80);
  setfillstyle(1,darkgray);
  bar(180,getmaxy-140,getmaxx-180,getmaxy-120);
  bar(180,getmaxy-140,200,getmaxy-60);
  setfillstyle(1,white);
  bar(getmaxx-180,getmaxy-60,getmaxx-200,getmaxy-120);
  bar(getmaxx-180,getmaxy-60,200,getmaxy-80);
  line(180,getmaxy-60,200,getmaxy-80);
  line(180,getmaxy-60,200,getmaxy-60);
  line(getmaxx-200,getmaxy-120,getmaxx-180,getmaxy-140);
  line(getmaxx-180,getmaxy-140,getmaxx-180,getmaxy-120);
  floodfill(190,getmaxy-65,white);
  floodfill(getmaxx-190,getmaxy-125,white);



  SetTextStyle (0,0,2);setcolor(green);
  outtextxy(220,getmaxy-110,'y=');
  SetTextStyle (0,0,1);


  SetFillStyle(1,white);
  //vlavo vonku
  bar(0,0,20,getmaxy);
  //hore vonku
  bar(0,0,getmaxx,20);
  //dole vnutri
  bar(80,getmaxy-200,getmaxx-80,getmaxy-180);
  //vpravo vnutri
  bar(getmaxx-100,80,getmaxx-80,getmaxy-180);


  setfillstyle(1,darkgray);setcolor(darkgray);
  //vpravo vonku
  bar(getmaxx-20,20,getmaxx,getmaxy);
  //dole vonku
  bar(20,getmaxy-20,getmaxx,getmaxy);
  //hore vnutri
  bar(80,80,getmaxx-100,100);
  //vlavo vnutri
  bar(80,80,100,getmaxy-200);
  //lavy dolny roh vonku
  line(0,getmaxy,20,getmaxy-20);
  line(0,getmaxy,20,getmaxy);
  floodfill(10,getmaxy-5,darkgray);
  //lavy dolny roh vnutri
  line(80,getmaxy-180,80,getmaxy-200);
  line(80,getmaxy-180,100,getmaxy-200);
  floodfill(90,getmaxy-190,darkgray);
   // pravy horny roh vonku
  line(getmaxx,0,getmaxx-20,20);
  line(getmaxx,0,getmaxx,20);
  floodfill(getmaxx-5,10,darkgray);
  //pravy horny roh vnutri
  line(getmaxx-80,80,getmaxx-100,80);
  line(getmaxx-80,80,getmaxx-100,100);
  floodfill(getmaxx-95,85,darkgray);


  //vymazanie "loading..."
  setfillstyle(1,black);
  bar((getmaxx div 2)-70,(getmaxy-100) div 2,(getmaxx div 2)+30,((getmaxy-100) div 2) +20);


  //osi
  setcolor(yellow);
  line(getmaxx div 2,101,getmaxx div 2,getmaxy-201);
  line(101,(getmaxy-101) div 2,getmaxx-101,(getmaxy-101) div 2);


  setcolor(green);
  //hodnoty osi y
  cisloy:=round(((getmaxy-300) div 2)/k);
  str(cisloy,cy);
  moveto((getmaxx div 2)-7,90); outtext(cy);
  cy:='-'+cy;
  moveto((getmaxx div 2)-14,getmaxy-195); outtext(cy);


  //hodnoty osi x
  cislox:=round(((getmaxx-200) div 2)/k);
  str(cislox,cx);
  moveto(getmaxx-98,((getmaxy-100)div 2)-4); outtext(cx);
  cx:='-'+cx;
  moveto(78,((getmaxy-100)div 2)-4); outtext(cx);




  generovanie(4);


end;

procedure predpis();
begin
  input:='';
  moveto(250,getmaxy-110);
  SetTextStyle (0,0,2);setcolor(green);
  repeat
      if keypressed then begin
        ch:=readkey;
        if (((ord(ch)>=40)and(ord(ch)<=57))or (ord(ch)=88) or (ord(ch)=120)) and ((ch<>#13)or(ch<>#8)) then begin
           outtext(ch);
           input:=input+ch;
        end;
        if (ch=#8) then begin
          input:='';
          setfillstyle(1,black);
          bar(250,getmaxy-110,getmaxx-200,getmaxy-90);
          moveto(250,getmaxy-110);
        end;
      end;
  until (ch=#13) and (length(input)>0);
  SetTextStyle (0,0,1);setcolor(white);
end;

procedure hra();
begin
end;

begin
  randomize;
  gd:=detect;
  initgraph(gd,gm,'C:\lazarus');
  pole();
  predpis();
  vykreslenie();



  readln();
  closegraph();
end.


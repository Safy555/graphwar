program graphwar;
uses graph,wincrt;
const k=50;  //kolko pixelov je jeden dielik
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
procedure box(stred_x,stred_y,sirka,vyska,border:integer; farba_stred,farba_vlavo,farba_vpravo:word);
begin
  setfillstyle(1,farba_stred);
  bar(stred_x-(sirka div 2)+border,stred_y-(vyska div 2)+border,stred_x+(sirka div 2)-border,stred_y+(vyska div 2)-border);
  setfillstyle(1,farba_vlavo);
  bar(stred_x-(sirka div 2),stred_y-(vyska div 2),stred_x+(sirka div 2),stred_y-(vyska div 2)+border);
  bar(stred_x-(sirka div 2),stred_y-(vyska div 2),stred_x-(sirka div 2)+border,stred_y+(vyska div 2));
  setfillstyle(1,farba_vpravo);setcolor(farba_vpravo);
  bar(stred_x+(sirka div 2),stred_y+(vyska div 2),stred_x-(sirka div 2)+border,stred_y+(vyska div 2)-border);
  bar(stred_x+(sirka div 2),stred_y+(vyska div 2),stred_x+(sirka div 2)-border,stred_y-(vyska div 2)+border);
  line(stred_x-(sirka div 2),stred_y+(vyska div 2),stred_x-(sirka div 2)+border,stred_y+(vyska div 2));
  line(stred_x-(sirka div 2),stred_y+(vyska div 2),stred_x-(sirka div 2)+border,stred_y+(vyska div 2)-border);
  line(stred_x+(sirka div 2),stred_y-(vyska div 2),stred_x+(sirka div 2)-border,stred_y-(vyska div 2)+border);
  line(stred_x+(sirka div 2),stred_y-(vyska div 2),stred_x+(sirka div 2),stred_y-(vyska div 2)+border);
  floodfill(stred_x-(sirka div 2)+border-2,stred_y+(vyska div 2)-(border div 2),farba_vpravo);
  floodfill(stred_x+(sirka div 2)-(border div 2),stred_y-(vyska div 2)+border-2,farba_vpravo);

end;

procedure panacik(panacikx,panaciky:integer;strana:string);  //vypis hracov
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

procedure generovanie(level:integer);   //generovanie prekazok,hracov
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
  hraci[1].y:=110+hracr+random(getmaxy-300-(3*hracr));
  panacik(hraci[1].x,hraci[1].y,'p');                    //generovanie panacika vlavo
  hraci[2].x:=(getmaxx div 2)+hracr+random(((getmaxx-200) div 2)-(2*hracr));
  hraci[2].y:=110+hracr+random(getmaxy-300-(3*hracr));
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

             if round(sqrt(rx*rx+ry*ry))<randr+hracr+21 then pocc:=pocc+1;
         end;
      until pocc=0;
      FillEllipse(randx,randy,randr,randr);
  end;




end;

function fx(input1:string; c:integer):integer;   //vypocet funkcnej hodnoty
var
  i,j,poc,poc1,kod,cislo,posz:integer;
  x,res:real;
  s1,s2,znamienko:string;
begin
  x:=c/k;
  if pos('x',lowercase(input1))<1 then fx:=hraci[1].y  //konstanty napr. y=2
  else begin
       res:=0;
       poc:=0;
       for i:=1 to length(input1) do begin
          if (input1[i]='+') or (input1[i]='-') or (input1[i]='*') or (input1[i]='/') then poc:=poc+1;
       end;
       for i:=1 to poc do begin
          posz:=0;
          poc1:=0;
          znamienko:=input1[1]; delete(input1,1,1);
          if i<>poc then begin
               repeat
                  poc1:=poc1+1;
                  if (input1[poc1]='+') or (input1[poc1]='-') or (input1[poc1]='*') or (input1[poc1]='/') then posz:=poc1;
               until posz<>0;
               s1:=copy(input1,1,posz-1); delete(input1,1,posz-1);
          end
          else  s1:=input1;
          if znamienko='+' then begin
               if s1<>'x' then begin
                 val(s1,cislo,kod);
                 res:=res+cislo;
               end
               else res:=res+x;
          end
          else if znamienko='-' then begin
               if s1<>'x' then begin
                 val(s1,cislo,kod);
                 res:=res-cislo;
               end
               else res:=res-x;
          end
          else if znamienko='*' then begin
               if s1<>'x' then begin
                 val(s1,cislo,kod);
                 res:=res*cislo;
               end
               else res:=res*x;
          end
          else if znamienko='/' then begin
               if s1<>'x' then begin
                 val(s1,cislo,kod);
                 res:=res/cislo;
               end
               else res:=res/x;
          end;

       end;
       fx:=round(-res*k+((getmaxy-100) div 2));
  end;
end;

procedure vykreslenie(hracx,hracy:integer);  //vykreslenie funckie
var
  j,p,poc:integer;
begin
   poc:=0;
   p:=hraci[1].y-fx(input,hracx-100-((getmaxx-200) div 2));
   j:=hracx-100-((getmaxx-200) div 2)-1;
   repeat
      poc:=poc+1;
      j:=j+1;
      if getpixel(j+(getmaxx div 2),fx(input,j)+p)=green then begin
           setcolor(black);setfillstyle(1,black);
           FillEllipse(j+(getmaxx div 2),fx(input,j)+p,20,20);
           setcolor(5);
           stavhry:=2;
      end
      else if (getpixel(j+(getmaxx div 2),fx(input,j)+p)=red) and ((hracx+poc)-(hracx)>(hracr+5)) then begin
           stavhry:=1;
      end
      else begin
         putpixel(j+(getmaxx div 2),fx(input,j)+p,5);
         delay(1);
      end;
   until (j=((getmaxx-200) div 2)) or ((fx(input,j)+p>getmaxy-200)) or ((fx(input,j)+p<100)) or (stavhry<>0);


end;

procedure pole();    //pozadie
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

procedure predpis();  //input predpisu
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
          bar(250,getmaxy-110,getmaxx-220,getmaxy-90);
          moveto(250,getmaxy-110);
        end;
        if (ch=#13) and ((input[1]='*') or (input[1]='/') or (input[1]='.') or (input[1]=',')) then begin
          input:='';
          setfillstyle(1,black);
          bar(250,getmaxy-110,getmaxx-220,getmaxy-90);
          moveto(250,getmaxy-110);
        end;
      end;
  until (ch=#13) and (length(input)>0);
  if (input[1]<>'+') and (input[1]<>'-') then insert('+',input,1);
  SetTextStyle (0,0,1);setcolor(white);
  moveto(100,20);
  outtext(input);
end;

procedure menu(moznosti:integer);
var
  space_cele,space_moznost:integer;
begin
  SetFillStyle(1,lightgray);
  bar(0,0,getmaxx,getmaxy);
  SetFillStyle(1,white);
  //vlavo vonku
  bar(0,0,20,getmaxy);
  //hore vonku
  bar(0,0,getmaxx,20);


  setfillstyle(1,darkgray);setcolor(darkgray);
  //vpravo vonku
  bar(getmaxx-20,20,getmaxx,getmaxy);
  //dole vonku
  bar(20,getmaxy-20,getmaxx,getmaxy);
  //lavy dolny roh vonku
  line(0,getmaxy,20,getmaxy-20);
  line(0,getmaxy,20,getmaxy);
  floodfill(10,getmaxy-5,darkgray);
   // pravy horny roh vonku
  line(getmaxx,0,getmaxx-20,20);
  line(getmaxx,0,getmaxx,20);
  floodfill(getmaxx-5,10,darkgray);

  settextstyle(0,0,10);setcolor(green);
  outtextxy((getmaxx div 2)-300,50,'Graphwar');
  settextstyle(0,0,1);setcolor(white);
  line(0,150,getmaxx,150);
  line(0,getmaxy-100,getmaxx,getmaxy-100);

  space_cele:=getmaxy-250;
  space_moznost:=(space_cele-(moznosti)*40) div moznosti;

  for i:=1 to moznosti do begin
     SetFillStyle(1,white);
    //vlavo vonku
    //bar((getmaxx div 2)-100,40+space_moznost,(getmaxx div 2)-80,);
    //hore vonku
    bar(0,0,getmaxx,20);


    setfillstyle(1,darkgray);setcolor(darkgray);
    //vpravo vonku
    bar(getmaxx-20,20,getmaxx,getmaxy);
    //dole vonku
    bar(20,getmaxy-20,getmaxx,getmaxy);
    //lavy dolny roh vonku
    line(0,getmaxy,20,getmaxy-20);
    line(0,getmaxy,20,getmaxy);
    floodfill(10,getmaxy-5,darkgray);
     // pravy horny roh vonku
    line(getmaxx,0,getmaxx-20,20);
    line(getmaxx,0,getmaxx,20);
    floodfill(getmaxx-5,10,darkgray);

  end;

end;

procedure hra();
begin


end;

begin
  randomize;
  gd:=detect;
  initgraph(gd,gm,'C:\lazarus');
  //pole();
  //predpis();
  //vykreslenie(hraci[1].x,hraci[1].y);
  //menu(4);
  box(200,100,200,100,20,lightgray,white,darkgray);
  box(getmaxx div 2, getmaxy div 2,500,400,100,green,red,blue);
  readln();
  closegraph();
end.


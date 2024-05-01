program graphwar;
uses graph,wincrt;
const k=50;  //kolko pixelov je jeden dielik
      hracr=20; //polomer kruhu hraca
      suborc='subor.txt';
type Thrac=record
  x,y:integer;
  end;
  Tscore=record
    scorehraca:integer;
    menohraca:string[20];
  end;
var
  gd,gm:smallint;
  i,j,stavhry,esc:integer;
  input,input_old,meno:string;
  ch:char;
  hrac:Tscore;
  hraci: array [1..2] of Thrac;
  player:array [1..60] of Tscore;
  subor:file of Tscore;
function StringToReal(s:string):real;
  var
    code:integer;
    value:real;
  begin
    Val(s,value,code);
    if code=0 then
      StringToReal:=value
    else
      StringToReal:= 0.0; // Return 0.0 if conversion fails
  end;

procedure tabulka();
var i,j:integer;
begin
 for i:=1 to 60 do
  begin
   for j:=1 to 60-i do
    begin
      if player[j].scorehraca < player[j+1].scorehraca  then
      begin
       hrac:=player[j];
       player[j]:=player[j+1];
       player[j+1]:=hrac;
      end
    end;
  end;
end;

procedure prepis_do_subor();
var x:integer;
begin
  x:=0;
  rewrite(subor);
  repeat
    x:=x+1;
    write(subor,player[x]);
  until x = 60;
  close(subor);
end;

procedure prepis_do_pola();
var i:integer;
begin
  reset(subor);
  for i:=1 to filesize(subor) do begin
    read(subor,player[i]);
  end;
  close(subor);
end;

procedure box(stred_x,stred_y,sirka,vyska,border:integer; farba_stred,farba_vlavo,farba_vpravo:word);    //box s tienmi
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
  i,j,poc,poc1,kod,posz:integer;
  x,res,cislo:real;
  s1,s2,znamienko:string;
begin
  x:=c/k;
  if (pos('x',lowercase(input1))<1)  then fx:=hraci[1].y  //konstanty napr. y=2
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
               if lowercase(s1)<>'x' then begin
                 cislo:=StringToReal(s1);
                 res:=res+cislo;
               end
               else res:=res+x;
          end
          else if znamienko='-' then begin
               if lowercase(s1)<>'x' then begin
                 cislo:=StringToReal(s1);
                 res:=res-cislo;
               end
               else res:=res-x;
          end
          else if znamienko='*' then begin
               if lowercase(s1)<>'x' then begin
                 cislo:=StringToReal(s1);
                 res:=res*cislo;
               end
               else res:=res*x;
          end
          else if znamienko='/' then begin
               if lowercase(s1)<>'x' then begin
                 cislo:=StringToReal(s1);
                 res:=res/cislo;
               end
               else res:=res/x;
          end;

       end;
       fx:=round(-res*k+((getmaxy-100) div 2));
  end;
end;

procedure vykreslenie(hracx,hracy:integer; vykreslenie_farba:word; inpu:string);  //vykreslenie funckie
var
  j,p,poc:integer;
begin
   poc:=0;
   if stavhry=2 then stavhry:=0;
   p:=hraci[1].y-fx(inpu,hracx-100-((getmaxx-200) div 2));
   j:=hracx-100-((getmaxx-200) div 2)-1;
   repeat
      poc:=poc+1;
      j:=j+1;
      if (getpixel(j+(getmaxx div 2),fx(inpu,j)+p)=green) then begin
           if  vykreslenie_farba<>black then begin
                setcolor(black);setfillstyle(1,black);
                FillEllipse(j+(getmaxx div 2),fx(inpu,j)+p,20,20);
                stavhry:=2;
           end
           else  if vykreslenie_farba=black then stavhry:=2;

      end
      else if (getpixel(j+(getmaxx div 2),fx(inpu,j)+p)=red) and ((hracx+poc)-(hracx)>(hracr+5)) then begin
           stavhry:=1;
           setcolor(darkgray);settextstyle(0,0,10);
           outtextxy((getmaxx div 2)-337,55,'Vyhral si');
           setcolor(blue);
           outtextxy((getmaxx div 2)-332,50,'Vyhral si');
           repeat until keypressed;
      end
      else begin
         putpixel(j+(getmaxx div 2),fx(inpu,j)+p,vykreslenie_farba);
         //delay(1);
      end;
   until (j=((getmaxx-200) div 2)) or ((fx(inpu,j)+p>getmaxy-200)) or ((fx(inpu,j)+p<100)) or (stavhry<>0);


end;

procedure pole();    //pozadie
var
  cislox,cisloy:integer;
  cx,cy:string;
begin
  cleardevice();
  rectangle(100,100,getmaxx-100,getmaxy-200);
  moveto((getmaxx div 2)-70,(getmaxy-100) div 2);setcolor(white); settextstyle(0,0,1);
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
end;

procedure predpis();  //input predpisu
begin
  input:='';
  setfillstyle(1,black);
  bar(250,getmaxy-110,getmaxx-220,getmaxy-90);
  moveto(250,getmaxy-110);
  SetTextStyle (0,0,2);setcolor(green);
  repeat
      if keypressed then begin
        ch:=readkey;
        if (((ord(ch)>=40)and(ord(ch)<=57))or (ord(ch)=88) or (ord(ch)=120) or (ord(ch)=88)) and ((ch<>#13)or(ch<>#8)or(ch<>#27)) then begin
           outtext(ch);
           input:=input+ch;
        end;
        if (ch=#8) then begin
          input:='';
          setfillstyle(1,black);
          bar(250,getmaxy-110,getmaxx-220,getmaxy-90);
          moveto(250,getmaxy-110);
        end;
        if (ch=#13) and (length(input)>0)then begin
          if ((input[1]='*') or (input[1]='/') or (input[1]='.') or (input[1]=',')) then begin
             input:='';
             setfillstyle(1,black);
             bar(250,getmaxy-110,getmaxx-220,getmaxy-90);
             moveto(250,getmaxy-110);
          end;
        end;
        if (ch=#27) then esc:=1;
      end;
  until ((ch=#13) and (length(input)>0)) or (esc=1);
  if (esc=0) then begin
    if (input[1]<>'+') and (input[1]<>'-') then insert('+',input,1);
    if pos(',',input)<>0 then begin
      repeat
          input[pos(',',input)]:='.';
      until pos(',',input)=0;
    end;
  end;
  //SetTextStyle (0,0,1);setcolor(white);moveto(100,20);outtext(input);
end;

function sipky(sipky_x,sipky_y,sipky_sirka,sipky_vyska,skok,nn:integer; farba_sipky:word):integer; //sipky v menu
var x,p:integer;
begin
  x:=1;
  p:=0;
  sipky_y:=sipky_y+(((getmaxy-250) div nn) div 2);
  setfillstyle(1,darkgray);
  bar(sipky_x-(sipky_sirka div 2)-3,sipky_y+3,sipky_x+(sipky_sirka div 2)-3,sipky_y+sipky_vyska+3);
  setfillstyle(1,farba_sipky);
  bar(sipky_x-(sipky_sirka div 2),sipky_y,sipky_x+(sipky_sirka div 2),sipky_y+sipky_vyska);
  repeat
     keypressed();
     ch:=readkey;
     if (lowercase(ch)='s') and (x<nn) then begin    //sipka dole
       setfillstyle(1,lightgray);
       bar(sipky_x-(sipky_sirka div 2)-8,(sipky_y+skok*p)-1,sipky_x+(sipky_sirka div 2)+1,(sipky_y+skok*p)+sipky_vyska+4);
       p:=p+1;
       x:=x+1;
       setfillstyle(1,darkgray);
       bar(sipky_x-(sipky_sirka div 2)-3,(sipky_y+skok*p)+3,sipky_x+(sipky_sirka div 2)-3,(sipky_y+skok*p)+sipky_vyska+3);
       setfillstyle(1,farba_sipky);
       bar(sipky_x-(sipky_sirka div 2),(sipky_y+skok*p),sipky_x+(sipky_sirka div 2),(sipky_y+skok*p)+sipky_vyska);
     end
     else if (lowercase(ch)='w') and (x>1) then begin     //sipka hore
       setfillstyle(1,lightgray);
       bar(sipky_x-(sipky_sirka div 2)-8,(sipky_y+skok*p)-1,sipky_x+(sipky_sirka div 2)+1,(sipky_y+skok*p)+sipky_vyska+4);
       p:=p-1;
       x:=x-1;
       setfillstyle(1,darkgray);
       bar(sipky_x-(sipky_sirka div 2)-3,(sipky_y+skok*p)+3,sipky_x+(sipky_sirka div 2)-3,(sipky_y+skok*p)+sipky_vyska+3);
       setfillstyle(1,farba_sipky);
       bar(sipky_x-(sipky_sirka div 2),(sipky_y+skok*p),sipky_x+(sipky_sirka div 2),(sipky_y+skok*p)+sipky_vyska);
     end;
  until ch=#13;
  sipky:=x;
end;

procedure menu(moznosti:integer);  //menu rozhranie
var
  space_cele,space_moznost,vys,sir,a:integer;
begin
  box(getmaxx div 2,getmaxy div 2,getmaxx,getmaxy,20,lightgray,white,darkgray);

  //nadpis
  settextstyle(0,0,10);
  setcolor(darkgray);
  outtextxy((getmaxx div 2)-305,55,'Graphwar');
  setcolor(green);
  outtextxy((getmaxx div 2)-300,50,'Graphwar');
  settextstyle(0,0,1);setcolor(white);


  sir:=600;
  space_cele:=getmaxy-250;
  space_moznost:=space_cele div moznosti;
  vys:=space_moznost;
  box(getmaxx div 2,270+((space_cele-200) div 2),sir+40,getmaxy-210,20,lightgray,darkgray,white);
  a:=0;
  for i:=1 to moznosti do begin
     box(getmaxx div 2,170+(vys div 2)+a,sir,vys,20,lightgray,white,darkgray);
     a:=a+vys;
  end;

end;

procedure login(dlzka:integer); //login hraca
var poc:integer;
    dlzkas:string;
begin
  str(dlzka,dlzkas);
  box(getmaxx div 2,getmaxy div 2,getmaxx,getmaxy,20,lightgray,white,darkgray);

  //nadpis
  settextstyle(0,0,10);
  setcolor(darkgray);
  outtextxy((getmaxx div 2)-305,55,'Graphwar');
  setcolor(green);
  outtextxy((getmaxx div 2)-300,50,'Graphwar');
  settextstyle(0,0,1);setcolor(white);

  box(getmaxx div 2,getmaxy div 2,getmaxx div 2,getmaxy div 2,20,lightgray,darkgray,white);

  settextstyle(0,0,5);
  setcolor(darkgray);
  outtextxy((getmaxx div 2)-203,(getmaxy div 2)-(getmaxy div 4) +28,'Vase meno');
  setcolor(green);
  outtextxy((getmaxx div 2)-200,(getmaxy div 2)-(getmaxy div 4) +25,'Vase meno');
  settextstyle(0,0,1);
  setcolor(darkgray);
  outtextxy((getmaxx div 2)-81,(getmaxy div 2)+(getmaxy div 4) -34,'max '+dlzkas+' znakov');
  setcolor(green);
  outtextxy((getmaxx div 2)-80,(getmaxy div 2)+(getmaxy div 4) -35,'max '+dlzkas+' znakov');


  settextstyle(0,0,3);
  setcolor(black);
  moveto((getmaxx div 2)-(getmaxx div 6),getmaxy div 2);
  poc:=0;
  meno:='';
  repeat
     if keypressed then begin
       ch:=readkey;
       if (((ord(ch)>=48)and(ord(ch)<=57)) or ((ord(ch)>=65)and(ord(ch)<=90)) or ((ord(ch)>=97)and(ord(ch)<=122))) and (length(meno)+1<=dlzka) then begin
         outtext(ch);
         meno:=meno+ch;
       end;
       if ch=#8 then begin
         setfillstyle(1,lightgray);
         bar((getmaxx div 2)-(getmaxx div 6)-10,(getmaxy div 2)-10,(getmaxx div 2)+(getmaxx div 6),(getmaxy div 2)+30);
         meno:='';
         moveto((getmaxx div 2)-(getmaxx div 6),getmaxy div 2);
       end;
     end;
  until ((ch=#13) and (length(meno)>0)); //kontrola dlzky mena
  //outtextxy(100,100,meno);



  reset(subor);
  for i:=1 to filesize(subor) do begin
         read(subor,hrac);
         if hrac.menohraca=meno then begin
           poc:=1;
         end;
      end;

  hrac.menohraca:=meno;
  if poc=0 then begin
    seek(subor,filesize(subor));
    hrac.scorehraca:=0;
    write(subor,hrac);
  end;
  close(subor);
end;

procedure rebricek();   //rebricek
var gx,gy:integer;
    ii,score:string;
begin
  reset(subor);
  box(getmaxx div 2,getmaxy div 2,getmaxx,getmaxy,20,lightgray,white,darkgray);

  //nadpis
  settextstyle(0,0,10);
  setcolor(darkgray);
  outtextxy((getmaxx div 2)-305,55,'Graphwar');
  setcolor(green);
  outtextxy((getmaxx div 2)-300,50,'Graphwar');
  settextstyle(0,0,1);setcolor(white);
  gy:=0;
  gx:=0;
  box(getmaxx div 2,270+((getmaxy-450) div 2),getmaxx-200,getmaxy-210,20,lightgray,darkgray,white);
  settextstyle(0,0,2);setcolor(black);
  for i:=1 to filesize(subor) do begin
     read(subor,hrac);
     str(i,ii);
     str(player[i].scorehraca,score);
     outtextxy(140+(gx*100),200+(gy*20),ii);
     outtextxy(200+(gx*100),200+(gy*20),player[i].menohraca);
     outtextxy(600+(gx*100),200+(gy*20),score);
     gy:=gy+1;
  end;
  close(subor);
end;

procedure hra();     //cela hra
var
  vy,koniec,t:integer;
begin
  prepis_do_pola();
  koniec:=0;
  repeat
    menu(4);
    vy:=((getmaxy-250) div 4);
    settextstyle(0,0,5);setcolor(darkgray);
    outtextxy((getmaxx div 2)-78,170+(vy div 2)-26,'Hrat');
    outtextxy((getmaxx div 2)-163,170+(vy div 2)+vy-26,'Rebricek');
    outtextxy((getmaxx div 2)-163,170+(vy div 2)+(2*vy)-26,'Napoveda');
    outtextxy((getmaxx div 2)-118,170+(vy div 2)+(3*vy)-26,'Koniec');
    setcolor(green);
    outtextxy((getmaxx div 2)-75,(170+(vy div 2))-29,'Hrat');
    outtextxy((getmaxx div 2)-160,(170+(vy div 2)+vy)-29,'Rebricek');
    outtextxy((getmaxx div 2)-160,(170+(vy div 2)+(2*vy))-29,'Napoveda');
    outtextxy((getmaxx div 2)-115,(170+(vy div 2)+(3*vy))-29,'Koniec');
    case sipky(getmaxx div 2,182,100,7,((getmaxy-250) div 4),4,green) of
    1:begin
           menu(5);
           esc:=0;
           stavhry:=0;
           vy:=((getmaxy-250) div 5);
           settextstyle(0,0,5);setcolor(darkgray);
           outtextxy((getmaxx div 2)-143,170+(vy div 2)-26,'Level 1');
           outtextxy((getmaxx div 2)-143,170+(vy div 2)+vy-26,'Level 2');
           outtextxy((getmaxx div 2)-143,170+(vy div 2)+(2*vy)-26,'Level 3');
           outtextxy((getmaxx div 2)-143,170+(vy div 2)+(3*vy)-26,'Level 4');
           outtextxy((getmaxx div 2)-83,170+(vy div 2)+(4*vy)-26,'Spat');
           setcolor(green);
           outtextxy((getmaxx div 2)-140,(170+(vy div 2))-29,'Level 1');
           outtextxy((getmaxx div 2)-140,(170+(vy div 2)+vy)-29,'Level 2');
           outtextxy((getmaxx div 2)-140,(170+(vy div 2)+(2*vy))-29,'Level 3');
           outtextxy((getmaxx div 2)-140,(170+(vy div 2)+(3*vy))-29,'Level 4');
           outtextxy((getmaxx div 2)-80,(170+(vy div 2)+(4*vy))-29,'Spat');
           case sipky(getmaxx div 2,183,100,7,((getmaxy-250) div 5),5,green) of
           1:begin
                  pole();t:=0;
                  generovanie(1);
                  repeat
                    t:=t+1;
                    if t<>1 then begin
                       predpis();
                       if esc<>1 then begin
                          vykreslenie(hraci[1].x,hraci[1].y,black,input_old);
                          vykreslenie(hraci[1].x,hraci[1].y,magenta,input);
                          input_old:=input;
                       end;
                    end
                    else if t=1 then begin
                       predpis();
                       if esc<>1 then begin
                          vykreslenie(hraci[1].x,hraci[1].y,magenta,input);
                          input_old:=input;
                       end;
                    end;
                  until (stavhry=1) or (esc=1);
                  if stavhry=1 then
             end;
           2:begin
                  pole();t:=0;
                  generovanie(2);
                  repeat
                    t:=t+1;
                    if t<>1 then begin
                       predpis();
                       if esc<>1 then begin
                          vykreslenie(hraci[1].x,hraci[1].y,black,input_old);
                          vykreslenie(hraci[1].x,hraci[1].y,magenta,input);
                          input_old:=input;
                       end;
                    end
                    else if t=1 then begin
                       predpis();
                       if esc<>1 then begin
                          vykreslenie(hraci[1].x,hraci[1].y,magenta,input);
                          input_old:=input;
                       end;
                    end;
                  until (stavhry=1) or (esc=1);
             end;
           3:begin
                  pole();t:=0;
                  generovanie(3);
                  repeat
                    t:=t+1;
                    if t<>1 then begin
                       predpis();
                       if esc<>1 then begin
                          vykreslenie(hraci[1].x,hraci[1].y,black,input_old);
                          vykreslenie(hraci[1].x,hraci[1].y,magenta,input);
                          input_old:=input;
                       end;
                    end
                    else if t=1 then begin
                       predpis();
                       if esc<>1 then begin
                          vykreslenie(hraci[1].x,hraci[1].y,magenta,input);
                          input_old:=input;
                       end;
                    end;
                  until (stavhry=1) or (esc=1);
             end;
           4:begin
                  pole();t:=0;
                  generovanie(4);
                  repeat
                    t:=t+1;
                    if t<>1 then begin
                       predpis();
                       if esc<>1 then begin
                          vykreslenie(hraci[1].x,hraci[1].y,black,input_old);
                          vykreslenie(hraci[1].x,hraci[1].y,magenta,input);
                          input_old:=input;
                       end;
                    end
                    else if t=1 then begin
                       predpis();
                       if esc<>1 then begin
                          vykreslenie(hraci[1].x,hraci[1].y,magenta,input);
                          input_old:=input;
                       end;
                    end;
                  until (stavhry=1) or (esc=1);
             end;
           5:;
           end;

      end;
    2:begin
           rebricek();
           repeat
             if keypressed then ch:=readkey;
           until ch=#27;
      end;
    3:begin
      end;
    4:begin
           menu(2);
           vy:=((getmaxy-250) div 2);
           settextstyle(0,0,5);setcolor(darkgray);
           outtextxy((getmaxx div 2)-103,170+(vy div 2)-25,'Spat');
           outtextxy((getmaxx div 2)-153,170+(vy div 2)+vy-25,'Koniec');
           setcolor(green);
           outtextxy((getmaxx div 2)-100,(170+(vy div 2))-29,'Spat');
           outtextxy((getmaxx div 2)-150,(170+(vy div 2)+vy)-29,'Koniec');
           case sipky(getmaxx div 2,202,100,7,((getmaxy-250) div 2),2,green) of
           1:koniec:=0;
           2:koniec:=1;
           end;
      end;
    end;

  until koniec=1;
end;

begin
  randomize;
  assign(subor,suborc);
  gd:=detect;
  initgraph(gd,gm,'C:\lazarus');
  //pole();
  //predpis();
  //vykreslenie(hraci[1].x,hraci[1].y);
  login(20);
  hra();

  close(subor);
  closegraph();
end.

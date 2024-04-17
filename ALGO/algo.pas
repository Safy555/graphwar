program algo;
uses crt;
var
  input,input1,s1,s2,s3,znamienko:string;
  i:integer;
  x,y:real;

begin
  write('Zadajte predpis funkcie: y=');readln(input);
  input1:=input;
  i:=1;
  repeat
     if (input[i]='+') or (input[i]='-') or (input[i]='*') or (input[i]='/') then begin
        s1:=copy(input,1,i-1);
        znamienko:=input[i];
        delete(input,1,i);
        i:=1;
        writeln('input: ',input);
        writeln('znamienko: ',znamienko);
        writeln('s1: ',s1);
     end;

     i:=i+1;
  until length(input)=0;













  readln();
end.


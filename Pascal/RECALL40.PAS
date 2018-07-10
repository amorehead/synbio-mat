Unit recall40;

Interface

Uses CRT,dos;

Var
   f1:text;
   y,ro,co,n,teams,quizzes,rooms,rm2,x:integer;
   fn,fn2:string[12];
   list:array[1..100] of string[12];
   ps:pathstr;
   I:char;
   found,search:boolean;

Procedure mainmenu(o2:integer);

Procedure CLR;

Procedure IKEY;

Procedure tcw;

Procedure tcy;

Procedure recll(search:boolean);



Implementation

Procedure mainmenu(o2:integer);
Begin
  Gotoxy(21,6);
  Write('Create a Bracket for 3-team Quizzes    ');
  Gotoxy(21,7);
  Write('Create a Bracket for 2-team Quizzes    ');
  Gotoxy(21,8);
  Write('Create a Round Robin for 3-team Quizzes');
  Gotoxy(21,9);
  Write('Create a Round Robin for 2-team Quizzes');
  Gotoxy(21,10);
  Write('Create an Efficiency Bracket           ');
  Gotoxy(21,11);
  Write('Recall an Existing Bracket             ');
  Gotoxy(21,12);
  Write('Exit Bracketmaker                      ');
  Gotoxy(21,5+o2);
  textbackground(red);
  tcw;
  If o2=1 then Write('Create a Bracket for 3-team Quizzes    ');
  If o2=2 then Write('Create a Bracket for 2-team Quizzes    ');
  If o2=3 then Write('Create a Round Robin for 3-team Quizzes');
  If o2=4 then Write('Create a Round Robin for 2-team Quizzes');
  If o2=5 then Write('Create an Efficiency Bracket           ');
  If o2=6 then Write('Recall an Existing Bracket             ');
  If o2=7 then Write('Exit Bracketmaker                      ');
end;



Procedure CLR;
   Begin
         For x:=2 to 24 do begin
           gotoxy(1,x);
           clreol;
         end;
         Gotoxy(1,3);
   End;

Procedure Ikey; begin
Repeat I:=readkey; UNTIL(ord(I)<>27);
                end;

Procedure tcw;
begin textcolor(white); end;
Procedure tcy;
begin textcolor(yellow); end;






Procedure recll(search:boolean);

Label 1,2,3,4,5,6,7;

Begin
  1:
    found:=false;
  Gotoxy(2,3);
  textcolor(yellow);
  textbackground(blue);
  For x:=2 to 24 do begin gotoxy(1,x); clreol; end;
  Gotoxy(25,3);
  Write('Search for an Existing Bracket');
  Gotoxy(36,6);
  Write('Teams:                            ');
  Gotoxy(2,4); For x:=1 to 78 do write('_');
  If search=true then begin
      ASSIGN(F1,'Temp.txt');
      rewrite(f1);
      Gotoxy(32,6); write(teams); {Gotoxy(54,6); Write(quizzes);}
      close(f1);
      goto 4;
      end;


  Gotoxy(43,6);
{  textBackground(black); }
  Write('  ');
  Gotoxy(54,6);
  Write('  ');
  Gotoxy(67,6);
  Write('  ');

  Gotoxy(43,6);
  Repeat
   I:=readkey;
   if ord(I)=27 then goto 5;
  until (ord(I)>48) and (ord(I)<58);

  write(I);
  x:=Ord(I)-48;
  Repeat
   I:=readkey;
   if ord(i)=8 then goto 1;
  until (ord(I)>47) and (ord(I)<58) or (ord(i)=13);
  If (ord(i)<>13) then write(I);
  If (ord(i)=13) then teams:=x else teams:=x*10+ord(i)-48;

  2:
{  Gotoxy(54,6);
  Write('   ');
  Gotoxy(54,6);
  Repeat
   I:=readkey;
   if (ord(I)=8) or (ord(I)=27) then goto 1;
  until (ord(I)>48) and (ord(I)<58);
  write(I);
  x:=Ord(I)-48;
  Repeat
   I:=readkey;
   If ord(i)=8 then goto 2;
   if ord(i)=27 then goto 1;
  until (ord(I)>47) and (ord(I)<58) or (ord(i)=13);
  If (ord(i)<>13) then write(I);
  If (ord(i)=13) then quizzes:=x else quizzes:=x*10+ord(i)-48;}


   3:  Textbackground(blue);
     Textcolor(yellow);


     n:=0;
   For quizzes:=1 to 35 do
     for rm2:=1 to (teams) div (2) do begin
          fn:='';
          {Writeln(quizzes,',',rm2);}
          if teams>9 then fn:=chr((teams)div(10)+48);
          fn:=fn+chr((teams)mod(10)+48)+'-';
          if quizzes>9 then fn:=fn+chr((quizzes)div(10)+48);
          fn:=fn+chr((quizzes)mod(10)+48)+'-';
          If rm2>9 then fn:=fn+chr((rm2)div(10)+48);
          fn:=fn+chr((rm2)mod(10)+48)+'.';
          {Writeln(fn);}
          x:=0;

          Repeat
          fn2:='            ';
          fn2:=fn;
          x:=x+1;
          if x>9 then fn2:=fn2+chr((x)div(10)+48);
          fn2:=fn2+chr((x)mod(10)+48);
          ps:=fsearch(fn2,getenv('Path'));
          If ps <>'' then begin
              found:=true;
              n:=n+1;
              list[n]:=fn2; end;
              if n=96 then goto 4;
          until ps='';
          end;


     If found=false then begin
          Gotoxy(22,8);
          textbackground(red);
          Textcolor(white);
          Write('This Bracket has not yet been Created');
             textbackground(blue);
             textcolor(yellow);

             Repeat I:=readkey; UNTIL(ord(I)<>27);
             goto 1;             end;




    4: Gotoxy(6,8);
     For x:=0 to n-1 do begin
       ro:=(x)mod(16);
       co:=(x)div(16);
       Gotoxy(6+12*co,8+ro);
       write(list[x+1]);
     end;

     x:=0;
     Repeat
       ro:=(x)mod(16);
       co:=(x)div(16);
       Gotoxy(6+12*co,8+ro);
       textbackground(red);
       textcolor(white);
       write(list[x+1]);
       For y:=length(list[x+1]) to 10 do write(' ');
       I:=readkey;
       If (ord(I)=75) or (ord(I)=77) or (ord(I)=72) or (ord(I)=80)
       or (ord(I)=27) then begin
          ro:=(x)mod(16);
          co:=(x)div(16);
          Gotoxy(6+12*co,8+ro);
          textbackground(blue);
          textcolor(yellow);
          write(list[x+1]);
          For y:=length(list[x+1]) to 10 do write(' ');
          If ord(I)=75 then if x>15 then x:=x-16;
          If ord(I)=77 then if x+16 <=n then x:=x+16;
          If ord(I)=72 then x:=x-1;
          If ord(I)=80 then x:=x+1;
          If x=-1 then x:=n-1;
          If x=n then x:=0;
          If ord(I)=27 then begin search:=false; goto 1; end; end;
    Until ord(I)=13;

   search:=true;
   Assign(f1,'temp.txt');
   rewrite(f1);
   Writeln(f1,list[x+1]);


     Goto 6;

     5:search:=false;
     Assign(f1,'temp.txt');
     rewrite(f1);
     Writeln(f1,'Not');


     6:textbackground(blue);


     If search=true then writeln(f1,1) else writeln(f1,0);
     close(f1);
     end;

     end.
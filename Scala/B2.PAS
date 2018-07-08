
PROGRAM BRACKETS;

USES CRT,dos,view,recall40;

CONST

   TMS=72;

VAR

   F1,F2,f4:TEXT;

   Lastrow,lastcol:word;
   ps:pathstr;

   cnc,zrounds,lastoff,lteams,lquiz,qquiz,
   x10,xtqzz,c10,factor,tw,y2,lasto,g,c9,o2,x2w,x3w,way,srch,x2quiz,countset,
   x8,tqz,xtquiz,xt,grdriver,grmode,xrounds,xquiz,yquiz,xrooms,spc,tot,c8,
   x2,tmpqz,trounds,prounds,Maxrepeat,rep,trep,Rounds2,Rmtemp,Open,Off2,Iter,
   S1,S2,Id,Totquiz,Lowused,Count2,Quizzes,count,Teams,rooms,rounds,round,
   R2,Low,c5,s,f,qn1,qn2,qn3,qn4,t1,ttemp,a1,a2,a3,b1,b2,b3,c3,c4,d1,d2,d3,
   Temp,lastsw,last,SWI,OFF,oldof,rf,left,q2,q3,tquiz,highround,diff,count3,
   rm2,tq,t2,qn,c2,It,Room,m,n,A,B,R,C,c1,FL,D,Q,QZ,FL2,O,T,H,E,L,X,Y,Z,
   bb1,bb2,bb3,dd1,dd2,dd3,rr1,ss1,tt1,Rd,height,c6,Oldoff,r3,r4,rr:integer;

   inf2:string[2];
   fn,fn2,fn3:string[15]; fna:string[3]; ex:string[8]; info:string[250];

   V,V1,v2,Ideal:real;
   rs2,rs,rc,I,I2,I3,FNO,FNT,FNH:CHAR;

   twy,again,redo,rept,checkrep,
   place2,placed,split2,rewr,op,op1,twaylast,twowaylast,splitlst,splitlastlast,
   atar,rob3a,rob3,lineready,splitlast,splitdone,split,roundrob,search,first,
   fin,twoway,tway,strange,demo,ready2,back,en,done,ready,stop,sw,us:boolean;

   RM:ARRAY[0..Tms,1..35] OF Integer;
   Break:Array[1..35,1..35] of Boolean;
   TWO:Array[1..35,1..35] of Boolean;
   SIT:ARRAY[0..Tms,1..3] OF Integer;
   QAgainst,QA1:array[0..Tms,0..Tms] of integer;
   used2,Used:array[0..Tms] of boolean;
   TimesUsed,rmax:array[0..Tms] of integer;
   Used4:array[0..35] of integer;
   used5,Leastused:array[0..Tms] of integer;
   Quiz:array[1..550,1..1,1..3] of integer;
   Quiz2:array[0..Tms,1..35,1..3] of integer;


Procedure CLR;
   Begin
         For x:=2 to 24 do begin
           gotoxy(1,x);
           clreol;
         end;
         Gotoxy(1,3);
   End;


Procedure tbb;
begin textbackground(blue); end;
Procedure tbr;
begin textbackground(red); end;
Procedure tcw;
begin textcolor(white); end;
Procedure tcy;
begin textcolor(yellow); end;


  Procedure view2; begin
     Gotoxy(1,6);
     If rooms<7 then view6(teams,rounds,rooms,fn);
     If rooms=7 then view7(teams,rounds,rooms,fn);
     If rooms=8 then view8(teams,rounds,rooms,fn);
     If rooms=9 then view9(teams,rounds,rooms,fn);
     if (rooms>9) and (rooms<14) then view10(teams,rounds,rooms,fn);
     if rooms > 13 then begin
             tbr;
             tcw;
             Gotoxy(19,7);
             Write('Sorry, cannot display more than 13 rooms');
             tbb;
              tcy;
              readln;
                          end; end;



Procedure recll;

Label 1,2,3,4,5,6,7;

Begin
  1:
    found:=false;
  Gotoxy(2,3);
  tcy;
  tbb;
  For x:=2 to 24 do begin gotoxy(1,x); clreol; end;
  Gotoxy(25,3);
  Write('Search for an Existing Bracket');
  Gotoxy(25,6);
  Write('Teams:     Quizzes Per Team:      ');
  Gotoxy(2,4); For x:=1 to 78 do write('_');

  Gotoxy(32,6);
{  textBackground(black); }
  Write('  ');
  Gotoxy(54,6);
  Write('  ');
  Gotoxy(67,6);
  Write('  ');
  If search=true then begin
         Gotoxy(32,6); write (lteams);
         Gotoxy(54,6); write (lquiz); goto 4; end;

  Gotoxy(32,6);
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
  Gotoxy(54,6);
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
  If (ord(i)=13) then quizzes:=x else quizzes:=x*10+ord(i)-48;


   3:  tbb;
     tcy;


     n:=0;
     for rm2:=1 to (teams) div (2) do begin
          fn3:='';
          {Writeln(quizzes,',',rm2);}
          if teams>9 then fn3:=chr((teams)div(10)+48);
          fn3:=fn3+chr((teams)mod(10)+48)+'-';
          if quizzes>9 then fn3:=fn3+chr((quizzes)div(10)+48);
          fn3:=fn3+chr((quizzes)mod(10)+48)+'-';
          If rm2>9 then fn3:=fn3+chr((rm2)div(10)+48);
          fn3:=fn3+chr((rm2)mod(10)+48)+'.';
          x:=0;

          Repeat
          if keypressed then if ord(readkey)=27 then goto 1;
          fn2:='            ';
          fn2:=fn3;
          x:=x+1;
          if x>9 then fn2:=fn2+chr((x)div(10)+48);
          fn2:=fn2+chr((x)mod(10)+48);
          ps:=fsearch(fn2,getenv('Path'));
          If ps <>'' then begin
              found:=true;
              search:=true;
              lteams:=teams;
              lquiz:=quizzes;
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
             tbb;
             tcy;

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
          tbb;
          tcy;
          write(list[x+1]);
          For y:=length(list[x+1]) to 10 do write(' ');
          If ord(I)=75 then if x>15 then x:=x-16;
          If ord(I)=77 then if x+16 <=n then x:=x+16;
          If ord(I)=72 then x:=x-1;
          If ord(I)=80 then x:=x+1;
          If x=-1 then x:=n-1;
          If x=n then x:=0;
          If ord(I)=27 then begin found:=false; search:=false; goto 1; end; end;
    Until ord(I)=13;

    found:=true;


     Goto 6;

     5:search:=false;

     6:tbb;

     qquiz:=quizzes;
    if found=true then  Begin

         fn:=list[x+1];
          end;

     end;


  Procedure line1; begin
  Write(F2,'--   ');
  for x:= 1 to 3*r-1 do write(f2,'-');
  If R=1 then write(f2,'--');
  If r>1 then Write(f2,'  ');
  write(f2,' ');
  Writeln(f2,'--------'); end;


  Procedure startup;
  begin
  lasto:=1;
  twoway:=false;
  roundrob:=false;
  strange:=false;
  rob3:=false;
  rob3a:=false;
  split:=false;
  split2:=false;
  splitlast:=false;
  splitdone:=false;
  op1:=false;
  search:=false;
  tbb;
  tcy;
  for x:=1 to 25 do begin
  gotoxy(1,x); clreol; end;
  Gotoxy(1,1);
  Textbackground(lightGray);
  Textcolor(black);
  clreol;
  Write(' Bracketmaker');Write(' 2.0'); textcolor(red);
  write('');
  Gotoxy(1,25);
  clreol;
  textcolor(black);
  Write(' JI Software'); {textcolor(red);} write('               ');
{  Dec(lastrow,80 div lastcol);}
  tbb;
  tcy;

  clr;
  ready2:=false;
  o2:=1;
  Gotoxy(27,3); If first then Write('Welcome to Bracketmaker 2.0')
                         Else begin Write('     Bracketmaker 2.0');
                         end;

  first:=false;
  Gotoxy(2,4); For x:=1 to 78 do write('_');
  Repeat
  tbb;
  tcy;
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
  tbr;
  tcw;
  If o2=1 then Write('Create a Bracket for 3-team Quizzes    ');
  If o2=2 then Write('Create a Bracket for 2-team Quizzes    ');
  If o2=3 then Write('Create a Round Robin for 3-team Quizzes');
  If o2=4 then Write('Create a Round Robin for 2-team Quizzes');
  If o2=5 then Write('Create an Efficiency Bracket           ');
  If o2=6 then Write('Recall an Existing Bracket             ');
  If o2=7 then Write('Exit Bracketmaker                      ');
  I:=readkey;
  if ord(I)<>13 then ready2:=true;
  If (ord(I)=56) or (ord(I)=72) then o2:=o2-1;
  If (ord(I)=50) or (ord(i)=80) then o2:=o2+1;
  If o2=0 then o2:=7;
  if o2=8 then o2:=1;
  until (ord(I)=13) {and (ready2=true)};

  tcy;
  tbb;
end;



Procedure Initialize;
 label 1,2,3,4,5,6,7,8,9,10,11,12,13,14;
Begin

   If redo=true then goto 11;
   redo:=false;
{*************************** Initialize *******************************}
   clr;
   strange:=false;
   last:=0;
   For X:= 1 to tms do begin
     For y:= 1 to tms do Qagainst[X,Y]:=0;
     For Y:= 1 to 35 do
        For Z:= 1 to 3 do begin
           Quiz2[X,Y,Z]:=0;
           RM[X,Y]:=0;
           SIT[X,Y]:=0;
        end; end;

{  if op1=true then close(f1);

  op1:=true;
  ASSIGN(F1,'Temp.txt');
  REwrite(F1); }


  Randomize;

  Gotoxy(2,3);
{  WRITE('Bracket File Name: ');
  READLN(FN);}
  op:=false;
  1:
  again:=false;
  If op=true then begin close(f2); op:=false; end;
  Gotoxy(2,3);
  textcolor(yellow);
  textbackground(blue);
  For x:=5 to 24 do begin gotoxy(1,x); clreol; end;
  Gotoxy(2,3);
  Write('Teams:      Quizzes Per Team:      Rooms:');
  Gotoxy(2,4); For x:=1 to 78 do write('_');
{  textcolor(lightred); }

  Gotoxy(9,3);
{  textBackground(black); }
  Write('  ');
  Gotoxy(32,3);
  Write('  ');
  Gotoxy(44,3);
  Write('  ');

  Gotoxy(9,3);
  en:=false;

  Repeat
   I:=readkey;
   if ord(I)=27 then begin en:=true; goto 5; end;
  until (ord(I)>48) and (ord(I)<58);

  write(I);
  x:=Ord(I)-48;
  Repeat
   I:=readkey;
   if ord(i)=8 then goto 1;
  until (ord(I)>47) and (ord(I)<58) or (ord(i)=13);
  If (ord(i)<>13) then write(I);
  If (ord(i)=13) then teams:=x else teams:=x*10+ord(i)-48;
  If (teams<5) or (teams>72) then begin
             textbackground(red);
             textcolor(white);
             Gotoxy(21,7);
             Write('Please choose between 5 and 72 teams');
             textbackground(blue);
             textcolor(yellow);
             Repeat I:=readkey; UNTIL(ord(I)<>27);
             goto 1;       end;

  If (roundrob=true) and (way=2) and (teams>33) then begin
             textbackground(red);
             textcolor(white);
             Gotoxy(17,7);
             Write('Please choose up to 33 teams for this option');
             textbackground(blue);
             textcolor(yellow);
             Repeat I:=readkey; UNTIL(ord(I)<>27);
             goto 1;       end;

  If ((teams<7) or (teams > 57)) and (rob3=true) then begin
             textbackground(red);
             textcolor(white);
             Gotoxy(9,7);
             Write('Please choose between 7 and 57 teams for a 3-way round robin');
             textbackground(blue);
             textcolor(yellow);
             Repeat I:=readkey; UNTIL(ord(I)<>27);
             goto 1;       end;

  If (teams<9) and (atar=true) then begin
             textbackground(red);
             textcolor(white);
             Gotoxy(11,7);
             Write('Please choose at least 9 teams for an Efficiency Bracket');
             textbackground(blue);
             textcolor(yellow);
             Repeat I:=readkey; UNTIL(ord(I)<>27);
             goto 1;       end;


   if demo=true then if ((teams<>15) and (teams<>21) and (teams<>35)) then begin
             textbackground(red);
             textcolor(white);
             Gotoxy(16,7);
             Write('This demo program works for 15, 21 or 35 teams');
       {      Gotoxy(11,8);
            Write('The complete version creates brackets for 8 to 90 teams.');}
             textbackground(blue);
             textcolor(yellow);
             Repeat I:=readkey; UNTIL(ord(I)<>27);
             goto 1;             end;



  2:
   redo:=false;
  xtquiz:=0;
  split2:=false;
  strange:=false;
  tway:=false;
  checkrep:=false;
  For x:=5 to 24 do begin gotoxy(1,x); clreol; end;
  Gotoxy(32,3);
  Write('   ');

  If atar=true then begin

      Gotoxy(44,3);
      Write('   ');
      x2w:=0;
      If (teams)mod(3)=0 then rooms:=(teams) div (3) else rooms:=(teams)div(3)+1;
      If (teams)mod(3)=2 then x2w:=1;
      If (teams)mod(3)=1 then x2w:=2;
      rm2:=rooms;
      way:=3;
      x3w:=rooms-x2w;
      x2quiz:=quizzes;
      Gotoxy(44,3);
      Write(rooms);
      if (x2w<>0) and (rewr=false) then begin
        textbackground(red); textcolor(white);
        gotoxy(9,7);
        textbackground(red); textcolor(white);
        Write('Each round consists of ',x3w,' three-way quiz');
        if x3w<>1 then write('zes');
        Write(' and ',x2w,' two-way quiz');
        If x2w<>1 then write('zes');
{        Repeat I:=readkey; UNTIL ord(I)<>191;}
        textbackground(blue);
        textcolor(yellow); end;
       end;


  If rob3a=true then rob3:=true;

  If roundrob=true then begin
     gotoxy(32,3);
     If way=2 then quizzes:=teams-1;
     x2quiz:=quizzes;
     write(quizzes);
     goto 3; end;

  rob3a:=false;
  If rob3=true then begin
     rob3a:=true;
     gotoxy(32,3);
     x3w:=(teams)div(2);
     If (teams)div(3)<>teams/3 then repeat
        if (x3w) mod (3) <> 0 then x3w:=x3w-1;
     until (x3w) mod (3) = 0;

     x2w:=(teams-1)-2*x3w;

     If (teams) mod (6) = 0 then begin
        x3w:=(teams)div(2)-1;
        x2w:=1; end;

     twoway:=false;
     split:=true;
     split2:=true;
     splitlast:=true;
     quizzes:=x3w+x2w;
     Write(quizzes);
     x2quiz:=quizzes;
     If x2w<>0 then begin
             gotoxy(13,7);
             textbackground(red); textcolor(white);
             Write('Each team has ',x3w,' three-way quiz');
             if x3w<>1 then write('zes');
             Write(' and ',x2w,' two-way quiz');
             If x2w<>1 then write('zes');
             Repeat I:=readkey; UNTIL ord(I)<>191;
             textbackground(blue);
             textcolor(yellow);
             If ord(I)=27 then goto 1;
             end;

     If x2w=0 then begin rob3:=false; split:=false; split2:=false; splitlast:=false; end;
     goto 3; end;


  Gotoxy(32,3);
  Repeat
   I:=readkey;
   if (ord(I)=8) or (ord(I)=27) then goto 1;
  until (ord(I)>48) and (ord(I)<58);
  Gotoxy(1,7); clreol;
  Gotoxy(32,3);
  write(I);
  x:=Ord(I)-48;
  Repeat
   I:=readkey;
   If ord(i)=8 then goto 2;
   if ord(i)=27 then goto 1;
  until (ord(I)>47) and (ord(I)<58) or (ord(i)=13);
  If (ord(i)<>13) then write(I);
  If (ord(i)=13) then quizzes:=x else quizzes:=x*10+ord(i)-48;
        iF QUIZZES<2 THEN BEGIN
             textbackground(red);
             textcolor(white);
             Gotoxy(19,7);
             Write('Please choose at least 2 quizzes per team');
             textbackground(blue);
             textcolor(yellow);
             Repeat I:=readkey; UNTIL(ord(I)<>27);
             goto 2;       end;


  If (atar=true) and (x2w<>0) and ((teams-1)/quizzes<2) then begin
             rewr:=true;
             gotoxy(5,7);
             textbackground(red); textcolor(white);
             Write('Please use a different option for this combination of teams and quizzes');
             Repeat I:=readkey; UNTIL ord(I)<>191;
             textbackground(blue);
             textcolor(yellow);
             If ord(I)=27 then goto 1;
             goto 2;
             end;



  If atar=true then begin
             x2quiz:=quizzes;
             totquiz:=quizzes*rooms;
             If totquiz>550 then begin
                textbackground(red);
                textcolor(white);
                Gotoxy(8,7);
                Write('This bracket requires more than the maximum of 550 total quizzes');
                textbackground(blue); textcolor(yellow); Repeat until keypressed;
                goto 2;            end;
             goto 7; end;


  If (twoway=true) and (teams/2<>(teams)div(2)) and (quizzes/2<>(quizzes)div(2)) then begin
             textbackground(red);
             textcolor(white);
             Gotoxy(12,7);
             Write('Please choose an even number of either teams or quizzes');
             textbackground(blue);
             textcolor(yellow);
             Repeat I:=readkey; UNTIL(ord(I)<>27);
             goto 2;       end;



   if splitlast=true then twoway:=false;
   If twoway=false then
   xtquiz:=0;
   if (Teams/3<>(teams)div(3)) and (Quizzes/3<>(quizzes)div(3)) and (twoway=false) then begin

             split2:=false;
             If teams/quizzes<=2 then begin
                 textbackground(red);
                 textcolor(white);
                 Gotoxy(17,7);
             x2w:=(quizzes)mod(3);
             x3w:=quizzes-x2w;
             If ((teams) mod (2) <> 0) and ((x2w)mod(2)<>0) then begin
                 x3w:=x3w-3; x2w:=x2w+3; end;

             Write('Each team has ',x3w,' three-way and ',x2w,' two-way Quizzes');
             split:=true; split2:=true; splitlast:=true;
             Repeat I:=readkey; UNTIL ord(I)<>191;
             textbackground(blue);
             textcolor(yellow);
             If ord(I)=27 then goto 2;
             goto 8; end;


{                 Write('Please choose a different option for this combination of teams and quizzes');
                 textbackground(blue);
                 textcolor(yellow);
                 Repeat I:=readkey; UNTIL(ord(I)<>27);
                 goto 1;  end;
}
             If (teams*quizzes) mod (3)=1 then begin
                      tqz:=(teams*Quizzes)div(3)-1; xtquiz:=1; end else begin
                      tqz:=(teams*Quizzes)div(3); xtquiz:=0;

             end;

             o:=1;
          Repeat
             Gotoxy(16,6);
             if xtquiz=0 then
             Write('Complete the bracket with 1 two-way Quiz                      ');
             if xtquiz>0 then
             Write('Complete the bracket with 2 two-way Quizzes                   ');
             gotoxy(16,7);
             x2w:=(quizzes)mod(3);
             x3w:=quizzes-x2w;
             If ((teams) mod (2) <> 0) and ((x2w)mod(2)<>0) then begin
                 x3w:=x3w-3; x2w:=x2w+3;
                 IF X3W<0 THEN BEGIN
                     X3W:=0; X2W:=X2W-3;
                     END; END;
             Write('Each team has ',x3w,' three-way and ',x2w,' two-way quizzes     ');
             if x3w<10 then write(' ');
                If o=1 then begin
                  textcolor(white); textbackground(red);
                  Gotoxy(16,6);
                  if xtquiz=0 then
                  Write('Complete the bracket with 1 two-way Quiz        ');
                  if xtquiz=1 then
                  Write('Complete the bracket with 2 two-way Quizzes     ');
                  end;
                If o=2 then begin
                  textcolor(white); textbackground(red);
                  Gotoxy(16,7);
                  Write('Each team has ',x3w,' three-way and ',x2w,' two-way quizzes');
                  if x3w<10 then write(' '); end;
            textcolor(yellow); textbackground(blue);
            I:=readkey;
            c:=ord(I);
            If c=72 then o:=o-1;
            If c=80 then o:=o+1;
            If o=3 then o:=1;
            If o=0 then o:=2;
            If c=27 then goto 2;
         Until c=13;
            split:=false; split2:=false; strange:=false; tway:=false; splitlast:=false;
            If o=1 then begin  Strange:=true; tway:=true; end;
            If o=2 then begin split:=true; split2:=true; splitlast:=true; end;

       {      goto 2;   }          end;

  8:
   x2quiz:=quizzes;
   Totquiz:=(Teams*Quizzes)Div(way);

   If totquiz>550 then begin
             textbackground(red);
             textcolor(white);
             Gotoxy(8,7);
             Write('This bracket requires more than the maximum of 550 total quizzes');
             textbackground(blue); textcolor(yellow); Repeat until keypressed;
             goto 2;            end;

  3:
    For x:=5 to 24 do begin gotoxy(1,x); clreol; end;
  Gotoxy(44,3);
  Write('   ');
  Gotoxy(44,3);

  Repeat
   I:=readkey;
   if (ord(I)=8) then goto 2;
   if (ord(I)=27) then goto 1;
  until (ord(I)>48) and (ord(I)<58);
  write(I);
  x:=Ord(I)-48;
  Repeat
   I:=readkey;
   if ord(i)=27 then goto 1;
   if ord(i)=8 then goto 3;
  until (ord(I)>47) and (ord(I)<58) or (ord(i)=13);
  If (ord(i)<>13) then write(I);
  If (ord(i)=13) then rooms:=x else rooms:=x*10+ord(i)-48;


   if rooms>30 then begin
             textbackground(red);
             textcolor(white);
             Gotoxy(23,7);
             Write('The maximum number of rooms is 30');
             textcolor(yellow);
             textbackground(blue); Repeat until keypressed;
             goto 3;             end;

   if teams/way<rooms then begin
             textbackground(red);
             textcolor(white);
             Gotoxy(17,7);
             Write('The maximum number of rooms for ',teams,' teams is ',(teams)div(way));
             textcolor(yellow);
             textbackground(blue); Repeat until keypressed;
             goto 3;             end;

  Rounds:=TRUNC(Teams/way/Rooms*Quizzes+0.999);
   if rounds>35 then begin
             textbackground(red);
             textcolor(white);
             Gotoxy(6,7);
  Write('Choose a greater number of rooms so bracket will not exceed 35 rounds');
  textcolor(yellow);
             textbackground(blue); Repeat until keypressed;
             goto 3;             end;

7:
  twaylast:=tway;
  twowaylast:=twoway;
  splitlst:=split;
  splitlastlast:=splitlast;


  if atar=true then rounds:=quizzes;
  If atar=true then totquiz:=teams*rooms;
  textBackground(blue);
  textcolor(yellow);
  xrooms:=rooms;
  rm2:=rooms; rooms:=1;
    fn:='';
    if teams>9 then fn:=chr((teams)div(10)+48);
    fn:=fn+chr((teams)mod(10)+48)+'-';
    if quizzes>9 then fn:=fn+chr((quizzes)div(10)+48);
    fn:=fn+chr((quizzes)mod(10)+48)+'-';
    If rm2>9 then fn:=fn+chr((rm2)div(10)+48);
    fn:=fn+chr((rm2)mod(10)+48)+'.';
    x:=0;

    Repeat
      fn2:=fn;
      x:=x+1;
      if x>9 then fn2:=fn2+chr((x)div(10)+48);
      fn2:=fn2+chr((x)mod(10)+48);
      ps:=fsearch(fn2,getenv('Path'));
    until ps='';
    fn:=fn2;

  y:=4;
  if x>9 then y:=y-1;
  if teams>9 then y:=y-1;
  if xrooms>9 then y:=y-1;
  If quizzes>9 then y:=y-1;
  textbackground(lightgray);
  Gotoxy(1,25); clreol;
  Gotoxy(64,25); write('                ');
  Gotoxy(64+y,25); textcolor(black); textbackground(lightgray);
  Write('File '); textcolor(black); write(fn);
  Gotoxy(2,25);
  Textcolor(red); Write('Esc ');textcolor(black);
      write('Previous Procedure ');
  Textcolor(red); Write(' Ret ');textcolor(black);
      write('Next Procedure ');
      textcolor(yellow); textbackground(blue);




  Gotoxy(2,4); For x:=1 to 78 do write('_');
  Rounds:=TRUNC(Teams/way/Rm2*Quizzes+0.999);

  Totquiz:=(Teams*Quizzes)Div(way);
  If tway=true then totquiz:=totquiz+1;


  If split=true then totquiz:=(teams*x3w)div(3)+(teams*x2w)div(2);
  If split=true then rounds:=TRUNC(totquiz/Rm2+0.999);

  Gotoxy(2,6);
  Write('This bracket requires ');
  Write(totquiz,' total quizzes and ');
  Write(Rounds,' total round');
  If rounds=1 then write('.') else write ('s.');
  xquiz:=totquiz;
  yquiz:=quizzes;
  zrounds:=rounds;
  xrounds:=rounds;
  Gotoxy(2,7);

  Rep:=(Quizzes*(way-1))Div(Teams-1)+1;
  If split=true then rep:=(x3w*2+x2w) div (teams-1)+1;

  If split=false then If (Quizzes*(way-1))mod(Teams-1)=0 then rep:=rep-1;
  If split=true then if (x3w*2+x2w) mod (teams-1) =0 then rep:=rep-1;

  Maxrepeat:=(Quizzes*(way-1))Mod(Teams-1);
  If split=true then maxrepeat:=(x3w*2+x2w) mod (teams-1);

  If split=false then If (Quizzes*(way-1))Mod(Teams-1)=0 then maxrepeat:=teams-1;
  If split=true then if (x3w*2+x2w) mod (teams-1)=0 then maxrepeat:=teams-1;

  If (tway=false) and ((atar=false) or (x2w=0)) then
  If rep=1 then Writeln('All teams quiz ',maxrepeat,' teams once.')
  Else If (quizzes*(way-1))mod(teams-1)=0 then Writeln('All teams quiz ',maxrepeat,' teams ',rep,' times each.')
  Else begin
      Write('All teams quiz ',maxrepeat,' team');
      If maxrepeat<>1 then write('s');
      Write(' ',rep,' time');
      If rep<>1 then write('s');
      Write(' and ',teams-1-maxrepeat,' teams ',rep-1,' time');
      If rep-1>1 then writeln('s.') else writeln('.');
  writeln; end;

  If tway=true then begin
     x:=xtquiz+1;
     Write(teams-x*2);
                      If teams-x*2<>1 then write(' teams quiz ')
                      Else write(' team quizzes ');
                      Write(maxrepeat,' teams once and ');
     Write(x*2,' quiz ',maxrepeat-1,' teams once.');
     writeln; end;


  If (atar=true) and (x2w<>0) then begin
    x:=quizzes*x2w*2;
    If x<teams then begin
    Write(teams-x);
    If teams-x=1 then write(' team quizzes ') else write (' teams quiz ');
    Write(maxrepeat,' team');
    If maxrepeat<>1 then write('s');
    Write(' once and ',x);
    Write(' quiz');
    If x=1 then write('zes');
    Write(' ',maxrepeat-1,' team');
    If maxrepeat-1<>1 then write('s');
    Write(' once.'); end

    else if x=teams then
        Write('All teams quiz ',maxrepeat,' teams once.')

    else begin
       x:=x-teams;
       Write(teams-x);
       If teams-x=1 then write(' team quizzes ') else write (' teams quiz ');
       Write(maxrepeat-1,' team');
       If maxrepeat<>1 then write('s');
       Write(' once and ',x);
       Write(' quiz');
       If x=1 then write('zes');
       Write(' ',maxrepeat-1-1,' team');
       If maxrepeat-1<>1 then write('s');
       Write(' once.'); end

    end;
9:
  redo:=false;
  rounds:=zrounds;
  Open:=rm2-(totquiz)mod(rm2);
  If open=rm2 then open:=0;
  if atar=true then open:=0;
{  Gotoxy(2,8);
  Write('Without increasing the number of rounds, there will be ',open);
  If open=1 then writeln(' open room.') else writeln(' open rooms.');
  Writeln; }

  For x:= 1 to 35 do for y:=1 to 35 do break[x,y]:=false;
     For x:=1 to rounds-1 do used4[x]:=rooms;
     used4[rounds]:=(tq)mod(rooms);
     if used4[rounds]=0 then used4[rounds]:=rooms;
     temp:=used4[rounds];
  Gotoxy(2,9);

 Textcolor(yellow); Textbackground(blue);
   For x:=9 to 24 do begin
      gotoxy(1,x); clreol; end;
  Gotoxy(2,9);
  Rs:='A';
  If (rounds <31) and (atar=false) and (rm2>1) and (open <>0) then begin
  WRITE('Choose room openings automatically or Manually (a/m): ');
  strange:=false;
  repeat
  I:=readkey;
   Case I of
    'a':rs:='A';
    'A':rs:='A';
    'm':rs:='M';
    'M':rs:='M'; end;
   if ord(I)=27 then goto 1;
  until (I='A') or (I='a') or (I='M') or (I='m');
  Write(rs);
  end else rs:='A';

  xtqzz:=rm2-(totquiz)mod(rm2);
  If Rs='a' then rs:='A'; If Rs='m' then rs:='M';
  If rs='A' then
     If (totquiz)mod(rm2)>0 then
        For x:=rm2-xtqzz+1 to rm2 do Break[rounds,x]:=true;


  if atar=true then for x:=1 to 35 do for y:=1 to 35 do break[x,y]:=false;
  If Rs='M' then Begin
{  o:=1;
  textbackground(blue);
  For x:=9 to 24 do begin
  Gotoxy(1,x);
  clreol; end;
  Gotoxy(2,9);
  Gotoxy(26,9);
  Write  (Rounds:2,' Rounds ',Open:2);
}  { If open=1 then writeln(' Room opening') else}{ writeln(' Room openings');
  Gotoxy(26,10);
  Write(Rounds+1:2,' Rounds ',Open+rm2:2,' Room openings');
  Gotoxy(26,11);
  Write(Rounds+2:2,' Rounds ',Open+2*rm2:2,' Room openings');
  Gotoxy(26,12);
  Write(Rounds+3:2,' Rounds ',Open+3*rm2:2,' Room openings   ');
  Gotoxy(26,13);
  Write(Rounds+4:2,' Rounds ',Open+4*rm2:2,' Room openings   ');
  Repeat
  Gotoxy(26,8+o);
  textbackground(red);
  Textcolor(white);
  Write(Rounds+o-1:2,' Rounds ',Open+(o-1)*rm2:2,' Room openings');
  I:=readkey;
  If (ord(I)=72) or (ord(I)=80) then begin
    Gotoxy(26,8+o);
    textbackground(blue);
    Textcolor(yellow);
    Write(Rounds+o-1:2,' Rounds ',Open+(o-1)*rm2:2,' Room openings'); end;
  If (ord(I)=72) then o:=o-1;
  If (ord(i)=80) then o:=o+1;
  if (ord(I)=27) then goto 9;
  If o=0 then o:=5;
  if o=6 then o:=1;
  until ord(I)=13;
  textbackground(blue);
  textcolor(yellow);

  Rounds:=Rounds+O-1;
  If o>1 then strange:=true;
  Open:=open+(o-1)*Rm2;
  Writeln;   }
  For x:=1 to rounds do used4[x]:=rm2;
  For x:=9 to 24 do begin
  Gotoxy(1,x);
  clreol; end;
  Gotoxy(2,9);
  If open=0 then begin rs:='A'; goto 10; end;

  If rounds<13 then begin

  spc:=(75-2*xrooms)div(2);
  Write('Mark ',open,' room opening');
  If open<>1 then write('s');
  Writeln(' with an x');
  writeln;
  for x:=1 to spc do Write(' ');write('  ');
  For x:=1 to xrooms do write(x:2);writeln;
  For x:=1 to rounds do begin For y:=1 to spc do write(' ');
    Write(x:2);textbackground(red);textcolor(white);For y:=1 to xrooms do write('  ');
    textbackground(blue);textcolor(yellow); writeln; end;
  Gotoxy(spc-5,12); write('Round');
{  For x:= 1 to open do begin
    Write  ('                    ',x:2,'. Round: ');Read(R);
    Write  ('                         Room: '); Readln(R2);
    writeln;  }
  x:=spc+4; y:=12;
  r:=1; r2:=1;
  tot:=0;
  textbackground(red);
  textcolor(white);
  Repeat
    Gotoxy(x,y);
    I:=readkey;
    if (ord(I)=56) or (ord(I)=72) and (y<>12) then begin
       y:=y-1; r:=r-1; end;
    if (ord(I)=50) or (ord(I)=80) and (y<>11+rounds) then begin
       y:=y+1; r:=r+1; end;
    if (ord(I)=52) or (ord(I)=75) and (r2<>1) then begin
       x:=x-2; r2:=r2-1; end;
    if (ord(I)=54) or (ord(I)=77) and (r2<>xrooms) then begin
       x:=x+2; r2:=r2+1; end;
    if (ord(I)=27) then goto 9;
    If ((I='x') or (I='X')) and (break[r,r2]=false) AND (used4[r]<>1)
      and (tot<open) then begin
      Break[r,r2]:=true; Used4[r]:=Used4[r]-1; tot:=tot+1; write('x'); end;
    If ((I=' ') or (ord(I)=83)) and (break[r,r2]=true) then begin
      Break[r,r2]:=false; Used4[r]:=Used4[r]+1; tot:=tot-1; write(' '); end;
    until (ord(I)=13) and (tot=open);
    end

    else begin
  spc:=(75-2*rounds)div(2);
  Write('Mark ',open,' round opening');
  If open<>1 then write('s');
  Writeln(' with an x');
  writeln;
  for x:=1 to spc do Write(' ');write('  ');
  For x:=1 to rounds do write(x:2);writeln;
  For x:=1 to xrooms do begin For y:=1 to spc do write(' ');
    Write(x:2);textbackground(red);textcolor(white);For y:=1 to rounds do write('  ');
    textbackground(blue);textcolor(yellow); writeln; end;
  Gotoxy(spc-5,12); write(' Room');
  x:=spc+4; y:=12;
  r:=1; r2:=1;
  tot:=0;
  textbackground(red);
  textcolor(white);
  Repeat
    Gotoxy(x,y);
    I:=readkey;
    if (ord(I)=56) or (ord(I)=72) and (y<>12) then begin
       y:=y-1; r2:=r2-1; end;
    if (ord(I)=50) or (ord(I)=80) and (y<>11+xrooms) then begin
       y:=y+1; r2:=r2+1; end;
    if (ord(I)=52) or (ord(I)=75) and (r<>1) then begin
       x:=x-2; r:=r-1; end;
    if (ord(I)=54) or (ord(I)=77) and (r<>rounds) then begin
       x:=x+2; r:=r+1; end;
    if (ord(I)=27) then goto 9;
    If ((I='x') or (I='X')) and (break[r,r2]=false) AND (used4[r]<>1)
      and (tot<open) then begin
      Break[r,r2]:=true; Used4[r]:=Used4[r]-1; tot:=tot+1; write('x'); end;
    If ((I=' ') or (ord(I)=83)) and (break[r,r2]=true) then begin
      Break[r,r2]:=false; Used4[r]:=Used4[r]+1; tot:=tot-1; write(' '); end;
    until (ord(I)=13) and (tot=open);
    end;
    xrounds:=rounds;
    textbackground(blue);
    textcolor(yellow);

  end;

  textbackground(blue);
  textbackground(yellow);



  rounds2:=rounds;



 { 5:end;}
10:
  redo:=false;
  rooms:=xrooms;
  for x:=1 to 35 do for y:=1 to 35 do two[x,y]:=false;
  If (atar=true) or (split2=true) or (tway=true) then begin
  If atar=true then t:=x2w*quizzes;
  If split2=true then t:=(x2w*teams)div(2);
  If tway=true then t:=xtquiz+1;
  tw:=t;


  Textbackground(blue);
  Gotoxy(2,9);



   Textcolor(yellow); Textbackground(blue);

 If (split2=true) or (tway=true) or ((atar=true) and ((teams)mod(3)<>0)) then begin

  For x:= 9 to 24 do begin
      gotoxy(1,x); clreol; end;

  Gotoxy(2,9);



  WRITE('Place two-way quizzes automatically or Manually (a/m): ');
  repeat
  I:=readkey;
   Case I of
    'a':rs2:='A';
    'A':rs2:='A';
    'm':rs2:='M';
    'M':rs2:='M'; end;
   if ord(I)=27 then begin goto 1;
   goto 9; end;
  until (I='A') or (I='a') or (I='M') or (I='m');
  Write(rs2); end;
  If Rs2='a' then rs2:='A'; If Rs2='m' then rs2:='M';

  If rs2='A' then begin
     If (atar)=true then
         for x:= 1 to rounds do for y:=rooms-x2w+1 to rooms do Two[x,y]:=true;
     If (split2=true) or (tway=true) then begin
         x:=rounds; y:=rooms+1; z:=0;
         Repeat
           y:=y-1;
           If y=0 then begin y:=rooms; x:=x-1; end;
           If break[x,y]=false then begin
               Two[x,y]:=true;
               z:=z+1; end;
         Until z=t; end;
      end;

  If Rs2='M' then Begin

  Writeln;
  For x:=9 to 24 do begin
  Gotoxy(1,x);
  clreol; end;
  Gotoxy(2,9);

  If rounds<12 then begin
  spc:=(75-2*xrooms)div(2);
  Write('Mark ',t,' two-way quiz');
  If t<>1 then write('zes');
  Writeln(' with an x');
  writeln;
  for x:=1 to spc do Write(' ');write('  ');
  For x:=1 to xrooms do write(x:2);writeln;
  For x:=1 to rounds do begin For y:=1 to spc do write(' ');
    Write(x:2);textbackground(red);textcolor(white);For y:=1 to xrooms do write('  ');
    textbackground(blue);textcolor(yellow); writeln; end;
  tot:=0;
  For x:=1 to rounds do used5[x]:=99;
  If atar=true then begin
    For x:=1 to rounds do used5[x]:=x2w;
    textbackground(red); textcolor(white);
    x:=1; y:=rooms; tot:=1;
    Gotoxy(y*2+spc+2,x+11); write('x'); Two[1,rooms]:=true;
    If x2w=2 then begin
       y:=rooms-1; Gotoxy(y*2+spc+2,x+11); write('x'); Two[1,rooms-1]:=true;
       tot:=2; end;
    textbackground(blue); textcolor(yellow); end;
  For x:=1 to rounds do for y:=1 to rooms do begin
    Gotoxy(y*2+spc+1,x+11);
    If break[x,y]=true then Write('  '); end;
  Gotoxy(spc-5,11); write('Round');
  x:=spc+4; y:=13;
  r:=2; r2:=1;
  textbackground(red);
  textcolor(white);
  Repeat
    Gotoxy(x,y);
    I:=readkey;
    if (ord(I)=56) or (ord(I)=72) and (y<>13) then begin
       y:=y-1; r:=r-1; end;
    if (ord(I)=50) or (ord(I)=80) and (y<>11+rounds) then begin
       y:=y+1; r:=r+1; end;
    if (ord(I)=52) or (ord(I)=75) and (r2<>1) then begin
       x:=x-2; r2:=r2-1; end;
    if (ord(I)=54) or (ord(I)=77) and (r2<>xrooms) then begin
       x:=x+2; r2:=r2+1; end;
    if (ord(I)=27) then goto 10;
    If ((I='x') or (I='X')) and (Two[r,r2]=false) and (break[r,r2]=false)
      and (tot<t) and (used5[r]<>0) then begin
      Two[r,r2]:=true; tot:=tot+1; write('x'); used5[r]:=used5[r]-1; end;
    If ((I=' ') or (ord(I)=83)) and (Two[r,r2]=true) then begin
      Two[r,r2]:=false; tot:=tot-1; used5[r]:=used5[r]+1; write(' '); end;
    until (ord(I)=13) and (tot=t);
    end

  Else begin
  spc:=(75-2*rounds)div(2);
  Write('Mark ',t,' two-way quiz');
  If t<>1 then write('zes');
  Write(' with an x');
  writeln;
  for x:=1 to spc do Write(' ');write('  ');
  For x:=1 to rounds do write(x:2);writeln;
  For x:=1 to xrooms do begin For y:=1 to spc do write(' ');
    Write(x:2);textcolor(white); textbackground(red);For y:=1 to rounds do write('  ');
    textbackground(blue); textcolor(yellow); writeln; end;
  tot:=0;
  For x:=1 to rounds do used5[x]:=99;
  If atar=true then begin
    For x:=1 to rounds do used5[x]:=x2w;
    textbackground(red); textcolor(white);
    x:=1; y:=rooms; tot:=1;
    Gotoxy(x+12,y*2+spc+1); write('x'); Two[1,rooms]:=true;
    If x2w=2 then begin
       y:=rooms-1; Gotoxy(x+12,y*2+spc+1); write('x'); Two[1,rooms-1]:=true;
       tot:=2; end;
    textbackground(blue); textcolor(yellow); end;
    textbackground(blue);
  For x:=1 to rounds do for y:=1 to rooms do begin
    Gotoxy(spc+1+2*x,y+10);
    If break[x,y]=true then Write('  '); end;
  textbackground(blue);

  Gotoxy(spc-5,12); write('Room');
  x:=spc+6; y:=11;
  r:=2; r2:=1;
  textbackground(red);
  textcolor(white);
  Repeat
    Gotoxy(x,y);
    I:=readkey;
    if (ord(I)=52) or (ord(I)=75) and (r<>2) then begin
       x:=x-2; r:=r-1; end;
    if (ord(I)=45) or (ord(I)=77) and (r<>rounds) then begin
       x:=x+2; r:=r+1; end;
    if (ord(I)=56) or (ord(I)=72) and (r2<>1) then begin
       y:=y-1; r2:=r2-1; end;
    if (ord(I)=50) or (ord(I)=80) and (r2<>xrooms) then begin
       y:=y+1; r2:=r2+1; end;
    if (ord(I)=27) then goto 10;
    If ((I='x') or (I='X')) and (Two[r,r2]=false) and (break[r,r2]=false)
      and (tot<t) and (used5[r]<>0) then begin
      Two[r,r2]:=true; tot:=tot+1; write('x'); used5[r]:=used5[r]-1; end;
    If ((I=' ') or (ord(I)=83)) and (Two[r,r2]=true) then begin
      Two[r,r2]:=false; tot:=tot-1; used5[r]:=used5[r]+1; write(' '); end;
    until (ord(I)=13) and (tot=t);
    end;



  end;

{   end;}

  textbackground(blue);
  textbackground(yellow);

  rounds2:=rounds;

end;


11:
    redo:=false;
    textcolor(yellow);
    textbackground(blue);
    For x:=9 to 24 do begin
  Gotoxy(1,x);
  clreol; end;
  Gotoxy(2,9);
  clreol;

  WRITE('Column or Row Strategy (c/r): ');

  tway:=twaylast;
  twoway:=twowaylast;
  split:=splitlst;
  splitlast:=splitlastlast;

  repeat
  I:=readkey;
   Case I of
    'r':rc:='R';
    'R':rc:='R';
    'c':rc:='C';
    'C':rc:='C'; end;

  if ord(I)=27 then begin
    If again=true then goto 1;
    if (rm2=1) then goto 1;
    If (atar=true) and ((teams)mod(3)=0) then goto 1;
    If (split2=false) and (tway=false) then
      begin again:=true; goto 9; end;

   goto 10;     end;
  until (I='r') or (I='R') or (I='C') or (I='c');
  again:=false;
 {  If strange=true then rc:='C'; }
  If split=true then rc:='C';
  If tway=true then rc:='C';
  If atar=true then rc:='R';
  Write(rc);
  Gotoxy(2,10);
  For x:=1 to 78 do write('_');

  If rc='r' then rc:='R';
  If rc='c' then rc:='C';




5: if en=true then redo:=false; end;




Procedure Order; label 2,3,4,21,25; Begin
 rounds:=xrounds;
 rooms:=rm2;


{****************************** Round Order *******************************}
     gotoxy(2,14);
     swi:=0; off:=0; v2:=1.00;
     Write('Sorting Rounds      >>  Switches : 0      Consec Quizzes : ',teams:5);

     off:=teams*(quizzes-1);
     done:=false;
     If (rounds>2) and (atar=false) and (teams<>rooms*3) then begin

     For x:=1 to teams do for y:=1 to rounds do rm[x,y]:=0;

     For x:=1 to rounds do
     for y:= 1 to rooms do begin
        a:=Quiz2[x,y,1];
        b:=Quiz2[x,y,2];
        c:=Quiz2[x,y,3];
        rm[a,x]:=rm[a,x]+1;
        rm[b,x]:=rm[b,x]+1;
        rm[c,x]:=rm[c,x]+1; end;

     Off:=0;
     For m:=1 to teams do
            for n:=1 to rounds-1 do
                   If (rm[m,n]=1) and (rm[m,n+1]=1) then begin
                   off:=off+1;
                   end;

           Gotoxy(61,14);
           Write(off:5);
           cnc:= off;



                   lastoff:=off;

     v2:=off/rooms/quizzes;

     lastoff:=30000;
     SWI:=0;
     lastsw:=0;
     x:=0; x2:=0;

     For x:=1 to rounds do for y:=1 to rounds do qa1[x,y]:=0;

     For x:=1 to rounds do for y:=1 to rounds do for z:=1 to rooms do
          If (Break[x,z]<>Break[y,z]) or (Two[x,z]<>two[y,z]) then begin
             qa1[x,y]:=99; qa1[y,x]:=99; end;

   Repeat
        x2:=x2+1;

    If (swi)mod(5)= 0 then begin
        Gotoxy(37,14);
        Write(swi);
        gotoxy(61,14);  write(off:5); end;



        Repeat s:=random(rounds)+2; until s<=rounds;
        Repeat r:=random(Rounds)+1; if keypressed then if ord(readkey)=27 then begin
           back:=true; goto 4; end;
           until (r>1) and (r<>s);

      if qa1[r,s]=0 then begin

         For x:=1 to rooms do for y:=1 to 3 do begin
         a:=quiz2[r,x,y]; quiz2[r,x,y]:=quiz2[s,x,y]; quiz2[s,x,y]:=a; end;

         Lastoff:=off;


         For x:=1 to teams do for y:=1 to rounds do rm[x,y]:=0;
         For x:=1 to rounds do
         for y:= 1 to rooms do begin
           a:=Quiz2[x,y,1];
           b:=Quiz2[x,y,2];
           c:=Quiz2[x,y,3];
           rm[a,x]:=rm[a,x]+1;
           rm[b,x]:=rm[b,x]+1;
           rm[c,x]:=rm[c,x]+1; end;

         Off:=0;

         For m:=1 to teams do for n:=1 to rounds-1 do begin
              If (rm[m,n]=1) and (rm[m,n+1]=1) then begin
                   off:=off+1;  end;  end;


         If off<=lastoff then swi:=swi+1 else
            begin
              For x:=1 to rooms do for y:=1 to 3 do begin
              a:=quiz2[r,x,y]; quiz2[r,x,y]:=quiz2[s,x,y]; quiz2[s,x,y]:=a;

              off:=lastoff;

              end; end;





              end;

           v2:=off/rooms/quizzes;



        Until (x2=800) or (off=0) or (done=true);

        end;

        Gotoxy(37,14);
        Write(swi);
        Gotoxy(61,14);
        Write(off:5);
        cnc:=off;

{****************************** Seating Order *******************************}
     gotoxy(2,15);
     if yquiz>1 then begin
     Write('Seating Teams       >>  Switches :        Variance Rating:');
     done:=false;
     For x:=1 to teams do for y:=1 to 3 do sit[x,y]:=0;
     For x:=1 to rounds do
     for y:= 1 to rooms do begin
        a:=Quiz2[x,y,1];
        b:=Quiz2[x,y,2];
        c:=Quiz2[x,y,3];
        Sit[a,1]:=Sit[a,1]+1;
        Sit[b,2]:=Sit[b,2]+1;
        Sit[c,3]:=Sit[c,3]+1; end;
     Quizzes:=x2quiz;
     Ideal:=Quizzes/way;

{     Write('  Q ',quizzes); readln; }
     Off:=0;
     ID:=Trunc(10*Ideal);
     For m:=1 to teams do for n:=1 to 3 do Off:=Off+Abs(id-sit[m,n]*10);
     last:=-1;
     SWI:=0;
     lastsw:=0;
     x:=0; x2:=0;
     Repeat

        x:=x+1;
        If (x)mod(25)=0 then x2:=x2+1;
        If ((swi) mod (5) =0) and (swi>last) then begin
           last:=swi;
           v2:=off/(rooms*teams*quizzes);

        Gotoxy(37,15);
        Write(swi);
        Gotoxy(61,15);
        Write(v2:5:2); end;
        c8:=0;
        Repeat c8:=c8+1; r:=random(Rounds)+1; if keypressed then if ord(readkey)=27 then begin
           back:=true; {if c8>300 then goto 25;} goto 2; end;
           until r>1;
        t:=random(rooms)+1;
        s1:=random(3)+1;
        Repeat s2:=random(3)+1 until s2<>s1;
        a:=quiz2[r,t,s1];
        b:=quiz2[r,t,s2];

        If (a<>0) and (b<>0) then begin

        Sit[a,s1]:=sit[a,s1]-1;
        Sit[a,s2]:=sit[a,s2]+1;
        Sit[b,s1]:=sit[b,s1]+1;
        Sit[b,s2]:=sit[b,s2]-1;
        oldoff:=off;
        s:=sit[m,n];
        off:=0;
        For m:=1 to teams do for n:=1 to 3 do Off:=Off+Abs(Id-sit[m,n]*10);
        If oldoff<off then begin
          Sit[a,s1]:=sit[a,s1]+1;
          Sit[a,s2]:=sit[a,s2]-1;
          Sit[b,s1]:=sit[b,s1]-1;
          Sit[b,s2]:=sit[b,s2]+1;
          off:=oldoff; end
        Else begin
          swi:=swi+1;
          quiz2[r,t,s1]:=b;
          quiz2[r,t,s2]:=a; end;
          t2:=(teams+20)*(quizzes+5)*5;
          If t2>3000 then t2:=3000;
        {  If (twoway=true) or ((roundrob=true) and (way=2)) then t2:=(t2)div(3); }

        If (x) mod (400+t2) = 0 then begin
          if off=lastsw then done:=true; lastsw:=off; end;

        end;

        Until (x2=32000) or (off=0) or (done=true);
        off2:=off;
        v2:=off/(Rooms*Teams*Quizzes);


{        Write('   ',rounds);readln; }
        Gotoxy(37,15);
25:        Write(swi);
        Gotoxy(61,15);
        Write(v2:5:2);

{****************************** Room Order *******************************}


{       z:=0;
       For x:=1 to rounds do for y:=1 to rooms do
           If (Break[x,y]=true) or (two[x,y]=true) then z:=z+1;

       If rounds*rooms>2*z+1 then}

      If ((atar=true) or (split2=true) or (tway=true)) and (rooms>1) then begin

        For x:=1 to rounds do begin
            x8:=0;
            Repeat
            Repeat y:=random(rooms)+1;
              if keypressed then if ord(readkey)=27 then
               begin; back:=true; goto 2; end;
            x8:=x8+1; if x8>3000 then goto 21;
            y2:=random(rooms)+1 until y<>y2;

            If (two[x,y]=true) and (quiz2[x,y,3]<>0) and
               (two[x,y2]=false) and (quiz2[x,y2,3]=0) and (quiz2[x,y2,2]<>0)
               then begin
               a:=quiz2[x,y,1]; b:=quiz2[x,y,2]; c:=quiz2[x,y,3];
               d:=quiz2[x,y2,1]; e:=quiz2[x,y2,2]; f:=quiz2[x,y2,3];
               quiz2[x,y,1]:=d; quiz2[x,y,2]:=e; quiz2[x,y,3]:=f;
               quiz2[x,y2,1]:=a; quiz2[x,y2,2]:=b; Quiz2[x,y2,3]:=c; end;
{               writeln(a,' ',b,' ',c,' ',d,' ',e,' ',f); readln;}
            done:=true;
            For g:=1 to x do for h:=1 to rooms do
               If ((two[g,h]=true) and (quiz2[g,h,3]<>0) and (break[g,h]=false)) or
                  ((two[g,h]=false) and (quiz2[g,h,3]=0) and (break[g,h]=false))
                  then done:=false;

          until done=true;  end;  end;


21:

     If rooms=1 then v:=0.00 else if totquiz<=rounds+1 then v:=1.00 else
     begin
     gotoxy(2,16);
     Write('Arranging Rooms     >>  Switches :        Variance Rating:');
     Lastsw:=-999;
     done:=false;
     For x:=1 to teams do for y:=1 to 35 do Rm[x,y]:=0;
     For x:=1 to rounds do
     for y:= 1 to rooms do begin
        a:=Quiz2[x,y,1];
        b:=Quiz2[x,y,2];
        c:=Quiz2[x,y,3];
        Rm[a,y]:=rm[a,y]+1;
        Rm[b,y]:=rm[b,y]+1;
        rm[c,y]:=rm[c,y]+1; end;
     Ideal:=Quizzes/Rooms;
     Off:=0;
     ID:=Trunc(10*Ideal);
     For m:=1 to teams do for n:=1 to rooms do Off:=Off+Abs(id-rm[m,n]*10);
     last:=-1;
     SWI:=0;
     x:=0; x2:=0;
     Repeat
        x:=x+1;
        If (x)mod(25)=0 then x2:=x2+1;
        If ((swi) mod (5) =0) and (swi>last) then begin
           last:=swi;
           v:=off/(rooms*teams*quizzes);
                 Gotoxy(37,16);
        Write(swi);
        gotoxy(61,16);
        Write(v:5:2);  end;


{        Writeln('**',split2,' ',tw,' ',rounds-1,' '); readln;}
        If ((atar=true) and (rooms=2))
        or (((split2=true) or (tway=true)) and (rooms=2) and (tw=rounds-1))
         then begin

           Gotoxy(37,16);
           Write(0);
           gotoxy(61,16);
           Write(' 1.00');
           goto 2; end;

        c10:=0;
        c9:=0;
        c8:=0;
        Repeat
           c10:=c10+1;
           If c10>1000 then goto 3;
           c9:=0;
           Repeat c9:=c9+1; if c9>1000 then goto 3; r:=random(Rounds)+1;
                  until r>1;
           If c9>100 then goto 3;
           s1:=random(rooms)+1;
           Repeat c8:=c8+1; s2:=random(rooms)+1; c8:=c8+1;
               If c8>100 then goto 3;
               if keypressed then if ord(readkey)=27 then begin;
               back:=true; goto 2; end;
           until s2<>s1;
        until (two[r,s1] = two[r,s2]) and (break[r,s1]=false) and (break[r,s2]=false);


        a:=quiz2[r,s1,1];
        b:=quiz2[r,s1,2];
        c:=quiz2[r,s1,3];
        d:=quiz2[r,s2,1];
        e:=quiz2[r,s2,2];
        f:=quiz2[r,s2,3];
        If (b<>0) and (e<>0) then begin
        if keypressed then if ord(readkey)=27 then
         begin;
         back:=true; goto 2; end;
        Rm[a,s1]:=rm[a,s1]-1;
        Rm[b,s1]:=rm[b,s1]-1;
        Rm[c,s1]:=rm[c,s1]-1;
        Rm[a,s2]:=rm[a,s2]+1;
        Rm[b,s2]:=rm[b,s2]+1;
        Rm[c,s2]:=rm[c,s2]+1;
        Rm[d,s1]:=rm[d,s1]+1;
        Rm[e,s1]:=rm[e,s1]+1;
        Rm[f,s1]:=rm[f,s1]+1;
        Rm[d,s2]:=rm[d,s2]-1;
        Rm[e,s2]:=rm[e,s2]-1;
        Rm[f,s2]:=rm[f,s2]-1;
        oldoff:=off;
        off:=0;
        For m:=1 to teams do for n:=1 to rooms do Off:=Off+Abs(Id-rm[m,n]*10);
        back:=false;
        if keypressed then if ord(readkey)=27 then
         begin;
         back:=true; goto 2; end;
        If oldoff<off then begin
          Rm[a,s1]:=rm[a,s1]+1;
          Rm[b,s1]:=rm[b,s1]+1;
          Rm[c,s1]:=rm[c,s1]+1;
          Rm[a,s2]:=rm[a,s2]-1;
          Rm[b,s2]:=rm[b,s2]-1;
          Rm[c,s2]:=rm[c,s2]-1;
          Rm[d,s1]:=rm[d,s1]-1;
          Rm[e,s1]:=rm[e,s1]-1;
          Rm[f,s1]:=rm[f,s1]-1;
          Rm[d,s2]:=rm[d,s2]+1;
          Rm[e,s2]:=rm[e,s2]+1;
          Rm[f,s2]:=rm[f,s2]+1;
          off:=oldoff; end
        Else begin
          swi:=swi+1;
          quiz2[r,s1,1]:=d;
          quiz2[r,s1,2]:=e;
          quiz2[r,s1,3]:=f;
          quiz2[r,s2,1]:=a;
          quiz2[r,s2,2]:=b;
          quiz2[r,s2,3]:=c;
        end;
          t2:=(teams+30)*(rooms+5);
          If (twoway=true) or ((roundrob=true) and (way=2)) then t2:=(t2)div(5);
          t2:=1500;
          if totquiz<120 then t2:=3000;
          if teams<50 then t2:=6000;

        {  If way=2 then t2:=(t2)div(3); }
          If (x) mod (250+T2) = 0 then begin
          if off=lastsw then done:=true; lastsw:=off;  end;
        end;
        Until (x2=32000) or (off=0) or (done=true);

        v:=off/(rooms*teams*quizzes);
        Gotoxy(37,16);
        Write(swi);
        gotoxy(61,16);
        Write(v:5:2);
     end;   
     2: end;
     3:
     For x:=1 to rounds do begin
     for y:= 1 to rooms do
        if Quiz2[x,y,1]<>0 then Write(f1,'   ',Quiz2[x,y,1]:3,Quiz2[x,y,2]:3,Quiz2[x,y,3]:3)
        Else Write(f1,'            ');
     writeln(f1); end;

  Close(f1);
  op1:=false;

  For X:= 1 to tms do begin
     For y:= 1 to tms do Qagainst[X,Y]:=0;
     For Y:= 1 to 35 do

        For Z:= 1 to 2 do begin
           RM[X,Y]:=0;
           SIT[X,Y]:=0;
        end; end; 4:end;


{***************************** OPEN FILES *****************************}

  Procedure files; begin

  op1:=true;
 { ASSIGN(F1,'temp.txt');}
  RESET(F1);
  op1:=true;

  ASSIGN(F2,FN);
  REWRITE(F2);
  op:=true;

  Read(f1,T);
  Readln(f1);
  Readln(f1);
  Read(f1,R);
  Readln(f1);
  Read(f1,QZ);
  Readln(f1);

{**************************** CHECK BRACKET ***************************}

  Close(f1);
  op1:=false;
  Reset(f1);
  op1:=true;
  For x:=1 to 5 do begin
     Readln(f1,info);
     Writeln(f2,info);
  end;

  For x:=1 to qz do begin
   Repeat
     inf2:='  ';
     Read(f1,inf2);
     if inf2=' 0' then inf2:='  ';
     Write(f2,inf2);
   Until eoln(f1);
   readln(f1);
   Writeln(f2);
  end;

close(f1);


end;
{      Procedure switch;
      begin } {****SWITCH****}

 {     c3:=0;
      c4:=0;
      Repeat
      c4:=c4+1; c5:=0;
      Qn1:=random(height)+1;
      a:=quiz[qn1,1,1]; b:=quiz[qn1,1,2]; c:=quiz[qn1,1,3];
      x:=a;
      if b>x then x:=b;
      if c>x then x:=c;
      If c5<30 then begin

      Quiz[qn1,1,1]:=Quiz[height,1,1]; Quiz[qn1,1,2]:=Quiz[height,1,2]; Quiz[qn1,1,3]:=Quiz[height,1,3];
      Quiz[height,1,1]:=a; Quiz[height,1,2]:=b; Quiz[height,1,3]:=c;
      used[qn1]:=true;
      For y:=1 to 3 do begin If a<b then begin t:=b; b:=a; a:=t; end;
         If b<c then begin t:=b; b:=c; c:=t; end; end;
      a1:=a; a2:=b; a3:=c;
      c5:=0;

      For s:=1 to tms do for t:=1 to 35 do rm[s,t]:=0;
      repeat
       repeat qn:=random(rounds-1)+2; rr:=random(rooms)+1;
      until (rm[qn,rr]=0);
       a:=quiz2[qn,rr,1]; b:=quiz2[qn,rr,2]; c:=quiz2[qn,rr,3];
       c5:=c5+1;
      until ((a=x) or (b=x) or (c=x) and (x>=a) and (x>=b) and (x>=c)) or (c5=100);
      rm[qn,r]:=1;
      For y:=1 to 3 do begin If a<b then begin t:=b; b:=a; a:=t; end;
         If b<c then begin t:=b; b:=c; c:=t; end; end;
      b1:=a; b2:=b; b3:=c; bb1:=a; bb2:=b; bb3:=c; qn2:=qn; r2:=rr;

      If c5<100 then begin
      c3:=0;
      repeat
       repeat qn:=random(Rounds-1)+2; rr:=random(rooms)+1 until (rm[qn,rr]=0);
       a:=quiz2[qn,rr,1]; b:=quiz2[qn,rr,2]; c:=quiz2[qn,rr,3];
       For y:=1 to 3 do begin If a<b then begin t:=b; b:=a; a:=t; end;
          If b<c then begin t:=b; b:=c; c:=t; end; end;
       c3:=c3+1;
      Until ((a=a2) or (b=a2) or (c=a2)) and ((a=b2) or (b=b2) or (c=b2))
         or ((a=a2) or (b=a2) or (c=a2)) and ((a=b3) or (b=b3) or (c=b3))
         or ((a=a3) or (b=a3) or (c=a3)) and ((a=b2) or (b=b2) or (c=b2))
         or ((a=a3) or (b=a3) or (c=a3)) and ((a=b3) or (b=b3) or (c=b3))
         or (c3=100);
      qn3:=qn; r3:=rr; d1:=a; d2:=b; d3:=c; dd1:=a; dd2:=b; dd3:=c; used[qn]:=true;

      If c3<100 then begin
        If (a2<>b2) and (a2<>b3) and (a2<>d1) and (a2<>d2) and (a2<>d3) then r:=a2 else r:=a3;
        If (b2<>a2) and (b2<>a3) and (b2<>d1) and (b2<>d2) and (b2<>d3) then s:=b2 else s:=b3;
        If (d1<>a2) and (d1<>a3) and (d1<>b2) and (d1<>b3) then t:=d1 else
        If (d2<>a2) and (d2<>a3) and (d2<>b2) and (d2<>b3) then t:=d2 else t:=d3;
        ttemp:=t;
        a:=r; b:=s; c:=t; For y:=1 to 3 do begin If a<b then begin t1:=b; b:=a; a:=t1; end;
                          If b<c then begin t1:=b; b:=c; c:=t1; end; end; r:=a; s:=b; t:=c;
        c3:=0;
        repeat
          repeat qn:=random(rounds-1)+2; rr:=random(rooms+1) until (rm[qn,rr]=0);
          a:=quiz2[qn,rr,1]; b:=quiz2[qn,rr,2]; c:=quiz2[qn,rr,3];
          For y:=1 to 3 do begin If a<b then begin t1:=b; b:=a; a:=t1; end;
                              If b<c then begin t1:=b; b:=c; c:=t1; end; end;
          c3:=c3+1;
        Until (a=r) and (b=s) and (c=t) or (c3=100); qn4:=qn; r4:=rr; rm[qn,rr]:=1;
        rr1:=r;ss1:=s;tt1:=t;

        If c3<100 then begin
          sw:=false;
}{          writeln;
          Writeln ('Switching Quizzes ');
          Writeln;
          Writeln ('  ',quiz[height,1,1]:3, quiz[height,1,2]:3, quiz[height,1,3]:3);
          Writeln ('  ',quiz2[qn2,r2,1]:3, quiz2[qn2,r2,2]:3, quiz2[qn2,r2,3]:3);
          Writeln ('  ',quiz2[qn3,r3,1]:3, quiz2[qn3,r3,2]:3, quiz2[qn3,r3,3]:3);
          Writeln ('  ',quiz2[qn4,r4,1]:3, quiz2[qn4,r4,2]:3, quiz2[qn4,r4,3]:3);
          Writeln; Writeln('To'); Writeln;}
{          If d2=ttemp then begin d2:=d1; d1:=ttemp; end;
          If d3=ttemp then begin d3:=d1; d1:=ttemp; end;
          If r=ttemp then begin r:=t; t:=ttemp; end;
          If s=ttemp then begin s:=t; t:=ttemp; end;
          If ((a2=d2) and (b2=d3)) or ((a2=d3) and (b2=d2)) then begin
             t1:=a2; a2:=b3; b3:=t1;
             If (d2<>a2) and (d2<>b3) and (s<>a2) and (s<>b3) then begin
                t1:=s; s:=d2; d2:=t1; sw:=true; end;
             If (d3<>a2) and (d3<>b3) and (s<>a2) and (s<>b3) then begin
                t1:=s; s:=d3; d3:=t1; sw:=true; end;
             If (d2<>a2) and (d2<>b3) and (r<>a2) and (r<>b3) then begin
                t1:=r; r:=d2; d2:=t1; sw:=true; end;
             If (d3<>a2) and (d3<>b3) and (r<>a2) and (r<>b3) then begin
                t1:=r; r:=d3; d3:=t1; sw:=true; end; end
             else begin
             t1:=a2; a2:=b2; b2:=t1;
             If (d2<>a2) and (d2<>b2) and (s<>a2) and (s<>b2) then begin
                t1:=s; s:=d2; sw:=true; d2:=t1; end;
             If (d3<>a2) and (d3<>b2) and (s<>a2) and (s<>b2) then begin
                t1:=s; s:=d3; sw:=true; d3:=t1; end;
             If (d2<>a2) and (d2<>b2) and (r<>a2) and (r<>b2) then begin
                t1:=r; r:=d2; sw:=true; d2:=t1; end;
             If (d3<>a2) and (d3<>b2) and (r<>a2) and (r<>b2) then begin
                t1:=r; r:=d3; sw:=true; d3:=t1; end; end;
          c3:=0;
        If sw=true then begin
          Quiz[height,1,1]:=a1; Quiz[height,1,2]:=a2; Quiz[height,1,3]:=a3;
          Quiz[height+1,1,1]:=b1; Quiz[height+1,1,2]:=b2; Quiz[height+1,1,3]:=b3;
          Quiz[height+2,1,1]:=d1; Quiz[height+2,1,2]:=d2; Quiz[height+2,1,3]:=d3;
          Quiz[height+3,1,1]:=t;  Quiz[height+3,1,2]:=r;  Quiz[height+3,1,3]:=s;
          rr:=timesused[qn2]+1;
            Quiz2[qn2,r2,1]:=Quiz2[qn2,rr,1];
            Quiz2[qn2,r2,2]:=Quiz2[qn2,rr,2];
            Quiz2[qn2,r2,3]:=Quiz2[qn2,rr,3];
            Quiz2[qn2,rr,1]:=0; Quiz2[qn2,rr,2]:=0; Quiz2[qn2,rr,3]:=0;
            Timesused[qn2]:=timesused[qn2]+1;
            QA1[qn2,bb1]:=0; QA1[qn2,bb2]:=0; QA1[qn2,bb3]:=0;
          rr:=timesused[qn3]+1;
            Quiz2[qn3,r3,1]:=Quiz2[qn3,rr,1];
            Quiz2[qn3,r3,2]:=Quiz2[qn3,rr,2];
            Quiz2[qn3,r3,3]:=Quiz2[qn3,rr,3];
            Quiz2[qn3,rr,1]:=0; Quiz2[qn3,rr,2]:=0; Quiz2[qn3,rr,3]:=0;
            Timesused[qn3]:=timesused[qn3]+1;
            QA1[qn3,dd1]:=0; QA1[qn3,dd2]:=0; QA1[qn3,dd3]:=0;
          rr:=timesused[qn4]+1;
            Quiz2[qn4,r4,1]:=Quiz2[qn4,rr,1];
            Quiz2[qn4,r4,2]:=Quiz2[qn4,rr,2];
            Quiz2[qn4,r4,3]:=Quiz2[qn4,rr,3];
            Quiz2[qn4,rr,1]:=0; Quiz2[qn4,rr,2]:=0; Quiz2[qn4,rr,3]:=0;
            Timesused[qn4]:=timesused[qn4]+1;
            QA1[qn4,rr1]:=0; QA1[qn4,ss1]:=0; QA1[qn4,tt1]:=0;
}{          Writeln ('  ',quiz[height,1,1]:3, quiz[height,1,2]:3, quiz[height,1,3]:3);
          Writeln ('  ',quiz[height+1,1,1]:3, quiz[height+1,1,2]:3, quiz[height+1,1,3]:3);
          Writeln ('  ',quiz[height+2,1,1]:3, quiz[height+2,1,2]:3, quiz[height+2,1,3]:3);
          Writeln ('  ',quiz[height+3,1,1]:3, quiz[height+3,1,2]:3, quiz[height+3,1,3]:3);}
{          height:=height+3;
          For x:=1 to 1000 do for y:=1 to 35 do z:=1;
         end; end; end;
         end;
         end;
     Until (c3<100) or (c4=50);} {Switch Loop} {
     c3:=0;
     end;


 }


  Procedure Printresults; begin

  {************************** Print Results ***********************}

{  Writeln('xt**',xtquiz);readln;}

  Reset(f1);
  op1:=true;
  Readln(f1);
  Readln(f1);
  Readln(f1);
  Readln(f1);
  Readln(f1);

  For Q:= 1 to QZ+xtquiz do begin
      For X:= 1 to R do begin
        If not EOLN(f1) then begin
          If Break[q,x]=true then begin
               A:=0; b:=0; c:=0; end
               else  Read(f1,A,B,C);
          Quiz2[A,Q,1]:=B;  RM[A,X]:=RM[A,X]+1;  SIT[A,1]:=SIT[A,1]+1;
          Quiz2[A,Q,2]:=C;
          Quiz2[B,Q,1]:=A;  RM[B,X]:=RM[B,X]+1;  SIT[B,2]:=SIT[B,2]+1;
          Quiz2[B,Q,2]:=C;
          Quiz2[C,Q,1]:=A;  RM[C,X]:=RM[C,X]+1;  SIT[C,3]:=SIT[C,3]+1;
          Quiz2[C,Q,2]:=B;
          Qagainst[A,B]:=Qagainst[A,B]+1;
          Qagainst[A,C]:=Qagainst[A,C]+1;
          Qagainst[B,A]:=Qagainst[B,A]+1;
          Qagainst[C,A]:=Qagainst[C,A]+1;
          Qagainst[B,C]:=Qagainst[B,C]+1;
          Qagainst[C,B]:=Qagainst[C,B]+1;
        end;

      End;
      Readln(f1);
  End;

  For X:=1 to T do begin
     Y:=1;
     Q:=1;
     For Q:= 1 to QZ+xtquiz do begin
         QA1[X,Y]:=Quiz2[X,Q,1];
         Y:=Y+1;
         QA1[X,Y]:=Quiz2[X,Q,2];
         Y:=Y+1;
     End;
  End;

  For Z:= 1 to T do
     For X:= 1 to Q*2 do begin
        For Y:=1 to Q*2-1 do
          IF QA1[Z,Y]>QA1[Z,Y+1] Then begin
             TEMP:=QA1[Z,Y];
             QA1[Z,Y]:=QA1[Z,Y+1];
             QA1[Z,Y+1]:=TEMP;
          End;
     End;

{  If T<19 Then begin  }

{********************** 1 - 18 teams PRINT RESULTS *********************}

{  Writeln(F2);
  Write(F2,'     PAIRINGS');
  for x:= 1 to (3*T-7) do write(f2,' ');
  Write(F2,'RMS');
  For x:= 1 to 2*R-1 do write(f2,' ');
  Writeln(f2,'POS');

  Write(F2,'--   ');
  for x:= 1 to T*3-2 do write(f2,'-');
  write(f2,'   ');
  for x:= 1 to 2*r-1 do write(f2,'-');
  If R=1 then write(f2,'--');
  If r>1 then Write(f2,'  ');
  write(f2,' ');
  Writeln(f2,'-----');

  Write(f2,'TM   1 ');
  for x:=2 to T do begin
      If x<10 then write(f2,' ');
      write(f2,x,' '); end;
  Write(f2,'  ');
  For x:= 1 to R do write(f2,x,' ');
  Writeln(f2,'  1 2 3');

  Write(F2,'--   ');
  for x:= 1 to T*3-2 do write(f2,'-');
  write(f2,'   ');
  for x:= 1 to 2*r-1 do write(f2,'-');
  If R=1 then write(f2,'--');
  If r>1 then Write(f2,'  ');
  write(f2,' ');
  Writeln(f2,'-----');

  For x:= 1 to T do begin
      If x<10 then write(f2,' ');
      Write(f2,x,'   ');
      For y:= 1 to T do begin
         If (x<>y) then write(f2,Qagainst[x,y],'  ')
         Else write(f2,'-  '); end;
      Write(f2,' ');
      For y:= 1 to R do write(f2,RM[x,y],' ');
      Write(f2,'  ');
      For y:= 1 to 3 do write(f2,SIT[x,y],' ');
      Writeln(f2); end;

  Write(F2,'--   ');
  for x:= 1 to T*3-2 do write(f2,'-');
  write(f2,'   ');
  for x:= 1 to 2*r-1 do write(f2,'-');
  If R=1 then write(f2,'--');
  If r>1 then Write(f2,'  ');
  write(f2,' ');
  Writeln(f2,'-----');

  end

  Else begin
}
{*********************** 19 + teams PRINT RESULTS **********************}

  Writeln(F2);
  Writeln(F2,'     PAIRINGS');

  Write(F2,'--   ');
  for x:= 1 to T*3-2 do write(f2,'-');
  writeln(f2,'   --');

  Write(f2,'TM   1 ');
  for x:=2 to T do begin
      If x<10 then write(f2,' ');
      write(f2,x,' '); end;
      Write(F2,'  TM');
      Writeln(f2);

  Write(F2,'--   ');
  for x:= 1 to T*3-2 do write(f2,'-');
  Write(f2,'   --');
  writeln(f2);

  For x:= 1 to T do begin
      If x<10 then write(f2,' ');
      Write(f2,x,'   ');
      For y:= 1 to T do begin
         If (x<>y) then write(f2,Qagainst[x,y],'  ')
         Else write(f2,'-  '); end;
      Write(F2,' ',x);
      writeln(f2);
  end;

  Write(F2,'--   ');
  for x:= 1 to T*3-2 do write(f2,'-');
  writeln(f2,'   --');

  Write(f2,'TM   1 ');
  for x:=2 to T do begin
      If x<10 then write(f2,' ');
      write(f2,x,' '); end;
      Write(F2,'  TM');
      Writeln(f2);

  Write(F2,'--   ');
  for x:= 1 to T*3-2 do write(f2,'-');
  Write(f2,'   --');
  writeln(f2);



  Writeln(F2);
  Write(F2,'     RMS');
  For x:= 1 to 3*R-1 do write(f2,' ');
  Writeln(f2,'POS');

  line1;

  Write(f2,'TM   ');
  For x:= 1 to R do begin
     write(f2,x:2,' '); end;
  Writeln(f2,'   1  2  3');

  line1;

  For x:= 1 to T do begin
      Write(f2,x:2,'   ');
      For y:= 1 to R do begin
         write(f2,RM[x,y]:2,' ');
           end;
      Write(f2,'  ');
      For y:= 1 to 3 do write(f2,SIT[x,y]:2,' ');
      Writeln(f2);
  end;

  line1;

  Write(f2,'TM   ');
  For x:= 1 to R do begin
     if x<10 then write(f2,' ');
     write(f2,x,' '); end;
  Writeln(f2,'   1  2  3');

  line1;

  Writeln(f2);
  Writeln(F2,'Room Variance: ',v:5:2,'  Seating Variance: ',v2:5:2,'  Consec Quizzes:  ',cnc);

  CLOSE(F1);
  op1:=false;
  CLOSE(F2); op:=false;   {end;}


  end;


  Procedure view1; begin

  o:=lasto;
  Repeat
  tbb;
  tcy;
  If found=true then begin
    Gotoxy(1,17); clreol;
  Gotoxy(28,18);
  Write('Recall Another Bracket   '); end;
  Gotoxy(28,19);
  Write('View Bracket             ');
  Gotoxy(28,20);
  Write('View Team Pairings       ');
  Gotoxy(28,21);
  Write('View Room / Seating Info ');
  Gotoxy(28,22);
  Write('Print This Bracket       ');
  Gotoxy(28,23);
  Write('Return to Main Menu      ');
  Gotoxy(28,18+o);
  tbr;
  tcw;
  If o=0 then write('Recall Another Bracket  ');
  If o=1 then Write('View Bracket            ');
  If o=2 then Write('View Team Pairings      ');
  If o=3 then Write('View Room / Seating Info');
  If o=4 then Write('Print This Bracket      ');
  If o=5 then Write('Return to Main Menu     ');
  I:=readkey;
  if ord(I)<>13 then ready2:=true;
  If (ord(I)=56) or (ord(I)=72) then o:=o-1;
  If (ord(I)=50) or (ord(i)=80) then o:=o+1;
  If (o=0) and (found=false) then o:=5;
  If o=-1 then o:=5;
  if o=6 then if found=false then o:=1 else o:=0;
  until (ord(I)=13) {and (ready2=true)};
  lasto:=o;
  tbb;
  tcy;
  end;



 Procedure searchfollow;
 label 1;
 begin
          If found=false then goto 1;
          Assign(f4,fn);
          Reset(f4);
          op1:=true;
          Readln(f4,teams);
          Readln(f4,quizzes);
          Readln(f4,rooms);
          Readln(f4,rounds);
          close(f4);
          op1:=false;
  tcy;
  Gotoxy(2,3);
  clreol;
  For x:=6 to 17 do begin
  Gotoxy(1,x); clreol; end;
  Gotoxy(2,3);
  Write('Teams:      Quizzes Per Team:      Rooms:');
  Gotoxy(9,3); write(teams); Gotoxy(44,3); write(rooms);
  Gotoxy(32,3); write(quizzes);
      view2;

      1:  end;

Procedure zset; begin
    used[0]:=false;
    used2[0]:=false;
    used4[0]:=0;
    rmax[0]:=0;
    timesused[0]:=0;
    For x8:=1 to teams do begin
         qagainst[x8,0]:=-1;
         qagainst[0,x8]:=-1;  end;
    For x8:=1 to 30 do qa1[x8,0]:=0; end;

{ Procedure write3; begin
  Assign(f3,'temp2.txt');
     rewrite(f3);
     Writeln(F3,Teams,' Teams');
     Writeln(F3,x2quiz,' Quizzes');
     Writeln(F3,Rooms,' Rooms');
     Writeln(F3,Rounds, ' Rounds');
     Writeln(F3);
     For x:=1 to rounds do begin
     for y:= 1 to rooms do
        Write(f3,Quiz2[x,y,1]:3,Quiz2[x,y,2]:3,Quiz2[x,y,3]:3,'  ');
        writeln(f3); end;
    close(f3);
  end;
}


{------------------------------------------------------------------------}
{&&}

Label 1,2,3,4;
label 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,21,22,25;

BEGIN
  Assign(f1,'temp.txt');
  op1:=false;
  fn:='';
  first:=true;
13:
  roundrob:=false;
  demo:=false;
  en:=false;
  found:=false;
  search:=false;
  strange:=false;
  redo:=false;
  checkrep:=false;
  rept:=false;
 1:clrscr;
  found:=false;
  startup;
  redo:=false;

 14:
 found:=false;
  atar:=false;
  redo:=false;
  rob3:=false;
  twoway:=false;
  If o2=0 then o2:=6;

  If o2=2 then begin twoway:=true;
         roundrob:=false;
         rob3:=false;
         Gotoxy(59,1);
         Textbackground(lightgray); Textcolor(black); Write('                2-way');
         tbb; tcy;
         way:=2; initialize; end;
  If o2=1 then begin way:=3;
         roundrob:=false;
         Gotoxy(59,1);
         Textbackground(lightgray); Textcolor(black); Write('                3-way');
         tbb; tcy;
         Initialize; end;
  If o2=3 then begin twoway:=true;
         rob3:=true;
         Gotoxy(59,1);
         Textbackground(lightgray); Textcolor(black); Write('    3-way Round Robin');
         tbb; tcy;
         way:=3; initialize; end;
  If o2=4 then begin twoway:=true;
         roundrob:=true;
         Gotoxy(59,1);
         Textbackground(lightgray); Textcolor(black); Write('    2-way Round Robin');
         tbb; tcy;
         way:=2; initialize; end;
  If o2=5 then begin
         atar:=true;
         rewr:=false;
         Gotoxy(59,1);
         Textbackground(lightgray); Textcolor(black); Write('   Efficiency Bracket');
         tbb; tcy;
         initialize; end;
  If o2=6 then begin
       recll;
       if found=false then goto 1;

       searchfollow; if fn='' then goto 1; goto 9;
  end;

  If o2=7 then goto 5;

  if en=true then goto 13;

  redo:=false;

  if en=true then goto 13;

  Goto 19;


  2:redo:=true;

  initialize;


  19:  if en=true then goto 13;

{*********************** Create Bracket by Rows *************************}

  Gotoxy(2,12);
  IF rc='R' then begin
  rounds:=xrounds;
  if atar=true then rounds:=quizzes;
  Write('Selecting Pairings  >>  Iteration:        Round:    of ',rounds);
  rooms:=rm2;
  Totquiz:=(Teams*Quizzes)Div(3);
  If atar=true then totquiz:=quizzes*rooms;
  If twoway=true then totquiz:=(teams*quizzes)div(2);
  It:=0;
17:  stop:=true;
  Repeat {Whole Loop}
     tq:=0;
     It:=It+1;
     if (atar=true) or (twoway=true) then zset;
     If (atar=true) or (twoway=true) then open:=0;
     For x:=1 to Tms do for y:=1 to Tms do qagainst[x,y]:=0;
     For x:=1 to Tms do timesused[x]:=0;
     For x:=1 to TMS do for y:=1 to 35 do for z:=1 to 3 do quiz2[x,y,z]:=0;
     Round:=1;
     count2:=0; c4:=0;
     Repeat {Round Loop}
        Gotoxy(37,12);
        Write(it);
        Gotoxy(51,12);
        Write('  ');
        Gotoxy(51,12);
        Write(Round);
        For x:=1 to Tms do used[x]:=false;
        Room:=0;
        if (atar=true) or (twoway=true) then zset;
        If (rs='M') and (round<rounds) then Room:=Rooms-used4[round];
           Repeat {Room Loop}
              Count:=0;
              Room:=Room+1;
              Repeat {Quiz Loop}
                 if keypressed then if ord(readkey)=27 then goto 2;
                 count:=count+1;
                 If round = 1 then begin x:=1+3*(Room-1); y:=x+1; z:=x+2;
                 If atar=true then if room>x3w then begin
                        zset;
                        z:=0;
                        if (x2w=2) and (room=rooms) then begin
                        y:=teams; x:=teams-1; end; end;
                 If twoway =true then begin x:=1+2*(room-1); y:=x+1; z:=0; end;
                         end
                 else begin
                    c4:=0;
                    used[0]:=true;
                    Repeat if (c4=0) and (used[x]=false) then x:=leastused[room] else begin
                      x:=random(teams)+1; if keypressed then if ord(readkey)=27 then goto 2;c4:=c4+1 end;
                      until (used[x]=false) and (timesused[x]<quizzes)
                      or (c4>=1200);
                    if c4<1200 then c4:=0;
                    If c4<1200 then Repeat y:=random(teams)+1; c4:=c4+1;
                    until (used[y]=false) and (x<>y) and (timesused[y]<quizzes) or (c4>=1200);
                    If c4<1200 then begin c4:=0;


                    If atar=false then x3w:=999;

{     gotoxy(1,15);

     For f:=1 to rounds do begin; for g:=1 to rooms do
            Write(quiz2[f,g,1],' ',quiz2[f,g,2],' ',quiz2[f,g,3],'    '); writeln;
            end;
     Write(x,' ',y,' --'); For e:=1 to teams do write (used5[e],' ');
     readln;
                          end;                                      }



                    If ((atar=true) and (room>x3w)) or (twoway=true) then begin
                        z:=0; zset; end

                    else
                    Repeat z:=random(teams)+1; c4:=c4+1;
                    until (used[z]=false) and (x<>y) and (y<>z) and (x<>z) and
                          (timesused[z]<quizzes) or (c4>=1200); end; end;
              Until (qagainst[x,y]<1) and (qagainst[x,z]<1) and (qagainst[y,z]<1) or (count=50) or (c4>=1200);
            {  Gotoxy(20,20); write('x: ',x,' y: ',y,' z: ',z); readln;}

              Used[x]:=true;
              Used[y]:=true;
              Used[z]:=true;
              quiz2[round,room,1]:=x;
              quiz2[round,room,2]:=y;
              quiz2[round,room,3]:=z;
           Until (room=rooms) or (tq+room=totquiz) or (count>=50) or (c4>=1200); {Room Loop}
           If (count < 50) and (c4<1200) then begin
              c2:=0;
              count2:=0;
              stop:=false;
              For c1:= 1 to rooms do begin
                 x:=quiz2[round,c1,1]; y:=quiz2[round,c1,2]; z:=quiz2[round,c1,3];
                 qagainst[x,y]:=1; qagainst[x,z]:=1; qagainst[y,z]:=1;
                 qagainst[y,x]:=1; qagainst[z,x]:=1; qagainst[z,y]:=1;
                 Timesused[x]:=Timesused[x]+1; Timesused[y]:=timesused[y]+1; Timesused[z]:=timesused[z]+1;
                 If (atar=true) or (twoway=true) then zset; end;
                 For x:= 1 to rooms do Leastused[x]:=0;
                 For x:= 1 to rooms do begin
                     us:=false;
                     low:=0;
                     timesused[low]:=999;
                     For y:=1 to teams do If timesused[y]<=timesused[low] then begin
                          us:=false;
                          For z:=1 to x-1 do if leastused[z]=y then us:=true;
                          If us=false then Low:=y; end;
                     leastused[x]:=low; end;

              Round:=round+1; If RS='A' then tq:=tq+room;
              If rs='M' then tq:=tq+used4[round-1];
              end else if
           (tq<totquiz) and (Count2 >= 7) and (Round>3) {and (rs='A')} then begin

              If stop=true then begin
                 For a:=1 to rooms do begin
                 For b:=1 to 3 do Quiz2[round,a,b]:=Quiz[a,1,b];
                 x:=quiz2[round,a,1]; y:=quiz2[round,a,2]; z:=quiz2[round,a,3];
                 qagainst[x,y]:=1; qagainst[x,z]:=1; qagainst[y,z]:=1;
                 qagainst[y,x]:=1; qagainst[z,x]:=1; qagainst[z,y]:=1;
                 Timesused[x]:=Timesused[x]+1; Timesused[y]:=timesused[y]+1; Timesused[z]:=timesused[z]+1; end;
                 If twoway=true then zset;
                 tq:=tq+rooms;
                 Round:=round+1; end;
              stop:=true;
              Round:=Round-1;

              c9:=0;
              Repeat
                    R:=Random(Round);
                    c9:=c9+1;
              until (r>1) and (used4[r]=used4[round]) or (c9=500);

              If c9>=500 then goto 15;

              For d:=1 to rooms do begin
                 a:=quiz2[round,d,1]; b:=quiz2[round,d,2]; c:=quiz2[round,d,3];
                 x:=quiz2[r,d,1]; y:=quiz2[r,d,2]; z:=quiz2[r,d,3];
                 quiz[d,1,1]:=x; quiz[d,1,2]:=y; quiz[d,1,3]:=z;
                 quiz2[r,d,1]:=a; quiz2[r,d,2]:=b; quiz2[r,d,3]:=c;
                 qagainst[x,y]:=0; qagainst[x,z]:=0; qagainst[y,z]:=0;
                 qagainst[y,x]:=0; qagainst[z,x]:=0; qagainst[z,y]:=0;
                 Timesused[x]:=Timesused[x]-1; Timesused[y]:=timesused[y]-1; Timesused[z]:=timesused[z]-1;
                 end;
              it:=it+1;
              d:=r;
              tq:=tq-rooms;
              c4:=0;
              count2:=0;
                 For x:= 1 to rooms do Leastused[x]:=0;
                 For x:= 1 to rooms do begin
                     us:=false;
                     low:=0;
                     timesused[low]:=999;
                     For y:=1 to teams do If timesused[y]<=timesused[low] then begin
                          us:=false;
                          For z:=1 to x-1 do if leastused[z]=y then us:=true;
                          If us=false then Low:=y; end;
                     leastused[x]:=low; end;
              end  ;
     Goto 16;
     15: { Else if ((rs='M') and (c2>=7)) then begin }
              count2:=0;
              c4:=0;
              c2:=0;
              tq:=0;
              It:=It+1;
              For x:=1 to Tms do for y:=1 to Tms do qagainst[x,y]:=0;
              For x:=1 to Tms do timesused[x]:=0;
              For x:=1 to 35 do for y:=1 to 15 do for z:=1 to 3 do quiz2[x,y,z]:=0;
              If twoway=true then zset;
              Round:=1; {end;}

    16:   c2:=c2+1;
       count2:=count2+1;

       {Round Loop}
       Until (tq>=totquiz) or (round>rounds); {Round Loop}
     Until(tq>=totquiz); {Whole Loop}


                 If (atar=true) and (room>x3w) and (x2w<>0) then begin
                      n:=(x2w*rounds*2) div (teams);
                      m:=n;
                      If (x2w*rounds*2) mod (teams) <>0 then m:=m+1;
                      For a:=1 to teams do used5[a]:=0;
                      For a:=1 to rounds do for b:=rooms-x2w+1 to rooms do begin
                            c:=quiz2[a,b,1]; d:=quiz2[a,b,2];
                            used5[c]:=used5[c]+1;
                            used5[d]:=used5[d]+1; end;
                      For a:=1 to teams do
                      if (used5[a]>m) or (used5[a]<n) then goto 17; end;







{     Gotoxy(20,20);
     For x:=1 to rounds do begin
     for y:= 1 to rooms do
        Write(Quiz2[x,y,1]:3,Quiz2[x,y,2]:3,Quiz2[x,y,3]:3,'  ');
        writeln; end;
}

     rewrite(f1);
     Writeln(F1,Teams,' Teams');
     Writeln(F1,x2quiz,' Quizzes');
     Writeln(F1,Rooms,' Rooms');
     Writeln(F1,Rounds, ' Rounds');
     Writeln(F1);
     For x:=1 to rounds do begin
     for y:= 1 to rooms do
        Write(f1,Quiz2[x,y,1]:3,Quiz2[x,y,2]:3,Quiz2[x,y,3]:3,'  ');
     writeln(f1); end;
  op1:=false;
  Close(f1);
  op1:=true;
{  Assign(f1,'temp.txt');}
  end;

  If rc='C' then begin

{************************ Create Bracket by Columns ************************}

  10:
  18:

  if split2=true then split:=true;
  If split=true then twoway:=false;
  lineready:=false;
  splitdone:=false;

  If (twoway=false) and (split=false) and (2*quizzes>teams) then begin
   checkrep:=true; end;


  Gotoxy(2,12);
  Write('Selecting Pairings  >>  Iteration:        Quiz:     of ',totquiz);
  quizzes:=yquiz;
  rm2:=xrooms;
  rooms:=1;
  Rounds:=TRUNC(Teams/way/Rooms*Quizzes+0.999);
  if (((Teams+1)div(way-1))-1 <quizzes) then countset:=15 else countset:=2;
  Totquiz:=xquiz;
  It:=0;
  It:=It+1;
  For x:=0 to Tms do timesused[x]:=0;
  For x:=0 to Tms do for y:=1 to Tms do qagainst[x,y]:=0;
  For x:=0 to Tms do qagainst[x,x]:=1;
  For x:=1 to 500 do for y:=1 to 1 do for z:=1 to 3 do quiz[x,y,z]:=0;
  For x:=0 to tms do rmax[x]:=0;


  Round:=1;
  Tmpqz:=yquiz;
  Quizzes:=(teams-1)div(way-1);
  If tmpqz<quizzes then quizzes:=tmpqz;
  Trep:=rep;
  trounds:=0;

{  For rep:=1 to trep do begin  }
  rep:=trep;
     Quizzes:=Quizzes*rep;
{     if rep=trep then quizzes:=Tmpqz;  }
     ready:=true;
     Prounds:=trounds;
     Trounds:=trounds+((teams-1)*teams)DIV(way*2);
     If trounds>rounds then trounds:=rounds;
     If xtquiz=2 then trounds:=trounds-1;
     count2:=0;
     count:=0;

     Splitdone:=false;
     lineready:=false;
{     If split=true then rounds:=totquiz;}

   Repeat {splits}

     If splitdone=true then split:=false;
     If split=true then quizzes:=x3w;
     If (split=true) and (x3w=0) then begin
             split:=false;
             prounds:=round+1;
             quizzes:=x2w;
             lineready:=true;
             for x:=1 to teams do timesused[x]:=0;
             splitdone:=true; twoway:=true;
             rounds:=totquiz; end;


     Repeat {Round Loop};
        count:=0;
        For x:=1 to Tms do used[x]:=false;
        Room:=0;
        Gotoxy(37,12);
        Write(it);
        Gotoxy(50,12);
        write(Round);
        Repeat {room Loop}
              If twoway=true then zset;
              c:=0; c1:=0; c2:=0; c3:=0;
              Room:=Room+1;
              Repeat {Quiz Loop}
                 if keypressed then if ord(readkey)=27 then goto 2;
                 count:=count+1;
                 If (round <= (teams) div (way)) and (lineready=false)

                  then begin x:=1+way*(Round-1); y:=x+1; z:=x+2;

                    if twoway=true then z:=0; end else begin
                    c2:=0;
                                        Repeat x:=random(teams)+1; c2:=c2+1; until (used[x]=false)
                           and (x<=teams) and (timesused[x]<quizzes) or (c2>100);
                    c3:=0;
                    {if twoway=true then zset;}
                    If c2<100 then
                    Repeat y:=random(teams)+1;
                    {if twoway=true then zset;}
{If lineready=true then begin
gotoxy(1,18);
Writeln(' x: ',x,' y: ',y,' z: ',z,'     ');
Writeln(' used[y]: ',used[y],' timesused[y]: ',timesused[y],' rep: ',rep,'     ');
Writeln(' qagainst[x,y]: ',qagainst[x,y],' rmax[x]: ',rmax[x],' maxrepeat: ',maxrepeat,'     ');
Writeln(' used[y]: ',used[y],' timesused[y]: ',timesused[y],' rep: ',rep,'     ');
Writeln(' Quizzes: ',quizzes,' rmax[y]: ',rmax[y],'       ');
readln; end; }
                         c3:=c3+1; until (used[y]=false) and (x<>y)
                         and (timesused[y]<quizzes) and (qagainst[x,y]<rep)
                         and ((qagainst[x,y]<rep-1) or ((rmax[x]<>maxrepeat) and (rmax[y]<>maxrepeat)))
                         or (c3>100)
                    Else c3:=101;
                    c:=0;
                    if twoway=true then zset;
                    If c3<100 then
                    if (round<rounds-xtquiz) or (tway=false) then
                          Repeat z:=random(teams)+1;
                          if twoway=true then z:=0;
                          If twoway=true then zset;
                          c:=c+1
                          until (used[z]=false) and (x<>y) and (y<>z) and (x<>z)
                          and (timesused[z]<quizzes) and (qagainst[y,z]<rep)
                          and ((qagainst[x,z]<rep-1) or ((rmax[x]<>maxrepeat) and (rmax[z]<>maxrepeat)))
                          and ((qagainst[y,z]<rep-1) or ((rmax[y]<>maxrepeat) and (rmax[z]<>maxrepeat)))
                          and ((rmax[x]<>maxrepeat-1) or ((qagainst[x,z]<rep-1) or (qagainst[x,y]<rep-1)))
                          and ((rmax[y]<>maxrepeat-1) or ((qagainst[x,y]<rep-1) or (qagainst[y,z]<rep-1)))
                          and ((rmax[z]<>maxrepeat-1) or ((qagainst[x,z]<rep-1) or (qagainst[y,z]<rep-1)))
                          or (c>100) or (c3>100) or (c3>100)
                      else begin z:=0;
                           if (tway=true) or (twoway=true) then zset;
                           if (tway=true) and
                           ((timesused[x]+1<quizzes) or (timesused[y]+1<quizzes)) then goto 10;
                           end

                    else {if twoway=false then} c:=201;
                    end;


              rept:=false;
              If (checkrep=true)
              and (qagainst[x,y]<rep) and (qagainst[x,z]<rep) and (qagainst[y,z]<rep)
              then begin
                   For n:=1 to round-1 do begin
                      A:=Quiz[n,1,1]; b:=quiz[n,1,2]; c9:=quiz[n,1,3];
                      For e:=1 to 3 do begin
                      If a>b then begin d:=a; a:=b; b:=d; end;
                      If b>c9 then begin d:=b; b:=c9; c9:=d; end; end;
                      For e:=1 to 3 do begin
                      If x>y then begin d:=x; x:=y; y:=d; end;
                      If y>z then begin d:=y; y:=z; z:=d; end; end;
                      If (a=x) and (b=y) and (c9=z) then begin
                            rept:=true;
                          {  Gotoxy(20,20); Write('R: ',x,' ',y,' ',z);
                            readln; }
                            end; end; end;

              Until (qagainst[x,y]<rep) and (qagainst[x,z]<rep) and (qagainst[y,z]<rep)
                    and (rept=false) or (count=20) or (c>100) or (c2>100) or (c3>100);
              Used[x]:=true;
              Used[y]:=true;
              Used[z]:=true;
              quiz[round,room,1]:=x;
              quiz[round,room,2]:=y;
              quiz[round,room,3]:=z;
           Until (room=rooms) or (count=20) or (c>100); {Room Loop}

{           Gotoxy(1,15);
Writeln(' x: ',x,' y: ',y,' z: ',z,' room: ',room,' count: ',count,' c: ',c,' c2: ',c2,' c3: ',c3,'      ');
           readln;}
         


           If (count<20) and (C<=100) and (c2<100) and (c3<100) then begin
              ready:=true;
              For c1:= 1 to rooms do begin
                 if twoway=true then zset;
                 x:=quiz[round,c1,1]; y:=quiz[round,c1,2]; z:=quiz[round,c1,3];
                 qagainst[x,y]:=qagainst[x,y]+1; qagainst[x,z]:=qagainst[x,z]+1;
                 qagainst[y,z]:=qagainst[y,z]+1; qagainst[y,x]:=qagainst[y,x]+1;
                 qagainst[z,x]:=qagainst[z,x]+1; qagainst[z,y]:=qagainst[z,y]+1;
                 If qagainst[x,y]=rep then begin rmax[x]:=rmax[x]+1; rmax[y]:=rmax[y]+1; end;
                 If qagainst[y,z]=rep then begin rmax[y]:=rmax[y]+1; rmax[z]:=rmax[z]+1; end;
                 If qagainst[x,z]=rep then begin rmax[x]:=rmax[x]+1; rmax[z]:=rmax[z]+1; end;
                 Timesused[x]:=Timesused[x]+1; Timesused[y]:=timesused[y]+1; Timesused[z]:=timesused[z]+1;
                 If twoway=true then zset;
                 Round:=round+1;
                 Gotoxy(1,16);
{                 Writeln('round ',round);
                 readln;}

                  end; end else
                  begin
              {       Gotoxy(15,15);
                     Writeln(x,' ',y,' ',z);
                     readln;}
                  count2:=count2+1;
                              end;
        If (count2=countset) and (round=rounds) and (trep=1) then begin
              x:=0;
              Repeat x:=x+1 until timesused[x]<quizzes; y:=x;
              Repeat y:=y+1 until timesused[y]<quizzes; z:=y;
              Repeat z:=z+1 until timesused[z]<quizzes;
              if twoway=true then zset;
              stop:=false;
              if z>teams then stop:=true;
              If qagainst[y,z] = 0 then begin
                  t:=x; x:=z; z:=t; end;
              If qagainst[x,z] = 0 then begin
                  t:=y; y:=z; z:=t; end;
              If (qagainst[x,y] = 0) and (stop=false) then begin
                  Q:=(teams) div (3);
                  Repeat
                     q:=q+1;
                     a:=quiz[Q,1,1]; b:=quiz[Q,1,2]; c:=quiz[Q,1,3];
                     Until (((Qagainst[x,a]=0) and (Qagainst[y,a]=0) and (Qagainst[z,b]=0) and
                           (Qagainst[z,c]=0))
                        or ((Qagainst[x,b]=0) and (Qagainst[y,b]=0) and (Qagainst[z,a]=0) and
                           (Qagainst[z,c]=0))
                        or ((Qagainst[x,c]=0) and (Qagainst[y,c]=0) and (Qagainst[z,a]=0) and
                           (Qagainst[z,a]=0))) and ((a<>x) and (a<>y) and (a<>z) and (b<>x) and (b<>y) and (b<>z)
                           and (c<>x) and (c<>y) and (c<>z))
                        or ((q=rounds-1));
                     If (Qagainst[x,a]=0) and (Qagainst[y,a]=0) and (Qagainst[z,b]=0) and (Qagainst[z,c]=0)
                        then begin
{                             Writeln;
                             Writeln('Switch Procedure 1 used on quizzes ',q,' and ',rounds);}
                             Quiz[q,1,1]:=x; Quiz[q,1,2]:=y; Quiz[q,1,3]:=a;
                             Quiz[rounds,1,1]:=b; Quiz[rounds,1,2]:=c; Quiz[rounds,1,3]:=z;
                             count2:=0; round:=rounds+1; end else
                     If (Qagainst[x,b]=0) and (Qagainst[y,b]=0) and (Qagainst[z,a]=0) and (Qagainst[z,c]=0)
                        then begin
{                             Writeln;
                             Writeln('Switch Procedure 1 used on quizzes ',q,' and ',rounds);}
                             Quiz[q,1,1]:=x; Quiz[q,1,2]:=y; Quiz[q,1,3]:=b;
                             Quiz[rounds,1,1]:=a; Quiz[rounds,1,2]:=c; Quiz[rounds,1,3]:=z;
                             count2:=0; round:=rounds+1; end else
                     If (Qagainst[x,c]=0) and (Qagainst[y,c]=0) and (Qagainst[z,a]=0) and (Qagainst[z,b]=0)
                        then begin
     {                        Writeln;
                             Writeln('Switch Procedure 1 used on quizzes ',q,' and ',rounds);}
                             Quiz[q,1,1]:=x; Quiz[q,1,2]:=y; Quiz[q,1,3]:=c;
                             Quiz[rounds,1,1]:=a; Quiz[rounds,1,2]:=b; Quiz[rounds,1,3]:=z;
                             count2:=0; round:=rounds+1; end;
                     end;
                     end;

      {  If (rob3=false) then  }
      {  If twoway=false then  }
        If (count2=countset) then if ((tway=false) or (round<rounds-xtquiz))
        then begin
              ready:=false;
              Round:=round-1;
              c10:=0;
              Repeat R:=random(round-1);
               c10:=c10+1;
               if keypressed then if ord(readkey)=27 then goto 2;
               until (r>rm2) and (r>prounds) or (c10>3000);
              If c10>3000 then goto 18;
              a:=quiz[round,1,1]; b:=quiz[round,1,2]; c:=quiz[round,1,3];
              x:=quiz[r,1,1]; y:=quiz[r,1,2]; z:=quiz[r,1,3];
              d:=x; e:=y; f:=z;
              quiz[r,1,1]:=a; quiz[r,1,2]:=b; quiz[r,1,3]:=c;
              If qagainst[x,y]=rep then begin rmax[x]:=rmax[x]-1; rmax[y]:=rmax[y]-1; end;
              If qagainst[y,z]=rep then begin rmax[y]:=rmax[y]-1; rmax[z]:=rmax[z]-1; end;
              If qagainst[x,z]=rep then begin rmax[x]:=rmax[x]-1; rmax[z]:=rmax[z]-1; end;
              qagainst[x,y]:=qagainst[x,y]-1; qagainst[x,z]:=qagainst[x,z]-1;
              qagainst[y,z]:=qagainst[y,z]-1; qagainst[y,x]:=qagainst[y,x]-1;
              qagainst[z,x]:=qagainst[z,x]-1; qagainst[z,y]:=qagainst[z,y]-1;
              Timesused[x]:=Timesused[x]-1; Timesused[y]:=timesused[y]-1; Timesused[z]:=timesused[z]-1;
              it:=it+1;
              count2:=0;
              end

         Else begin

             ready:=false;
              Round:=trounds-1;

              Repeat R:=random(round-1);
               if keypressed then if ord(readkey)=27 then goto 2;
               until (r>rm2) and (r>prounds);
              a:=quiz[round,1,1]; b:=quiz[round,1,2]; c:=quiz[round,1,3];
              x:=quiz[r,1,1]; y:=quiz[r,1,2]; z:=quiz[r,1,3];
              d:=x; e:=y; f:=z;
              quiz[r,1,1]:=a; quiz[r,1,2]:=b; quiz[r,1,3]:=c;
              If qagainst[x,y]=rep then begin rmax[x]:=rmax[x]-1; rmax[y]:=rmax[y]-1; end;
              If qagainst[y,z]=rep then begin rmax[y]:=rmax[y]-1; rmax[z]:=rmax[z]-1; end;
              If qagainst[x,z]=rep then begin rmax[x]:=rmax[x]-1; rmax[z]:=rmax[z]-1; end;
              qagainst[x,y]:=qagainst[x,y]-1; qagainst[x,z]:=qagainst[x,z]-1;
              qagainst[y,z]:=qagainst[y,z]-1; qagainst[y,x]:=qagainst[y,x]-1;
              qagainst[z,x]:=qagainst[z,x]-1; qagainst[z,y]:=qagainst[z,y]-1;
              Timesused[x]:=Timesused[x]-1; Timesused[y]:=timesused[y]-1; Timesused[z]:=timesused[z]-1;
              it:=it+1;
              count2:=0;
              end;


{               Gotoxy(24,60);
              Writeln('Round: ',round,' Rounds: ',rounds);  readln;
}
        Until ((lineready=false) and (Round = rounds+1{+xtquiz})) {or (Count2 = 2)} {Round Loop}
        or ((split=true) and (round=x3w*teams/3+1) and (lineready=false))
        or (split=false) and (lineready=true) and (round=totquiz+1);

     back:=false;

     If (tway=true) and (xtquiz=1) then begin
           a:=quiz[rounds-1,1,1];
           b:=quiz[rounds-1,1,2];
           c:=quiz[rounds,1,1];
           d:=quiz[rounds,1,2];
           If (a=c) or (a=d) or (b=c) or (b=d) or (c9=0) then goto 10; end;

     If split=true then begin

{             gotoxy(29,60); write('****');   }
             prounds:=round+1;
             quizzes:=x2w;
             lineready:=true;
             for x:=1 to teams do timesused[x]:=0;
             splitdone:=true; twoway:=true;
             rounds:=totquiz; end;

     Until split=false;


  {   end;   }

  {   readln;  }

     Writeln;
     gotoxy(2,13);
     writeln('Placing Quizzes     >>  Iteration:        Quiz:     of ',totquiz);
   {  assign(f1,'temp.txt');}
     rewrite(f1);
     Writeln(F1,Teams,' Teams');
     Writeln(F1,x2quiz,' Quizzes');
     Writeln(F1,Rooms,' Rooms');
     Writeln(F1,Rounds, ' Rounds');
     Writeln(F1);
     For x:=1 to rounds do begin
     for y:= 1 to rooms do
        Write(f1,Quiz[x,y,1]:3,Quiz[x,y,2]:3,Quiz[x,y,3]:3,'  ');
     writeln(f1); end;
     close(f1);
     op1:=false;


{ Assign(f3,'tepm2.txt');
     rewrite(f3);
     Writeln(F3,Teams,' Teams');
     Writeln(F3,Quizzes,' Quizzes');
     Writeln(F3,Rooms,' Rooms');
     Writeln(F3,Rounds, ' Rounds');
     Writeln(F3);
     For x:=1 to rounds do begin
     for y:= 1 to rooms do
        Write(f3,Quiz[x,y,1]:3,Quiz[x,y,2]:3,Quiz[x,y,3]:3,'  ');
     writeln(f3); end;
    close(f3);  }


 {            readln;}



     {** Assign Rooms **}
22:
     If (split2=true) or (tway=true) then place2:=true else place2:=false;
     If place2=true then factor:=2 else factor:=30;
     tq:=rounds;
     placed:=false;
     tquiz:=rounds;
     rooms:=rm2;
     rounds:=rounds2;
     it:=0;
     it:=it+1;
     For x:=0 to tms do for y:=1 to 35 do for z:= 1 to 3 do quiz2[x,y,z]:=0;
     For x:=0 to tms do for y:=0 to tms do qa1[x,y]:=0;
     For x:=0 to Tms do used[x]:=false;
     For x:=0 to Tms do timesused[x]:=0;
     For x:=0 to Tms do used2[x]:=false;
     for x:=1 to rounds do rmax[x]:=0;
     For x:=1 to rounds do for y:=1 to rooms do
        if (two[x,y]=false) and (break[x,y]=false) then rmax[x]:=rmax[x]+1;

     Round:=1; Room:=0; qn:=0;
     c3:=0;
     rmtemp:=rooms;

     For x:=1 to rounds do for y:=1 to rm2 do used5[x]:=0;
     If (split2=true) or (tway=true) then begin
          For x:= 1 to rounds do for y:=1 to rooms do
          If two[x,y]=true then used5[x]:=used5[x]+1;
         end;


     For x:=1 to rounds do leastused[x]:=0;

     If rs='M' then rmtemp:=used4[1];
     Repeat {First row}
         QN:=QN+1;
         Room:=Room+1;
         Quiz2[Round,Room,1]:=Quiz[QN,1,1]; Quiz2[Round,Room,2]:=Quiz[QN,1,2]; Quiz2[Round,Room,3]:=Quiz[QN,1,3];
         a:=Quiz[QN,1,1]; b:=Quiz[QN,1,2]; c:=Quiz[QN,1,3];
         Used[qn]:=true;
         Timesused[a]:=timesused[a]+1; Timesused[b]:=timesused[b]+1; Timesused[c]:=timesused[c]+1;
         used2[a]:=true; used2[b]:=true; used2[c]:=true;
     Until Room=rmtemp; {first Row}

     For x:=rmtemp+1 to tq do for y:=1 to 3 do quiz[x-rmtemp,1,y]:=Quiz[x,1,y];
     Height:=tquiz-rmtemp;

     For x:=2 to rounds-1 do timesused[x]:=rooms;
     timesused[rounds]:=(tq)mod(rooms);
     if timesused[rounds]=0 then timesused[rounds]:=rooms;
     temp:=timesused[rounds];

     If rs='M' then for x:=1 to rounds do timesused[x]:=used4[x];

     It:=rooms;
     Repeat      {main loop}

         Done:=false;
         Gotoxy(37,13);
         write(it);
         Gotoxy(50,13);
         Write(tq-height);
         it:=it+1;
         c3:=c3+1;
         c1:=0;


         Repeat     {search loop}
            if keypressed then if ord(readkey)=27 then goto 2;
            c1:=c1+1;
            QN:=Random(Height)+1;
            repeat Rd:=Random(rounds-1)+2;
             if keypressed then if ord(readkey)=27 then goto 2;
             until timesused[rd]>0;
            a:=Quiz[Qn,1,1]; b:=Quiz[Qn,1,2]; c:=Quiz[Qn,1,3];
            if twoway=true then zset;
         Until (((QA1[rd,a]=0) and (QA1[rd,b]=0) and (QA1[rd,c]=0))
  {+}    and ((place2=false) or (c<>0) or (leastused[rd]<used5[rd])))
         and ((place2=false) or (c=0) or (rmax[rd]>0))
         or (c1>=50);

    {     If place2=true then begin
            done:=true;
            r:=timesused[rd];
            If (c=0) and (two[rd,r]=false) then done:=false;
            If (c<>0) and (two[rd,r]=true) then done:=false;
            if done=false then c1:=50; end;
     }
         If c1<50 then begin   {found loop}
            r:=timesused[rd];
            Quiz2[rd,r,1]:=a; Quiz2[rd,r,2]:=b; Quiz2[rd,r,3]:=c;
            Timesused[rd]:=timesused[rd]-1;
            if c<>0 then rmax[rd]:=rmax[rd]-1;
  {+}       If c=0 then Leastused[rd]:= leastused[rd]+1;
            QA1[rd,a]:=1; QA1[rd,b]:=1; QA1[rd,c]:=1;
            For y:=1 to 3 do Quiz[QN,1,y]:=Quiz[height,1,y];
            if twoway=true then zset;
            height:=height-1; end

         Else begin    {not found loop}
         c2:=0;

         y2:=10;
         If rounds<20 then y2:=7;
         If rounds<10 then y2:=3;
         If factor>10 then y2:=3;

      For x2:=1 to y2 do
         Begin
         If (c3) mod (x*factor) = 0 then begin
   {}     Repeat
            repeat Rd:=Random(rounds-1)+2 until (timesused[rd]<rooms)
               and ((Rd<>rounds) or (timesused[rounds]<temp));
            r:=timesused[rd]+1;
            Timesused[rd]:=timesused[rd]+1;
            D:=Quiz2[rd,r,1]; e:=Quiz2[rd,r,2]; f:=Quiz2[rd,r,3];
            If f<>0 then rmax[rd]:=rmax[rd]+1;
          until (twoway=true) or (f<>0);
   {  Until (place2=false) or ((f<>0) or (placed=false)) or ((twoway=true) or (roundrob=true));}
   {+}      If f=0 then leastused[rd]:=leastused[rd]-1;
            For z:=1 to 3 do Quiz2[rd,r,z]:=0;
            QA1[rd,d]:=0; QA1[rd,e]:=0; QA1[rd,f]:=0;
            Height:=height+1;
            Quiz[height,1,1]:=d; Quiz[height,1,2]:=e; Quiz[height,1,3]:=f;
            end;
         end;


         done:=false;

{        If (place2=false) then                       }

          Repeat
            c2:=c2+1;
            c8:=0;
            repeat Rd:=Random(rounds-1)+2;
             c8:=c8+1;
           {  If (c8>3000) and (place2=true) then goto 22; }
             if keypressed then if ord(readkey)=27 then goto 2;
             until (timesused[rd]<rooms)
               and ((Rd<>rounds) or (timesused[rounds]<temp));
            c8:=0;
{*}         repeat c8:=c8+1; r:=random(rooms)+1; until ((place2=true) and (Quiz2[rd,r,3]<>0))
                    or ((place2=false) and (Quiz2[rd,r,2]<>0))
                 or (c8>300);
            if c8<300 then begin
            D:=Quiz2[rd,r,1]; e:=Quiz2[rd,r,2]; f:=Quiz2[rd,r,3];
            twy:=false;
            If f=0 then twy:=true;
            QA1[rd,d]:=0; QA1[rd,e]:=0; QA1[rd,f]:=0;
            c8:=0;
            Repeat c8:=c8+1;
            QN:=Random(Height)+1; until (quiz[qn,1,3]=f) or (twy=false) or (c8>300);
            if c8>300 then goto 25;
            a:=Quiz[Qn,1,1]; b:=Quiz[Qn,1,2]; c:=Quiz[Qn,1,3];
            Done:=false;
            If (QA1[Rd,a]=0) and (QA1[Rd,b]=0) and (QA1[Rd,c]=0)
            and ((c=f) or ((c<>0) and (f<>0)))
             then done:=true;
            QA1[rd,d]:=1; QA1[rd,e]:=1; QA1[rd,f]:=1;
            If twoway=true then zset;
            end;
    25:   Until (c2>=500) or (c8>=300) or (Done=true);


{         Repeat
            c2:=c2+1;
            repeat Rd:=Random(rounds-1)+2;
             if keypressed then if ord(readkey)=27 then goto 2;
             until (timesused[rd]<rooms)
               and ((Rd<>rounds) or (timesused[rounds]<temp));
            c8:=0;
         repeat c8:=c8+1; r:=random(rooms)+1; until (Quiz2[rd,r,2]<>0)
                 or (c8>300);
            if c8<300 then begin
            D:=Quiz2[rd,r,1]; e:=Quiz2[rd,r,2]; f:=Quiz2[rd,r,3];
            QA1[rd,d]:=0; QA1[rd,e]:=0; QA1[rd,f]:=0;
            QN:=Random(Height)+1;
            a:=Quiz[Qn,1,1]; b:=Quiz[Qn,1,2]; c:=Quiz[Qn,1,3];
            Done:=false;
            If (QA1[Rd,a]=0) and (QA1[Rd,b]=0) and (QA1[Rd,c]=0) then done:=true;
            QA1[rd,d]:=1; QA1[rd,e]:=1; QA1[rd,f]:=1;
            If twoway=true then zset;
            end;
         Until (c2>=500) or (c8>=300) or (Done=true);
}
         If done=true then begin
            QA1[rd,d]:=0; QA1[rd,e]:=0; QA1[rd,f]:=0;
            Quiz[Qn,1,1]:=d; Quiz[Qn,1,2]:=e; Quiz[Qn,1,3]:=f;
            Quiz2[rd,r,1]:=a; Quiz2[rd,r,2]:=b; Quiz2[rd,r,3]:=c;
            QA1[rd,a]:=1; QA1[rd,b]:=1; QA1[rd,c]:=1; end;


         end;   {not found loop}

   {   If (c3>=200) and (twoway=false) then switch}



     Until height=0;    {main loop}

     Gotoxy(50,13); write(totquiz);

{     readln;}

     end;


{         Gotoxy(1,12);
         Write('**********');
         For x:=1 to rounds do begin
         clreol;
         writeln(used5[x],' ',leastused[x]); end; readln;

}



     {-------------------}


     Rewrite(f1);     {Both R + C Procedures};
     If rs='M' then Begin
        For x:= 1 to rounds do
        For y:= 1 to rooms do begin
           x10:=0;
           If (Break[x,y]=true) and (quiz2[x,y,1]<>0) then begin
           Repeat z:=Random(rooms+1);
            x10:=x10+1;
            If x10>3000 then begin close(f1); goto 18;  end;
            if keypressed then if ord(readkey)=27 then
              begin; goto 18; close(f1); end;
           until (z>0) and (z<>y) and (Break[x,z]<>true) and (quiz2[x,z,1]=0);
           For a:=1 to 3 do quiz2[x,z,a]:=quiz2[x,y,a];
           For a:=1 to 3 do quiz2[x,y,a]:=0; end; end; end;

     Writeln(F1,Teams:2,' Teams');
     Writeln(F1,x2quiz:2,' Quizzes');
     Writeln(F1,Rooms:2,' Rooms');
     Writeln(F1,Rounds:2, ' Rounds');
     Writeln(F1);

     Gotoxy(1,20);
     Order;  if back=true then goto 2;
    Files;

  Printresults;
  tbb;
  textbackground(green);
  tcw;
  Gotoxy(2,17);
  Write('Bracket Completed and saved as ',fn);
  tbb;
  tcy;
 { assign(f1,fn);

  op1:=true;      }

  o:=1; ready2:=true; goto 9;
6: ready2:=false;
9:  For x:=18 to 24 do begin gotoxy(1,x); clreol; end;
  I:='a';

  view1;

  If o=0 then begin recll;  if found=false then goto 1;
           searchfollow;   goto 9; end;

  If o=5 then goto 1;
  If o=4 then begin
  For x:=5 to 24 do begin gotoxy(1,x); clreol; end;

     pb(fn);

  For x:=5 to 24 do begin gotoxy(1,x); clreol; end;

      view1; end;

  For x:=5 to 24 do begin gotoxy(1,x); clreol; end;
  If o=1 then begin

  view2;

       goto 6;   end;

     If (o=2) then begin
     Reset(f1);
     op1:=true;
     For x:=1 to 10+rounds do readln(f1);
     If teams<37 then v37(teams,rounds,rooms,fn)

     Else If teams<73 then v73(teams,rounds,rooms,fn)

     else begin
             tbr;
             tcw;
             Gotoxy(19,7);
             Write('Sorry, cannot display more than 72 teams');
             tbb;
              tcy;
              readln;
                          end;

       goto 6;

       end;
      If (o=3)  then if rooms<22 then roomdisplay(teams,rounds,rooms,fn)
         else begin
             tbr;
             tcw;
             Gotoxy(19,7);
             Write('Sorry, cannot display more than 21 rooms');
             tbb; tcy;readln;
                          end;

       goto 6;
      ;
       goto 6;

   5:
     textBackground(black);
     tcw;
     clrscr;

     end.

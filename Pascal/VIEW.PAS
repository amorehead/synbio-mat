Unit view;

Interface

Uses crt,printer;

var
 way,
 T,r,n,lines,rooms,rounds,spc,x,y,z,xt:integer;
    f1,f2:text;
    info:string[255];
    I72:string[72];
    I: Char;
    tp:boolean;

Procedure pb(fn:string);
Procedure view6(teams,rounds,rooms:integer;fn:string);
Procedure view7(teams,rounds,rooms:integer;fn:string);
Procedure view8(teams,rounds,rooms:integer;fn:string);
Procedure view9(teams,rounds,rooms:integer;fn:string);
Procedure view10(teams,rounds,rooms:integer;fn:string);
Procedure roomdisplay(teams,rounds,rooms:integer;fn:string);
Procedure v37(teams,rounds,rooms:integer;fn:string);
Procedure v73(teams,rounds,rooms:integer;fn:string);
Procedure lastscr;


Implementation



Procedure pb(fn:string);


Begin

{Write(' Do you wish to include pairing, room and seating info? ');
Repeat I:=readkey; until (I='y') or (i='Y') or (I='n') or (I='N');

Writeln(I);}
Gotoxy(2,6);
Write('Be sure printer is ready and press return');
Readln;

Assign(f2,fn);
Reset(f2);
Readln(f2);
Readln(f2);
Readln(f2,rooms);
Readln(f2,rounds);
Reset(f2);

Writeln(lst);
Writeln(lst);
For x:= 1 to 5 do begin
    For y:=1 to 250 do info[y]:=' ';
    Readln(f2,info);
    Writeln(lst,info); end;
    writeln(lst);
Readln(f2,info);

tp:=false;

if (info[12]=' ') and (info[24]=' ') then tp:=true;

lines:=8;

t:=(rooms)div(6)+1;
If (rooms)mod(6)=0 then t:=t-1;

For x:=1 to T do begin
    If x < T then r:=6 else r:=(rooms) mod (6);
    If r=0 then r:=6;
    If tp=false then write(lst,'  ');
    If (r<10) then write(lst,' ');
    Write(lst,'  ');
    If (tp=true) or (x<3) then write(lst,' ');
    For y:=1 to r do begin
        If (tp=false) or (y<>2) or (y+6*(x-1)<10) then write(lst,' ');
        Write(lst,'Room ',y+6*(x-1),'    ');
        If y+6*(x-1)+1<10 then Write(lst,' '); end;
    Writeln(lst);
    Write(lst,'     ');
    For y:= 1 to r*12-6 do write(lst,'-');
    If tp=false then write(lst,'--');
    writeln(lst);
    Reset(f2);
    For y:=1 to 5 do readln(f2);
    For y:=1 to rounds do begin
        For n:= 1 to (x-1) do read(f2,i72);
        Readln(f2,I72);
        Writeln(lst,' ',i72); end;
    Write(lst,'     ');
    For y:= 1 to r*12-6 do write(lst,'-');
    If tp=false then write(lst,'--');
    Writeln(lst); writeln(lst); writeln(lst);
    Lines:=lines+rounds+5;
    end;

{
If (I='Y') or (I='y') then begin

    Readln(f2);
    Repeat
       Readln(f2,info);
       Writeln(lst,info);
       lines:=lines+1;
       until eof(f2);   end;
}
close(f2);

Repeat

     Lines:=lines+1;
     Writeln(lst);
     until (lines) mod (66) = 0;


end;




      Procedure w(fn:string); begin
        assign(f1,fn);
        Reset(f1);
        For x:=1 to 24 do info[x]:=' ';
        For x:=1 to 6 do readln(f1,info);
        If (info[12]=' ') and (info[24]=' ') then way:=2 else way:=3;
        close(f1); end;


     Procedure view6; begin;
        w(fn);
        assign(f1,fn);
        Reset(f1);
        For x:=1 to 5 do readln(f1,info);

        spc:=(78-12*rooms+6) div (2);
        If way=3 then write('  ');
        For x:=1 to spc-2 do write(' ');
        For x:= 1 to rooms do write (' Room ',x,'     ');
        y:=0;
        t:=0;
        repeat
            y:=y+1;
            Gotoxy(spc-3,y+6); write(y+17*t:2,' ');
            textbackground(green);
            textcolor(white);
            readln(f1,info);
            for z:=5 to rooms*12 do write(info[z]);
            textbackground(blue);
            textcolor(yellow);
            if (y=17) and (y+17*t<rounds) then begin t:=t+1; y:=0;
                readln;
                For x:=5 to 24 do begin gotoxy(1,x); clreol; end;
                Gotoxy(1,6);
                If way=3 then write('  ');
                For x:=1 to spc-2 do write(' ');
                For x:= 1 to rooms do write (' Room ',x,'     ');
                end;
        until y+17*t=rounds;
        close(f1); readln; end;

  Procedure view7;
       begin
        w(fn);
        assign(f1,fn);
        Reset(f1);
        For x:=1 to 5 do readln(f1,info);
        Gotoxy(2,6);
        If way=3 then write('  ');
        Write('    ');
        For x:= 1 to rooms do write (' Room ',x,'   ');
        y:=0;
        t:=0;
        repeat
            y:=y+1;
            textbackground(blue);
            Gotoxy(3,y+6); write(y+17*t:2,' ');
            readln(f1,info);
            For x:= 1 to 7 do begin;
            If x/2=(x)div(2) then textbackground(red) else textbackground(green);
            textcolor(white);
            for z:= 4+12*(x-1) to 4+12*(x-1)+9 do write(info[z]); end;
            textbackground(blue);
            textcolor(yellow);
            if (y=17) and (y+17*t<rounds) then begin t:=t+1; y:=0;
                Readln;
                For x:=5 to 24 do begin gotoxy(1,x); clreol; end;
                Gotoxy(2,6);
                If way=3 then write('  ');
                Write('    ');
                For x:= 1 to rooms do write (' Room ',x,'   ');
                end;
        until y+17*t=rounds;
        close(f1);
        readln; end;

     procedure view8; begin
        w(fn);
        Gotoxy(2,6);
        If way=3 then write('  ');
        Write('   ');
        assign(f1,fn);
        Reset(f1);
        For x:=1 to 5 do readln(f1,info);
        For x:= 1 to rooms do write (' Room ',x,'  ');
        y:=0;
        t:=0;
        repeat
            y:=y+1;
            textbackground(blue);
            Gotoxy(2,y+6); write(y+17*t:2,' ');
            readln(f1,info);
            For x:= 1 to 8 do begin;
            If x/2=(x)div(2) then textbackground(red) else textbackground(green);
            textcolor(white);
            for z:= 4+12*(x-1) to 4+12*(x-1)+8 do write(info[z]); end;
            textbackground(blue);
            textcolor(yellow);
            if (y=17) and (y+17*t<rounds) then begin t:=t+1; y:=0;
                readln;
                For x:=5 to 24 do begin gotoxy(1,x); clreol; end;
                Gotoxy(2,6);
                If way=3 then write('  ');
                Write('    ');
                For x:= 1 to rooms do write (' Room ',x,'  ');
                end;
        until y+17*t=rounds;
        close(f1);
        readln; end;

        procedure view9; begin
        w(fn);
        assign(f1,fn);
        Reset(f1);
        For x:=1 to 5 do readln(f1,info);
        Gotoxy(2,6);
        If way=3 then write('  ');
        Write('  ');
        For x:= 1 to rooms do write (' Room ',x,' ');
        y:=0;
        t:=0;
        repeat
            y:=y+1;
            textbackground(blue);
            Gotoxy(2,y+6); write(y+17*t:2,' ');
            readln(f1,info);
            For x:= 1 to 9 do begin;
            If x/2=(x)div(2) then textbackground(red) else textbackground(green);
            textcolor(white);
          {  If x/2=(x)div(2) then textcolor(yellow) else textcolor(white);}
            for z:= 5+12*(x-1) to 5+12*(x-1)+7 do write(info[z]); end;
            textbackground(blue);
            textcolor(yellow);
            if (y=17) and (y+17*t<rounds) then begin t:=t+1; y:=0;
                readln;
                For x:=5 to 24 do begin gotoxy(1,x); clreol; end;
                Gotoxy(2,6);
                If way=3 then write('  ');
                Write('   ');
                For x:= 1 to rooms do write (' Room ',x,' ');
                end;
        until y+17*t=rounds;
        close(f1);
        readln; end;

        procedure view10; begin
        assign(f1,fn);
        Reset(f1);
        For x:=1 to 5 do readln(f1,info);
        Gotoxy(2,6);
        spc:=(78-6*rooms+2)div(2);
        For x:=1 to spc-3 do write(' ');
        For x:= 1 to rooms do begin
        if x<11 then write(' '); write (' Rm ',x);  end;
        y:=0;
        t:=0;
        repeat
            y:=y+1;
            textbackground(blue);
            Gotoxy(spc+1,y+6);
            readln(f1,info);
            For x:= 1 to rooms do begin
              If x/2=(x)div(2) then textbackground(green) else textbackground(red);
            {  If x/2=(x)div(2) then textcolor(yellow) else} textcolor(white);
              z:= 5+12*(x-1);
              Write(info[z],info[z+1]);
            {  If x/2=(x)div(2) then textcolor(yellow) else} textcolor(yellow);
              write(info[z+3],info[z+4]);
             { If x/2=(x)div(2) then textcolor(yellow) else} textcolor(white);
              write(info[z+6],info[z+7]);
              end;
            textbackground(blue);
            if (y=17) and (y+17*t<rounds) then begin t:=t+1; y:=0;
                readln;
                For x:=5 to 24 do begin gotoxy(1,x); clreol; end;
                gotoxy(2,6);
                For x:=1 to spc-1 do write(' ');
                For x:= 1 to rooms do begin
                if x<11 then write(' '); write (' Rm ',x);  end;
                end;
        until y+17*t=rounds;
        close(f1);
        readln; end;


     procedure roomdisplay;
     begin
        assign(f1,fn);
        Reset(f1);
        For x:=1 to 10+rounds do readln(f1,info);
        For x:=5 to 24 do begin gotoxy(1,x); clreol; end;
        reset(f1);
 {       if teams<19 then for x:= 1 to 10+rounds do readln(f1)
           else} for x:=1 to 10+rounds+teams+8 do readln(f1);
        spc:=(64-(3)*rooms) div (2);
        Gotoxy(spc+2,6);
        Write('  Rooms');For x:=1 to rooms*3-2 do write(' ');writeln('  Seating');
        Gotoxy(spc+3,7);
        For x:=1 to rooms do begin
        write(x:3);
        textcolor(yellow); end;
        Write('      ','1  2  3');
        y:=0;
        t:=0;
        repeat
            y:=y+1;
            Gotoxy(spc+1,y+7); write(y+16*t:2,' ');
            textbackground(cyan);textcolor(white);
            for x:=1 to 5 do read(f1,I);
{            If teams<19 then read(f1,I);
            If teams<19 then for x:=1 to teams*3 do read(f1,I);}
            readln(f1,info);
            z:=-2;
            For x:=1 to rooms do begin
                z:=z+3;
                write(info[z],info[z+1],info[z+2]);
            {    if teams<19 then z:=z-1;}
                end;
                write('   ');
              {  z:=z+1; }
            For x:=1 to 3 do begin
                z:=z+3;
                Write(info[z+1],info[z+2],info[z+3]);
            {    if teams<19 then z:=z-1;   }
                end;
            textcolor(yellow);
            textbackground(blue);
            if (y=16) and (y+16*t<teams) then begin t:=t+1; y:=0;
                readln;
                For x:=5 to 24 do begin gotoxy(1,x); clreol; end;
                Gotoxy(spc+2,6);
                Write('  Rooms');For x:=1 to rooms*3-1 do write(' ');writeln(' Seating');
                Gotoxy(spc+3,7);
                For x:=1 to rooms do begin
                write(x:3);
                textcolor(yellow); end;
                Write('      ','1  2  3');
                end;
        until y+16*t=teams;
        close(f1); readln; end;

     procedure v37;
     begin

        assign(f1,fn);
        Reset(f1);
        For x:=1 to 10+rounds do readln(f1,info);
        xt:=0;
        If teams<24 then xt:=1;
        spc:=(72-(2+xt)*teams) div (2);
        Gotoxy(spc+4,6);
        if xt=0 then WRITE(' ');
        For x:=1 to teams do begin
          If (xt=0) and (x/2=(x)div(2)) then textcolor(white);
        write(x:2+xt);
        textcolor(yellow); end;
        y:=0;
        t:=0;

        repeat
            y:=y+1;
            Gotoxy(spc+3,y+6); write(y+17*t:2,' ');
            textbackground(magenta);
            textcolor(white);
            readln(f1,info);
            For x:=1 to teams do begin
                z:=3 + x*3;
              write(info[z]);
              If x<>teams then write(info[z+1]);
              if (x<>teams) and (xt=1) then write (info[z+2]); end;
            textcolor(yellow);
            textbackground(blue);
            if (y=17) and (y+17*t<teams) then begin t:=t+1; y:=0;
                readln;
                For x:=5 to 24 do begin gotoxy(1,x); clreol; end;
                Gotoxy(spc+4,6);
                if xt=0 then WRITE(' ');
                For x:=1 to teams do begin
                If (xt=0) and (x/2=(x)div(2)) then textcolor(white);
                write(x:2+xt);
                textcolor(yellow); end;
                end;
        until y+17*t=teams;
        close(f1); readln; end;




  Procedure v73;
     begin
        assign(f1,fn);
        Reset(f1);
        For x:=1 to 10+rounds do readln(f1,info);
        spc:=(72-teams) div (2);
        Gotoxy(spc+6,6);
        For x:=1 to teams do begin
          If (x/10=(x)div(10)) then begin textcolor(lightred);
          write((x)div(10)); end
          else write((x)mod(10));
          textcolor(yellow); end;
        y:=0;
        t:=0;
        repeat
            y:=y+1;
            Gotoxy(spc+3,y+6); write(y+17*t:2,' ');
            textbackground(magenta);
            textcolor(white);
            readln(f1,info);
            For x:=1 to teams do begin
                if x/10 = (x)div(10) then textbackground(black);
                z:=3 + x*3;
              write(info[z]); textbackground(magenta); end;
            textcolor(yellow);
            textbackground(blue);
            if (y=17) and (y+17*t<teams) then begin t:=t+1; y:=0;
                readln;
                For x:=5 to 24 do begin gotoxy(1,x); clreol; end;
                Gotoxy(spc+6,6);
                For x:=1 to teams do begin
                  If (x/10=(x)div(10)) then begin textcolor(lightred);
                  write((x)div(10)); end
                  else write((x)mod(10));
                  textcolor(yellow); end;

                  end;
        until y+17*t=teams;
        close(f1); readln; end;


   Procedure lastscr; begin
   For x:=5 to 24 do begin gotoxy(1,x); clreol; end;
     textbackground (black);
     textcolor(white);
     Gotoxy(8,7);
     Write('Thank you for using Bracketmaker 1.0                             ');
     Gotoxy(8,8);
     Write('                                                                 ');
     Gotoxy(8,9);
     Write('Your files have been saved as ASCII Text Files.                  ');
     Gotoxy(8,10);
     Write('They can be accessed using any word processor.                   ');
     Gotoxy(8,11);
     Write('                                                                 ');
     Gotoxy(8,12);
     Write('The following features will soon be added:                       ');
     Gotoxy(8,13);
     Write('                                                                 ');
     Gotoxy(8,14);
     Write('1. Ability to call up previous files                             ');
     Gotoxy(8,15);
     Write('2. Integration of numbered brackets with a list of team names    ');
     Gotoxy(8,16);
     Write('3. Formatting options for output files                           ');
     Gotoxy(8,17);
     Write('4. Options for including 2-way quizzes                           ');
     Gotoxy(8,18);
     Write('5. Options for quizzing teams more than once                     ');
     Gotoxy(8,19);
     Write('6. Switching so teams are in fewest possible consecutive quizzes ');
     end;
 end.
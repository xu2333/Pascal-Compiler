program test_1;
const outer_const=3;
type xxx=record
			x, y:integer;
		 end;
	 yyy=array[1..3] of integer;
	 zzz=xxx;
var a:zzz;b:yyy;
procedure abcde(var x:xxx;var y:yyy);
const inner_const=5;
var i:integer;
begin
  writeln(x.x, x.y);
  x.x:=3;
  x.y:=4;
  i:=0;
  if (i = 0) then i:=1;
  while (i <= 3) do
  begin
    y[i]:=i;
    writeln(y[i]);
    i:=i+1;
  end;
  repeat
    y[i-1]:=i;
    writeln(y[i-1]);
    i:=i-1;
  until (i = 1);
  for i:=-1 to 1 do begin
    if (i = -1) then writeln(-1);
    y[i+2]:=i;
    writeln(y[i+2]);
  end;
  for i:=3 downto 1 do begin
    writeln(y[i]);
  end;
  case i of
    outer_const:writeln(1);
    inner_const:writeln(2);
    1:writeln(3);
    0:writeln(inner_const,outer_const);
    2:writeln(4);
  end;
end;
begin
  a.x:=1;
  a.y:=2;
  abcde(a, b);
  writeln(a.x, a.y);
  goto 123;
  writeln(7);
123:
  b[2]:=abs(b[2]-2);
  writeln(b[2]);
end.

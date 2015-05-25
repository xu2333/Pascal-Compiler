program test_1;
var c,d:integer;
procedure test_multi(a,b:integer;var c,d:integer);
begin
  writeln(a,b,c,d);
  a:=5;
  b:=6;
  c:=3;
  d:=4;
  writeln(a,b,c,d);
end;
begin
  c:=1;
  d:=2;
  writeln(c,d);
  test_multi(c,d,c,d);
  writeln(c,d);
end.

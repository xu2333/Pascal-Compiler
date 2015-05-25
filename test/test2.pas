program test_1;
var n:integer;
procedure fib(var x:integer);
var y,z:integer;
begin
  if ((x = 0) or (x = 1)) then
    x:=1
  else
  begin
    y := x - 2;
    fib(y);
    z := x - 1;
    fib(z);
    x := y + z;
  end;
end;
begin
  n:=read;
  fib(n);
  write(n);
end.

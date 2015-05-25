program test_1;
var x, z:integer;
procedure scope1;
var x, y:integer;

	procedure scope2;
	var x:integer;
	begin
	  x:=567;
	  y:=678;
	  z:=789;
	  writeln(x, y, z);
	end;

begin
  x:=345;
  y:=456;
  writeln(x, y);
  scope2;
  writeln(x, y);
end;

begin
  x:=123;
  z:=234;
  writeln(x, z);
  scope1;
  writeln(x, z);
end.

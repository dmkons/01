library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package test_utils is

    function to_string(sv: signed) return string;
    function to_string(sv: unsigned) return string;
    procedure test(tag : string; name : string; expected : signed; var : signed);
    procedure test(tag : string; name : string; expected : std_logic; var : std_logic);
    procedure test(tag : string; name : string; expected : std_logic_vector; var : std_logic_vector);
   
end;

package body test_utils is

 function to_string(sv: signed) return string is
    use Std.TextIO.all;
    variable bv: bit_vector(sv'range) := 
        to_bitvector(std_logic_vector(sv));
    variable lp: line;
  begin
    write(lp, bv);
    return lp.all;
  end;
  
   function to_string(sv: unsigned) return string is
    use Std.TextIO.all;
    variable bv: bit_vector(sv'range) := 
        to_bitvector(std_logic_vector(sv));
    variable lp: line;
  begin
    write(lp, bv);
    return lp.all;
  end;
 
 procedure test(tag :string; name :string; var :signed; expected :signed) is
 begin
    assert var = expected report "[" & tag & "]" & " " & name & " | expected: " & to_string(expected) & ", but was " & to_string(var);
 end;
 
 procedure test(tag :string; name :string; var :std_logic; expected :std_logic) is
 begin
    assert var = expected report "[" & tag & "]" & " " & name & " | expected: " & std_logic'image(expected) & ", but was " & std_logic'image(var);
 end;
 
  procedure test(tag :string; name :string; var :std_logic_vector; expected :std_logic_vector) is
 begin
	 test(tag, name, signed(var), signed(expected));
 end;
end;

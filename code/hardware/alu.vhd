library ieee;
use ieee.std_logic_164.all;
use ieee.numeric_std.all;

entity alu is
port ( 
    signal clk   : in  std_logic;
    signal a     : in  std_logic_vector(31 downto 0);
    signal b     : in  std_logic_vector(31 downto 0);
    signal y     : in  std_logic_vector(31 downto 0);
    signal op    : in  std_logic_vector(3  downto 0);
    signal nul   : out boolean;
    signal cout  : out std_logic
)
end entity;

architecture behavioral of alu is
begin

   process(op)
   begin
      case op is
      when "000" => enum_op <= op_and;
      when "001" => enum_op <= op_xor;
      when "010" => enum_op <= op_add;
      when "100" => enum_op <= op_a_and_nb;
      when "101" => enum_op <= op_a_xor_nb;
      when "110" => enum_op <= op_sub;
      when "111" => enum_op <= op_compare;
      when others => enum_op <= op_nop;
      end case;
   end process;

   process(clk)
   begin
      if rising_edge(clk) then
      
         case enum_op is
         when op_add       => reg <= a_plus_b;
         when op_sub       => reg <= a_minus_b;
         when op_and       => reg <= '0' & (a and b);
         when op_xor       => reg <= '0' & (a xor b);
         when op_a_and_nb  => reg <= '0' & (a and not b);
         when op_a_xor_nb  => reg <= '0' & (a xor not b);
         when op_compare   => 
            reg(32) <= '0';
            reg(31 downto 1) <= (others => '0'); 
            reg(0)  <= a_minus_b(32);
         when op_nop       =>
            reg(32) <= '0';
      end if;
   end process;

   y <= reg(31 downto 0);
   count <= reg(32);
   nul <= unsigned(reg) = '0';

end architecture;
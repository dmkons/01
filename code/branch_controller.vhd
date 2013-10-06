library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.mips_constant_pkg.all;

entity branch_controller is
    Port ( flags : in  alu_flags;
           opcode_in : in  STD_LOGIC_VECTOR (5 downto 0);
		   rt_in : in  STD_LOGIC_VECTOR (5 downto 0);
           branch : out  STD_LOGIC);
end branch_controller;

architecture Behavioral of branch_controller is

begin

process(flags, opcode_in)
	begin
		case op_code_in is
			when OPCODE_BEQ
				branch <= flags.zero;
			when OPCODE_BGEZ
			when OPCODE_BGTZ
			when OPCODE_BLEZ
			when OPCODE_BNE
			when others =>
				branch <= '0';
		end case;
   end process;
end Behavioral;


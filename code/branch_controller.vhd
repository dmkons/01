library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.mips_constant_pkg.all;

entity branch_controller is
    Port ( flags : in  alu_flags;
           instruction_opcode : in  STD_LOGIC_VECTOR (5 downto 0);
		   compare_zero_value : out STD_LOGIC_VECTOR (31 downto 0);
		   compare_zero : out STD_LOGIC;
           branch : out  STD_LOGIC
		   );
end branch_controller;

architecture Behavioral of branch_controller is

begin

process(flags, instruction_opcode)
	begin
	
		branch <= '0';
		compare_zero <= '0';
		write_return <= '0';
		compare_zero_value <= "00000000000000000000000000000000";
	
		case instruction_opcode_in is
			when OPCODE_BEQ
				branch <= flags.zero;
			when OPCODE_BGEZ
				branch <= not flags.negative;
				compare_zero <= '1';
			when OPCODE_BGTZ
				branch <= not flags.negative;
				compare_zero <= '1';
				compare_zero_value <= "00000000000000000000000000000001";
			when OPCODE_BLEZ
				branch <= flags.negative;
				compare_zero <= '1';
				compare_zero_value <= "11111111111111111111111111111111";
			when OPCODE_BNE
				branch <= not flags.zero;
			when others =>
				null;
				
		end case;
   end process;
end Behavioral;


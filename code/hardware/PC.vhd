library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC is
    generic (N :NATURAL);
    Port ( CLK	: in  STD_LOGIC;
			  pc_in : in  STD_LOGIC_VECTOR (N-1 downto 0);
           pc_out : out  STD_LOGIC_VECTOR (N-1 downto 0));
end PC;

architecture Behavioral of PC is

begin

	PC_PROC: process(CLK, pc_in)
	begin	
		if rising_edge (CLK) then
			pc_out <= pc_in;
		end if;
	end process PC_PROC;

end Behavioral;


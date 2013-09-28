library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC is
    generic (N :NATURAL);
    Port ( CLK	: in  STD_LOGIC;
			  PC_IN : in  STD_LOGIC_VECTOR (N-1 downto 0);
           PC_OUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
end PC;

architecture Behavioral of PC is

begin

	PC_PROC: process(CLK, PC_IN)
	begin	
		if rising_edge (CLK) then
			PC_OUT <= PC_IN;
		end if;
	end process PC_PROC;

end Behavioral;


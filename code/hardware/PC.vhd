library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC is
    generic (N :NATURAL);
    Port ( CLK	: in  STD_LOGIC;
			  PC_IN : in  STD_LOGIC_VECTOR (N-1 downto 0);
              reset : in std_logic;
              pc_enable : in std_logic;
           PC_OUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
end PC;

architecture Behavioral of PC is

begin

	PC_PROC: process(CLK, pc_enable)
	begin	
		if rising_edge (CLK) then
            if reset = '1' then
                pc_out <= (others => '0');
            else
                if pc_enable = '1' then
                    PC_OUT <= PC_IN;
                end if;
            end if;
		end if;
	end process PC_PROC;

end Behavioral;


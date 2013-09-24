library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX is
    generic (N :NATURAL;);
    Port (  CLK : in  STD_LOGIC;
            MUX_ENABLE : in STD_LOGIC;
            MUX_IN_0 : in  STD_LOGIC_VECTOR (0 downto N-1);
            MUX_IN_1 : in  STD_LOGIC_VECTOR (0 downto N-1);
            MUX_OUT : out  STD_LOGIC_VECTOR (0 downto N-1));
end MUX;

architecture Behavioral of MUX is

begin


    MUX_PROC: process(CLK, MUX_ENABLE, MUX_IN, MUX_OUT)
    begin	
        if rising_edge (CLK) THEN
            if (MUX_ENABLE='0') THEN
                MUX_OUT <= MUX_IN_0;
            ELSE
                MUX_OUT <= MUX_IN_1;
		end if;
	end process PC_PROC;

end Behavioral;


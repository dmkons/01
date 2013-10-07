library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX is
    generic (N :NATURAL);
    Port (  MUX_ENABLE : in STD_LOGIC;
            MUX_IN_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            MUX_IN_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            MUX_OUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
end MUX;

architecture Behavioral of MUX is

begin


    MUX_PROC: process(MUX_ENABLE, MUX_IN_0, MUX_IN_1)
    begin
        if (MUX_ENABLE='0') THEN
            MUX_OUT <= MUX_IN_0;
        ELSE
            MUX_OUT <= MUX_IN_1;
        end if;
    end process; -- MUX_PROC

end; -- Behavioral


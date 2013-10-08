library ieee;
use ieee.std_logic_1164.all;

entity mux is
    generic (n :natural);
    Port (  mux_enable : in std_logic;
            mux_in_0 : in  std_logic_vector (n-1 downto 0);
            mux_in_1 : in  std_logic_vector (n-1 downto 0);
            mux_out : out  std_logic_vector (n-1 downto 0));
end mux;

architecture Behavioral of mux is

begin


    mux_proc: process(mux_enable, mux_in_0, mux_in_1)
    begin
        if (mux_enable='0') then
            mux_out <= mux_in_0;
        else
            mux_out <= mux_in_1;
        end if;
    end process; -- MUX_PROC

end; -- Behavioral


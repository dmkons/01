LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.mips_constant_pkg.all;
use work.opcodes.all;
use work.test_utils.all;

entity pc is
    generic (N :NATURAL);
    Port ( clk	: in  std_logic;
           pc_in : in  std_logic_VECTOR (N-1 downto 0);
           reset : in std_logic;
           pc_enable : in std_logic;
           pc_out : out  std_logic_VECTOR (N-1 downto 0));
end pc;

architecture Behavioral of pc is

begin

    pc_proc: process(clk, pc_enable)
    begin	
        if rising_edge (clk) then
            if reset = '1' then
                pc_out <= (others => '0');
            else
                if pc_enable = '1' then
                    pc_out <= pc_in;
                end if;
            end if;
        end if;
    end process pc_proc;

end Behavioral;


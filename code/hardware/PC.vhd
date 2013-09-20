----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:04:21 09/18/2013 
-- Design Name: 
-- Module Name:    PC - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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


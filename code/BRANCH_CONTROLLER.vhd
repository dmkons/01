----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:26:15 10/06/2013 
-- Design Name: 
-- Module Name:    BRANCH_CONTROLLER - Behavioral 
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

entity BRANCH_CONTROLLER is
    Port ( BRANCH_ENABLE : in  STD_LOGIC;
           BRANCH_FLAG : in  STD_LOGIC;
           BRANCH_CONTROLLER_OUT : out  STD_LOGIC;
           CLK : in  STD_LOGIC);
end BRANCH_CONTROLLER;

architecture Behavioral of BRANCH_CONTROLLER is

begin

	BRANCH_CONTROLLER_PROC: process(CLK, BRANCH_ENABLE, BRANCH_FLAG)
	begin
		if(rising_edge(CLK)) then
			BRANCH_CONTROLLER_OUT <= BRANCH_ENABLE and BRANCH_FLAG;
		end if;
	end process BRANCH_CONTROLLER_PROC;
end Behavioral;
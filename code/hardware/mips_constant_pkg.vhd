library IEEE;
use IEEE.STD_LOGIC_1164.all;

package MIPS_CONSTANT_PKG is

	
    constant WORD_SIZE : integer := 32;
    constant OPCODE_SIZE : integer := 6;
    constant FUNCTION_SIZE : integer := 6;
    
    
    -- CONSTANTS
	constant MEM_ADDR_COUNT	: integer	:= 8;
	constant IADDR_BUS	: integer	:= MEM_ADDR_COUNT;
	constant IDATA_BUS	: integer	:= 32;
	constant DADDR_BUS	: integer	:= MEM_ADDR_COUNT;
	constant DDATA_BUS	: integer	:= 32;
	constant RADDR_BUS	: integer	:= 5;
    
	
	
	constant ZERO1b	: STD_LOGIC							          :=  '0';
	constant ZERO32b	: STD_LOGIC_VECTOR(31 downto 0) :=  "00000000000000000000000000000000";	
	constant ZERO16b	: STD_LOGIC_VECTOR(15 downto 0) :=  "0000000000000000";
	constant ONE32b	: STD_LOGIC_VECTOR(31 downto 0)   :=  "11111111111111111111111111111111";	
	constant ONE16b	: STD_LOGIC_VECTOR(15 downto 0)   :=  "1111111111111111";	
  
	-- RECORDS
	type ALU_OP_INPUT is
	record
		Op0	:	STD_LOGIC;
		Op1	:	STD_LOGIC;
		Op2	:	STD_LOGIC;
	end record;
	
	type ALU_INPUT is
	record
		Op0		:	STD_LOGIC;
		Op1		:	STD_LOGIC;
		Op2		:	STD_LOGIC;
		Op3		:	STD_LOGIC;
	end record;

	type ALU_FLAGS is
	record
		Carry		  :	STD_LOGIC;
		Overflow	:	STD_LOGIC;
		Zero		  :	STD_LOGIC;
		Negative	:	STD_LOGIC;
	end record;
	
  -- NEW!
	type BRANCH_TYPE is (COND_BRANCH, JUMP, NO_BRANCH);
  type ALU_OP      is (ALUOP_LOAD_STORE, ALUOP_BRANCH, ALUOP_FUNC, ALUOP_LDI);
  
  
constant R0 : std_logic_vector(4 downto 0) := "0" & X"0";
constant R1 : std_logic_vector(4 downto 0) := "0" & X"1";
constant R2 : std_logic_vector(4 downto 0) := "0" & X"2";
constant R3 : std_logic_vector(4 downto 0) := "0" & X"3";
constant R4 : std_logic_vector(4 downto 0) := "0" & X"4";
constant R5 : std_logic_vector(4 downto 0) := "0" & X"5";
constant R6 : std_logic_vector(4 downto 0) := "0" & X"6";
constant R7 : std_logic_vector(4 downto 0) := "0" & X"7";
constant R8 : std_logic_vector(4 downto 0) := "0" & X"8";
constant R9 : std_logic_vector(4 downto 0) := "0" & X"9";
constant R10 : std_logic_vector(4 downto 0) := "0" & X"A";
constant R11 : std_logic_vector(4 downto 0) := "0" & X"B";
constant R12 : std_logic_vector(4 downto 0) := "0" & X"C";
constant R13 : std_logic_vector(4 downto 0) := "0" & X"D";
constant R14 : std_logic_vector(4 downto 0) := "1" & X"E";
constant R15 : std_logic_vector(4 downto 0) := "1" & X"F";
constant R16 : std_logic_vector(4 downto 0) := "1" & X"0";
constant R17 : std_logic_vector(4 downto 0) := "1" & X"1";
constant R18 : std_logic_vector(4 downto 0) := "1" & X"2";
constant R19 : std_logic_vector(4 downto 0) := "1" & X"3";
constant R20 : std_logic_vector(4 downto 0) := "1" & X"4";
constant R21 : std_logic_vector(4 downto 0) := "1" & X"5";
constant R22 : std_logic_vector(4 downto 0) := "1" & X"6";
constant R23 : std_logic_vector(4 downto 0) := "1" & X"7";
constant R24 : std_logic_vector(4 downto 0) := "1" & X"8";
constant R25 : std_logic_vector(4 downto 0) := "1" & X"9";
constant R26 : std_logic_vector(4 downto 0) := "1" & X"A";
constant R27 : std_logic_vector(4 downto 0) := "1" & X"B";
constant R28 : std_logic_vector(4 downto 0) := "1" & X"C";
constant R29 : std_logic_vector(4 downto 0) := "1" & X"D";
constant R30 : std_logic_vector(4 downto 0) := "1" & X"E";
constant R31 : std_logic_vector(4 downto 0) := "1" & X"F";
	
end MIPS_CONSTANT_PKG;

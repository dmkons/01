
library ieee;
use ieee.std_logic_1164.all;

package opcodes is
    constant OPCODE_R_ALL : std_logic_vector(5 downto 0):= "000000";
    constant OPCODE_ADDI : std_logic_vector(5 downto 0) := "001000";
    constant OPCODE_ADDIU : std_logic_vector(5 downto 0) := "001001";
    constant OPCODE_ANDI : std_logic_vector(5 downto 0) := "001100";
    constant OPCODE_BEQ : std_logic_vector(5 downto 0) := "000100";
    constant OPCODE_BGEZ : std_logic_vector(5 downto 0) := "000001";
    constant OPCODE_BGTZ : std_logic_vector(5 downto 0) := "000111";
    constant OPCODE_BLEZ : std_logic_vector(5 downto 0) := "000110";
    constant OPCODE_BNE : std_logic_vector(5 downto 0) := "000101";
    constant OPCODE_LLI : std_logic_vector(5 downto 0) := "001111";
    constant OPCODE_LW : std_logic_vector(5 downto 0) := "100011";
    constant OPCODE_ORI : std_logic_vector(5 downto 0) := "001101";
    constant OPCODE_SLTI : std_logic_vector(5 downto 0) := "001010";
    constant OPCODE_SLTIU : std_logic_vector(5 downto 0) := "001011";
    constant OPCODE_SW : std_logic_vector(5 downto 0) := "101011";
    constant OPCODE_XORI : std_logic_vector(5 downto 0) := "001110";
    constant OPCODE_J : std_logic_vector(5 downto 0) := "000010";

    constant FUNCTION_ADD : std_logic_vector(5 downto 0) := "100000";
    constant FUNCTION_ADDU : std_logic_vector(5 downto 0) := "100001";
    constant FUNCTION_AND : std_logic_vector(5 downto 0) := "100100";
    constant FUNCTION_BREAK : std_logic_vector(5 downto 0) := "001101";
    constant FUNCTION_DIV : std_logic_vector(5 downto 0) := "011010";
    constant FUNCTION_DIVU : std_logic_vector(5 downto 0) := "011011";
    constant FUNCTION_JR : std_logic_vector(5 downto 0) := "001000";
    constant FUNCTION_MULT : std_logic_vector(5 downto 0) := "011000";
    constant FUNCTION_MULTU : std_logic_vector(5 downto 0) := "011001";
    constant FUNCTION_NOR : std_logic_vector(5 downto 0) := "100111";
    constant FUNCTION_OR : std_logic_vector(5 downto 0) := "100101";
    constant FUNCTION_SLL : std_logic_vector(5 downto 0) := "000000";
    constant FUNCTION_SLLV : std_logic_vector(5 downto 0) := "000100";
    constant FUNCTION_SLT : std_logic_vector(5 downto 0) := "101010";
    constant FUNCTION_SLTU : std_logic_vector(5 downto 0) := "101011";
    constant FUNCTION_SRA : std_logic_vector(5 downto 0) := "000011";
    constant FUNCTION_SRAV : std_logic_vector(5 downto 0) := "000111";
    constant FUNCTION_SRL : std_logic_vector(5 downto 0) := "000010";
    constant FUNCTION_SRLV : std_logic_vector(5 downto 0) := "000110";
    constant FUNCTION_SUB : std_logic_vector(5 downto 0) := "100010";
    constant FUNCTION_SUBU : std_logic_vector(5 downto 0) := "100011";
    constant FUNCTION_XOR : std_logic_vector(5 downto 0) := "100110";

    constant FUNCTION_PASSTHROUGH : std_logic_vector(5 downto 0) := "111111";
end opcodes;

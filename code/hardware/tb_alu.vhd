LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use work.mips_constant_pkg.all;
use work.opcodes.all;
use work.test_utils.all;


ENTITY tb_alu IS
    END tb_alu;

ARCHITECTURE behavior OF tb_alu IS 

    COMPONENT alu
        generic(
                   WORD_SIZE : integer := WORD_SIZE;
                   FUNCTION_SIZE : integer := FUNCTION_SIZE
               );
        PORT(
                x : IN  signed(WORD_SIZE-1 downto 0);
                y : IN  signed(WORD_SIZE-1 downto 0);
                r : OUT  signed(WORD_SIZE-1 downto 0);
                func : IN  std_logic_vector(FUNCTION_SIZE-1 downto 0);
                flags : OUT  alu_flags
            );
    END COMPONENT;

   --Inputs
    signal clk : std_logic := '0';
    signal x : signed(WORD_SIZE-1 downto 0) := (others => '0');
    signal y : signed(WORD_SIZE-1 downto 0) := (others => '0');
    signal func : std_logic_vector(FUNCTION_SIZE-1 downto 0) := (others => '0');

   --Outputs
    signal r : signed(WORD_SIZE-1 downto 0);
    signal flags : alu_flags;

   -- Clock period definitions
    constant clk_period : time := 10 ns;

BEGIN

    uut: alu PORT MAP (
                          x => x,
                          y => y,
                          r => r,
                          func => func,
                          flags => flags
                      );

    clk_process :process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;

    stimulus_process: process
    begin		

      -- init waiting (is this needed?)
        wait for clk_period*10.5;


      ----- ADD
        func <= FUNCTION_ADD;

      -- test regular addition
        x <= "00000000000000000000000000001111";
        y <= "00000000000000000000000000000001";
        wait for clk_period;
        test("ADD", "regular", r, "00000000000000000000000000010000");
        test("ADD", "regular overflow flag", flags.overflow, '0');

      -- test addition that gives overflow
        x <= "01111111111111111111111111111111";
        y <= "00000000000000000000000000000001";
        wait for clk_period;
        test("ADD", "overflow", r, "10000000000000000000000000000000");
        test("ADD", "overflow overflow flag", flags.overflow, '1');

      -- test addition with a negative operand
        x <= "11111111111111111111111111110111";
        y <= "00000000000000000000000000000001";
        wait for clk_period;
        test("ADD", "negative", r, "11111111111111111111111111111000");
        test("ADD", "negative overflow flag", flags.overflow, '0');


      ----- ADDU
        func <= FUNCTION_ADDU;

      -- test regular addition
        x <= "00000000000000000000000000001111";
        y <= "00000000000000000000000000000001";
        wait for clk_period;
        test("ADDU", "regular", r, "00000000000000000000000000010000");
        test("ADDU", "regular carry flag", flags.carry, '0');

      -- test addition that gives carry out
        x <= "11111111111111111111111111111111";
        y <= "00000000000000000000000000000001";
        wait for clk_period;
        test("ADDU", "carry out", r, "00000000000000000000000000000000");
        test("ADDU", "carry out carry flag", flags.carry, '1');  


      ----- AND
        func <= FUNCTION_AND;

      -- test regular and
        x <= "11010101011011010100101101001001";
        y <= "11101011011000010011010010101101";
        wait for clk_period;
        test("AND", "regular", r, "11000001011000010000000000001001");


      ----- MULT
        func <= FUNCTION_MULT;

      -- test regular mult
        x <= "00000000000000000100101101001001";
        y <= "00000000000000000011010010101101";
        wait for clk_period;
        test("MULT", "regular", r, "00001111011111011011010001010101");

      -- test overflow mult
        x <= "00000000000000000100101101001001";
        y <= "01000000000000000011010010101101";
        wait for clk_period;
        test("MULT", "overflow", r, "01001111011111011011010001010101");

      -- test mult with negative operand
        x <= "00000000000000000000000101001001";
        y <= "11111111111111111011010010101101";
        wait for clk_period;
        test("MULT", "negative", r, "11111111100111110011001001010101");


      ----- MULTU
        func <= FUNCTION_MULTU;

      -- test regular multu
        x <= "10000000000000000100101101001001";
        y <= "00000000000000000000000000000000";
        wait for clk_period;
        test("MULTU", "regular", r, "00000000000000000000000000000000");


      ----- NOR
        func <= FUNCTION_NOR;

      -- test regular nor
        x <= "11010101011011010100101101001001";
        y <= "11101011011000010011010010101101";
        wait for clk_period;
        test("NOR", "regular", r, "00000000100100101000000000010010");    


      ----- OR
        func <= FUNCTION_OR;

      -- test regular or
        x <= "11010101011011010100101101001001";
        y <= "11101011011000010011010010101101";
        wait for clk_period;
        test("OR", "regular", r, "11111111011011010111111111101101");


      ----- SLL
        func <= FUNCTION_SLL;

      -- test regular sll
        x <= "11010101011011010100101101001001";
        y <= "00000000000000000000000000000101";
        wait for clk_period;
        test("SLL", "regular", r, "10101101101010010110100100100000");


      ----- SLLV
        func <= FUNCTION_SLLV;

      -- test regular sllv
        x <= "11010101011011010100101101001001";
        y <= "00000000000000000000000000000101";  
        wait for clk_period;
        test("SLLV", "regular", r, "10101101101010010110100100100000");


      ----- SLT
        func <= FUNCTION_SLT;

      -- test regular slt
        x <= "00001011101101010111011010101010";
        y <= "00010000000000000000000000000101";
        wait for clk_period;
        test("SLT", "regular", r, "00000000000000000000000000000001");

      -- test negative slt
        x <= "10001011101101010111011010101010";
        y <= "00000000000000000000000000000101";
        wait for clk_period;
        test("SLT", "negative", r, "00000000000000000000000000000001");


      ----- SLTU
        func <= FUNCTION_SLTU;

      -- test regular sltu
        x <= "10001011101101010111011010101010";
        y <= "00000000000000000000000000000101";
        wait for clk_period;
        test("SLTU", "regular", r, "00000000000000000000000000000000");


      ----- SRA
        func <= FUNCTION_SRA;

      -- test regular sra
        x <= "01010101011011010100101101001001";
        y <= "00000000000000000000000101000000"; -- (10 downto 6) immediate
        wait for clk_period;
        test("SRA", "regular", r, "00000010101010110110101001011010");

      -- test negative sra
        x <= "11010101011011010100101101001001";
        y <= "00000000000000000000000101000000"; -- (10 downto 6) immediate
        wait for clk_period;
        test("SRA", "negative", r, "11111110101010110110101001011010");


      ----- SRAV
        func <= FUNCTION_SRAV;

      -- test regular srav
        x <= "01010101011011010100101101001001";
        y <= "00000000000000000000000000000101";
        wait for clk_period;
        test("SRAV", "regular", r, "00000010101010110110101001011010");

      -- test negative srav
        x <= "11010101011011010100101101001001";
        y <= "00000000000000000000000000000101";
        wait for clk_period;
        test("SRAV", "negative", r, "11111110101010110110101001011010");


      ----- SRL
        func <= FUNCTION_SRL;

      -- test regular srl
        x <= "01010101011011010100101101001001";
        y <= "00000000000000000000000101000000"; -- (10 downto 6) immediate
        wait for clk_period;
        test("SRL", "regular", r, "00000010101010110110101001011010");

      -- test negative srl
        x <= "11010101011011010100101101001001";
        y <= "00000000000000000000000101000000"; -- (10 downto 6) immediate
        wait for clk_period;
        test("SRL", "negative", r, "00000110101010110110101001011010");


      ----- SRLV
        func <= FUNCTION_SRLV;

      -- test regular srlv
        x <= "01010101011011010100101101001001";
        y <= "00000000000000000000000000000101";
        wait for clk_period;
        test("SRLV", "regular", r, "00000010101010110110101001011010");

      -- test negative srlv
        x <= "11010101011011010100101101001001";
        y <= "00000000000000000000000000000101";
        wait for clk_period;
        test("SRLV", "negative", r, "00000110101010110110101001011010");


      ----- SUB
        func <= FUNCTION_SUB;

      -- test regular sub
        x <= "01010101011011010100101101001001";
        y <= "00000000000000000000000000000101";
        wait for clk_period;
        test("SUB", "regular", r, "01010101011011010100101101000100");
        test("SUB", "regular negative flag", flags.negative, '0');
        test("SUB", "regular zero flag", flags.zero, '0');

      -- test negative sub
        x <= "11010101011011010100101101001001";
        y <= "11111111111111111111111111111111";
        wait for clk_period;
        test("SUB", "negative", r, "11010101011011010100101101001010");
        test("SUB", "negative negative flag", flags.negative, '1');
        test("SUB", "negative zero flag", flags.zero, '0');

      -- test zero sub
        x <= "11010101011011010100101101001001";
        y <= "11010101011011010100101101001001";
        wait for clk_period;
        test("SUB", "zero", r, "00000000000000000000000000000000");
        test("SUB", "zero negative flag", flags.negative, '0');
        test("SUB", "zero zero flag", flags.zero, '1');


      ----- SUBU
        func <= FUNCTION_SUBU;

      -- test regular subu
        x <= "01010101011011010100101101001001";
        y <= "00000000000000000000000000000101";
        wait for clk_period;
        test("SUBU", "regular", r, "01010101011011010100101101000100");

      -- test carry subu
        x <= "11010101011011010100101101001001";
        y <= "11111111111111111111111111111111";
        wait for clk_period;
        test("SUBU", "negative", r, "11010101011011010100101101001010");
      -- TODO: specify better


      ----- XOR
        func <= FUNCTION_XOR;

      -- test regular xor
        x <= "01010101011011010100101101001001";
        y <= "11110101001011010010101011100101";
        wait for clk_period;
        test("XOR", "regular", r, "10100000010000000110000110101100");


      ----- PASSTHROUGH
        func <= FUNCTION_PASSTHROUGH;

      -- test regular passthrough
        x <= "01010101011011010100101101001001";
        y <= "11110101001011010010101011100101";
        wait for clk_period;
        test("PASSTHROUGH", "regular", r, "11110101001011010010101011100101");


        wait;
    end process;

END;

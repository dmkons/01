library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mips_constant_pkg.all;

entity processor is
    generic (
                MEM_ADDR_BUS	: integer := MEM_ADDR_COUNT;
                MEM_DATA_BUS	: integer := 32
            );

    Port (
             clk : in std_logic;
             reset : in std_logic;
             processor_enable: in  std_logic;
             imem_data_in : in std_logic_VECTOR (MEM_DATA_BUS-1 downto 0);
             dmem_data_in : in std_logic_VECTOR (MEM_DATA_BUS-1 downto 0);
             imem_address : out std_logic_VECTOR (MEM_ADDR_BUS-1 downto 0);
             dmem_address : out std_logic_VECTOR (MEM_ADDR_BUS-1 downto 0);
             dmem_address_wr : out std_logic_VECTOR (MEM_ADDR_BUS-1 downto 0);
             dmem_data_out : out std_logic_VECTOR (MEM_DATA_BUS-1 downto 0);
             dmem_write_enable: out std_logic
         );
end processor;

architecture Behavioral of processor is

    component alu is
        generic (
                    WORD_SIZE : integer := WORD_SIZE;
                    FUNCTION_SIZE : integer := FUNCTION_SIZE
                );
        port (
                 x : in signed(WORD_SIZE-1 downto 0);
                 y : in signed(WORD_SIZE-1 downto 0);
                 func : in std_logic_vector(FUNCTION_SIZE-1 downto 0);
                 r : out signed(WORD_SIZE-1 downto 0);
                 flags : out alu_flags
             );
    end component;

    component pc is
        generic (
                    n: integer := MEM_ADDR_COUNT
                );
        port (
                 clk : in std_logic;
                 pc_in : in std_logic_VECTOR (N-1 downto 0);
                 reset : in std_logic;
                 pc_enable : in std_logic;
                 pc_out  : out std_logic_VECTOR (N-1 downto 0)
             );
    end component;

    -- the Registers block
    component register_file is
        port (
                 clk : in std_logic;
                 reset : in std_logic;
                 rw : in std_logic;
                 rs_addr : in std_logic_VECTOR (RADDR_BUS-1 downto 0);
                 rt_addr : in std_logic_VECTOR (RADDR_BUS-1 downto 0);
                 rd_addr : in std_logic_VECTOR (RADDR_BUS-1 downto 0);
                 write_data : in std_logic_VECTOR (DDATA_BUS-1 downto 0); 
                 rs : out std_logic_VECTOR (DDATA_BUS-1 downto 0);
                 rt : out std_logic_VECTOR (DDATA_BUS-1 downto 0)
             );
    end component;


     -- the control unit
    component control_unit is
        generic (
                    OPCODE_SIZE : integer := OPCODE_SIZE;
                    FUNCTION_SIZE : integer := FUNCTION_SIZE
                );
        port (
                 clock : in std_logic;
                 instruction_opcode : in std_logic_vector(OPCODE_SIZE-1 downto 0);
                 instruction_func : in std_logic_vector(FUNCTION_SIZE-1 downto 0);
                 reset : in std_logic;
                 processor_enable : in std_logic;

                 register_destination : out std_logic;
                 memory_to_register : out std_logic;
                 memory_write : out std_logic; 
                 alu_func : out std_logic_vector(FUNCTION_SIZE-1 downto 0);
                 alu_source : out std_logic;
                 register_write : out std_logic;
                 pc_enable : out std_logic;
                 jump : out std_logic;
                 shift_swap : out std_logic
             );
    end component control_unit;

     -- all the multiplexors
     -- (all them multiplexors)
    component mux is
        generic (
                    n: natural := MEM_DATA_BUS
                );
        port (
                 mux_enable : in std_logic;
                 mux_in_0 : in std_logic_VECTOR (N-1 downto 0);
                 mux_in_1 : in std_logic_VECTOR (N-1 downto 0);
                 mux_out : out std_logic_VECTOR (N-1 downto 0)
             );
    end component mux; --end multiplexorz 

    component branch_controller is
        generic (
                    OPCODE_SIZE : integer := OPCODE_SIZE;
                    WORD_SIZE : integer := WORD_SIZE
                );
        port (
                 flags : in alu_flags;
                 instruction_opcode : in std_logic_vector(OPCODE_SIZE-1 downto 0);
                 branch : out std_logic;
                 compare_zero : out std_logic;
                 compare_zero_value : out std_logic_vector(WORD_SIZE-1 downto 0)
             );
    end component branch_controller;

     -- "Registers" read data signals
    signal read_data_1 : std_logic_vector (MEM_DATA_BUS-1 downto 0);
    signal read_data_2 : std_logic_vector (MEM_DATA_BUS-1 downto 0);


     -- ALU1 signals
    signal alu1_result : signed(MEM_DATA_BUS-1 downto 0);
    signal alu_func : std_logic_vector(5 downto 0);
    signal alu_flags : alu_flags;

     -- PC signals
    signal pc_in, pc_out : std_logic_vector(MEM_ADDR_COUNT-1 downto 0);
    signal pc_enable : std_logic;

    -- Defining aliases for the different parts of the instruction signal
    alias instruction_opcode is imem_data_in(31 downto 26);
    alias instruction_concat is imem_data_in(25 downto 0);
    alias instruction_register_addr_1 is imem_data_in(25 downto 21);
    alias instruction_register_addr_2 is imem_data_in(20 downto 16);
    alias instruction_register_addr_3 is imem_data_in(15 downto 11);
    alias instruction_sign_extend is imem_data_in(15 downto 0);
    alias instruction_func is imem_data_in(5 downto 0);

     -- Control unit signals, see fig 4.2 in the compendium
    signal register_destination, memory_read,
    memory_write, memory_to_register, 
    alu_operation, alu_source, register_write,
    jump, shift_swap : std_logic;

     -- Branch controller signals
    signal branch, compare_zero : std_logic;
    signal compare_zero_value : std_logic_vector (MEM_DATA_BUS-1 downto 0);

     -- mux signals
    signal mux_shift_swap_out : std_logic_vector(MEM_DATA_BUS-1 downto 0);  
    signal mux_register_destination_out : std_logic_vector(4 downto 0);
    signal mux_memory_to_register_out : std_logic_vector(MEM_DATA_BUS-1 downto 0);
    signal mux_branch_in_0 : std_logic_vector(MEM_DATA_BUS-1 downto 0);
    signal mux_branch_in_1 : std_logic_vector(MEM_DATA_BUS-1 downto 0);
    signal mux_branch_out : std_logic_vector(MEM_DATA_BUS-1 downto 0); 
    signal mux_jump_out : std_logic_vector(MEM_DATA_BUS-1 downto 0);
    signal mux_alu_source_out : std_logic_vector(MEM_DATA_BUS-1 downto 0);
    signal mux_alu_source_zero_override_out : std_logic_vector(MEM_DATA_BUS-1 downto 0);
    signal mux_branch_enable : std_logic;

    signal jump_address : std_logic_vector(MEM_DATA_BUS-1 downto 0);

    signal sign_extend_out : std_logic_vector(MEM_DATA_BUS-1 downto 0);


begin

    main_control_unit: control_unit
    port map (
                 reset => reset,
                 clock => CLK,
                 instruction_opcode => instruction_opcode,
                 instruction_func => instruction_func,
                 processor_enable => processor_enable,

                 register_destination => register_destination,
                 memory_to_register => memory_to_register,
                 alu_source => alu_source,
                 alu_func => alu_func,
                 register_write => register_write,
                 jump => jump,
                 shift_swap => shift_swap,
                 pc_enable => pc_enable,
                 memory_write => memory_write

             );

    main_branch_controller: branch_controller
    port map (
                 flags => alu_flags,
                 instruction_opcode => instruction_opcode,
                 branch => branch,
                 compare_zero => compare_zero,
                 compare_zero_value => compare_zero_value
             );

    main_alu:   alu
        -- the ALU between Registers and Data memory on the suggested architecture
    port map (
                 x => signed(mux_shift_swap_out),
                 y => signed(mux_alu_source_zero_override_out),
                 r => alu1_result,
                 flags => alu_flags,
                 func => alu_func
             );

    main_pc: pc generic map (n=>MEM_ADDR_COUNT)
    port map (
                 clk => clk,
                 pc_in => mux_jump_out(MEM_ADDR_COUNT-1 downto 0),
                 pc_out => pc_out,
                 pc_enable => pc_enable,
                 reset => reset
             );

    mux_shift_swap: mux generic map (N => 32)
    port map (
                 mux_enable => shift_swap,
                 mux_in_0 => read_data_1,
                 mux_in_1 => read_data_2,
                 mux_out => mux_shift_swap_out
             );

    mux_register_destination: mux generic map (n => 5)
    port map (
                 mux_enable => register_destination,
                 mux_in_0 => instruction_register_addr_2,
                 mux_in_1 => instruction_register_addr_3,
                 mux_out => mux_register_destination_out
             );

    mux_memory_to_register: mux generic map (n => 32)
    port map (
                 mux_enable => memory_to_register,
                 mux_in_0 => std_logic_vector(alu1_result),
                 mux_in_1 => dmem_data_in,
                 mux_out => mux_memory_to_register_out
             );


    mux_alu_source: mux generic map (n => 32)
    port map (
                 mux_enable => alu_source,
                 mux_in_0 => read_data_2,
                 mux_in_1 => sign_extend_out,
                 mux_out => mux_alu_source_out
             );

    mux_alu_source_zero_override: mux generic map (n => 32)
    port map (
                 mux_enable => compare_zero,
                 mux_in_0 => mux_alu_source_out,
                 mux_in_1 => compare_zero_value,
                 mux_out => mux_alu_source_zero_override_out
             );


    mux_branch: mux generic map (n => 32)
    port map (
                 mux_enable => branch,
                 mux_in_0 => mux_branch_in_0,
                 mux_in_1 => mux_branch_in_1,
                 mux_out => mux_branch_out
             );

    mux_jump: mux generic map (n => 32)
    port map (
                 mux_enable => jump,
                 mux_in_0 => mux_branch_out,
                 mux_in_1 => jump_address,
                 mux_out => mux_jump_out
             );

    main_register_file: register_file
    port map (
                 clk => clk
                 reset => reset,
                 rw=> register_write,
                 rs_addr => instruction_register_addr_1,
                 rt_addr => instruction_register_addr_2,
                 rd_addr => mux_register_destination_out,
                 write_data => mux_memory_to_register_out,
                 rs => read_data_1,
                 rt => read_data_2
             );

    process (alu1_result, read_data_1, read_data_2, clk)
        variable alu1_result_slv : std_logic_vector(MEM_DATA_BUS-1 downto 0);
    begin
        dmem_address <= std_logic_vector(resize(unsigned(alu1_result), dmem_address'length));
    end process;

    process (clk, pc_out)
    begin
        imem_address <= std_logic_vector(resize(unsigned(pc_out), imem_address'length));
        mux_branch_in_0 <= std_logic_vector(resize(unsigned(pc_out) + 1, mux_branch_in_0'length));
    end process;

    process (mux_branch_in_0, sign_extend_out)
    begin
        mux_branch_in_1 <= std_logic_vector(unsigned(sign_extend_out) + unsigned(mux_branch_in_0));
    end process;

    process (instruction_sign_extend)
    begin
        sign_extend_out <= std_logic_vector(resize(signed(instruction_sign_extend), sign_extend_out'length));
    end process;

    process (instruction_concat, mux_branch_in_0)
    begin
        jump_address <= mux_branch_in_0(31 downto 26) & instruction_concat;
    end process;

    process (sign_extend_out, mux_branch_in_0)
    begin
        mux_branch_in_1 <= std_logic_vector(unsigned(sign_extend_out) + unsigned(mux_branch_in_0));
    end process;

    process (memory_write)
    begin
        dmem_write_enable <= memory_write;
    end process;

    process(read_data_2)
    begin
        dmem_data_out <= read_data_2;
    end process;

    process(alu1_result)
    begin
        dmem_address_wr <= std_logic_vector(resize(unsigned(alu1_result), dmem_address_wr'length));
    end process;

end Behavioral;


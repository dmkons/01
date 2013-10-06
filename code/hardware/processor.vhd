library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity processor is
	generic (
		MEM_ADDR_BUS		: integer := 32;
		MEM_DATA_BUS		: integer := 32
		);
		
    Port (
		clk : in STD_LOGIC;
		reset               : in STD_LOGIC;
		processor_enable	: in  STD_LOGIC;
		imem_data_in 		: in  STD_LOGIC_VECTOR (MEM_DATA_BUS-1 downto 0);
		dmem_data_in 		: in  STD_LOGIC_VECTOR (MEM_DATA_BUS-1 downto 0);
		imem_address 		: out  STD_LOGIC_VECTOR (MEM_ADDR_BUS-1 downto 0);
		dmem_address 		: out  STD_LOGIC_VECTOR (MEM_ADDR_BUS-1 downto 0);
		dmem_address_wr	    : out  STD_LOGIC_VECTOR (MEM_ADDR_BUS-1 downto 0);
		dmem_data_out		: out  STD_LOGIC_VECTOR (MEM_DATA_BUS-1 downto 0);
		dmem_write_enable	: out  STD_LOGIC
	);
end processor;

architecture behavioral of processor is

	
	-- I guess the ALU is used for stuff?
	-- Math, yo. Probably.
	component alu is
		port (
        clk         : in std_logic;
		X			: in signed(31 downto 0);
		Y			: in signed(31 downto 0);
		FUNC	    : in std_logic_vector(5 downto 0);
		R			: out signed(31 downto 0);
		FLAGS		: out alu_flags
		);
	end component;
		
	-- we need adders to increment the PC
	component adder is
		generic (
			N: integer := MEM_ADDR_BUS
		);
		port (
			X   	: in	STD_LOGIC_VECTOR(N-1 downto 0);
			Y   	: in	STD_LOGIC_VECTOR(N-1 downto 0);
			CIN	    : in	STD_LOGIC;
			COUT	: out	STD_LOGIC;
			R   	: out	STD_LOGIC_VECTOR(N-1 downto 0)
		);
	end component;
	
    component PC is
		generic (
			N: integer := MEM_DATA_BUS
		);
        port (
            CLK     : in STD_LOGIC;
            PC_IN   : in  STD_LOGIC_VECTOR (N-1 downto 0);
            RESET : in std_logic;
            pc_enable : in std_logic;
            PC_OUT  : out  STD_LOGIC_VECTOR (N-1 downto 0)
        );
    end component;
    
    -- the Registers block
    component register_file is
        port (
			CLK 			:	in	STD_LOGIC;				
			RESET			:	in	STD_LOGIC;				
			RW				:	in	STD_LOGIC;				
			RS_ADDR 		:	in	STD_LOGIC_VECTOR (RADDR_BUS-1 downto 0); 
			RT_ADDR 		:	in	STD_LOGIC_VECTOR (RADDR_BUS-1 downto 0); 
			RD_ADDR 		:	in	STD_LOGIC_VECTOR (RADDR_BUS-1 downto 0);
			WRITE_DATA		:	in	STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0); 
			RS				:	out	STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0);
			RT				:	out	STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0)
        );
    end component;
	 
	 
	 -- the control unit
	 component control_unit is
	 port (
			  clock : in std_logic;
			  instruction_opcode : in std_logic_vector(5 downto 0);
              instruction_func : in std_logic_vector(5 downto 0);
			  reset : in std_logic;
				
              register_destination : out std_logic;
			  branch : out std_logic;
			  memory_to_register : out std_logic;
			  memory_write : out std_logic; 
              alu_func : out std_logic_vector(5 downto 0);
			  alu_source : out std_logic;
			  register_write : out std_logic;
              pc_enable : out std_logic;
			  jump : out std_logic;
              shift_swap : out std_logic
	 );
	 end component control_unit;
         
     -- all the multiplexors
     -- (all them multiplexors)
     component MUX is
        generic (
            N: natural := MEM_DATA_BUS
        );
        port (
            CLK : in  STD_LOGIC;
            MUX_ENABLE : in STD_LOGIC;
            MUX_IN_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            MUX_IN_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            MUX_OUT : out  STD_LOGIC_VECTOR (N-1 downto 0)
        );
     end component MUX; --end multiplexorz 
        
        
     
     
     -- "Registers" read data signals
     signal read_data_1 : std_logic_vector (MEM_DATA_BUS-1 downto 0);
     signal read_data_2 : std_logic_vector (MEM_DATA_BUS-1 downto 0);
     
     
     -- ALU1 signals
     signal alu1_result : signed(MEM_DATA_BUS-1 downto 0);
     signal alu_func : std_logic_vector(5 downto 0);
     
     -- PC signals
	 signal pc_in, pc_out : std_logic_vector(MEM_ADDR_BUS-1 downto 0);
     signal pc_enable : std_logic;
     
     -- Defining aliases for the different parts of the instruction signal
     alias instruction_opcode is imem_data_in(31 downto 26);
	 alias instruction_concat is imem_data_in(25 downto 0);
	 alias instruction_register_addr_1 is imem_data_in(25 downto 21);
	 alias instruction_register_addr_2 is imem_data_in(20 downto 16);
	 alias instruction_register_addr_3 is imem_data_in(15 downto 11);
	 alias instruction_sign_extend is imem_data_in(15 downto 0);
	 alias instruction_func is imem_data_in(5 downto 0);
     
     -- Control unit signals, see fig 4.2
     signal register_destination, branch, memory_read,
        memory_write, memory_to_register, 
        alu_operation, alu_source, register_write,
        jump, shift_swap : std_logic;
        
     signal alu_flags : alu_flags;
     
     -- mux signals
     signal MUX_shift_swap_out : std_logic_vector(MEM_DATA_BUS-1 downto 0);  
     signal MUX_register_destination_out : std_logic_vector(4 downto 0);
     signal MUX_memory_to_register_out : std_logic_vector(MEM_DATA_BUS-1 downto 0);
     signal mux_branch_in_0 : std_logic_vector(MEM_DATA_BUS-1 downto 0);
     signal mux_branch_in_1 : std_logic_vector(MEM_DATA_BUS-1 downto 0);
     signal mux_branch_out : std_logic_vector(MEM_DATA_BUS-1 downto 0); 
     signal mux_jump_out : std_logic_vector(MEM_DATA_BUS-1 downto 0);
     signal mux_alu_source_out : std_logic_vector(MEM_DATA_BUS-1 downto 0);
	 signal mux_branch_enable : std_logic;
     
     signal jump_address : std_logic_vector(MEM_DATA_BUS-1 downto 0);
     
     signal sign_extend_out : std_logic_vector(MEM_DATA_BUS-1 downto 0);

	
begin

    MAIN_CONTROL_UNIT: control_unit
        port map (
        reset => reset,
        clock => CLK,
        instruction_opcode => instruction_opcode,
        instruction_func => instruction_func,
        
        register_destination => register_destination,
        branch => branch,
        memory_to_register => memory_to_register,
        alu_source => alu_source,
        alu_func => alu_func,
        register_write => register_write,
        jump => jump,
        shift_swap => shift_swap,
        pc_enable => pc_enable,
        memory_write => memory_write
        
    );


	MAIN_ALU:   alu
		-- the ALU between Registers and Data memory on the suggested architecture
		port map (
            CLK => clk,
			X => signed(MUX_shift_swap_out),
			Y => signed(mux_alu_source_out),
			R => alu1_result,
            FLAGS => alu_flags,
			FUNC => alu_func
		);
	
	MAIN_PC: pc generic map (N=>MEM_DATA_BUS)
		port map (
			CLK => clk,
			PC_IN => mux_jump_out,
			PC_OUT => pc_out,
            pc_enable => pc_enable,
            RESET => reset
        );
    
    MUX_SHIFT_SWAP: MUX generic map (N => 32)
        port map (
            CLK => CLK,
            MUX_ENABLE => shift_swap,
            MUX_IN_0 => read_data_1,
            MUX_IN_1 => read_data_2,
            MUX_OUT => MUX_shift_swap_out
        );
        
    MUX_REGISTER_DESTINATION: MUX generic map (N => 5)
        port map (
            CLK => CLK,
            MUX_ENABLE => register_destination,
            MUX_IN_0 => instruction_register_addr_2,
            MUX_IN_1 => instruction_register_addr_3,
            MUX_OUT => mux_register_destination_out
        );
        
     MUX_MEMORY_TO_REGISTER: MUX generic map (N => 32)
        port map (
            CLK => CLK,
            MUX_ENABLE => memory_to_register,
            MUX_IN_0 => std_logic_vector(alu1_result),
            MUX_IN_1 => dmem_data_in,
            MUX_OUT => mux_memory_to_register_out
        );
        
        
        MUX_ALU_SOURCE: MUX generic map (N => 32)
        port map (
            CLK => CLK,
            MUX_ENABLE => alu_source,
            MUX_IN_0 => read_data_2,
            MUX_IN_1 => sign_extend_out,
            MUX_OUT => MUX_alu_source_out
        );
        
      
      MUX_BRANCH: MUX generic map (N => 32)
        port map (
            CLK => CLK,
            MUX_ENABLE => mux_branch_enable,
            MUX_IN_0 => mux_branch_in_0,
            MUX_IN_1 => mux_branch_in_1,
            MUX_OUT => mux_branch_out
        );
        
	MUX_JUMP: MUX generic map (N => 32)
        port map (
            CLK => CLK,
            MUX_ENABLE => jump,
            MUX_IN_0 => mux_branch_out,
            MUX_IN_1 => jump_address,
            MUX_OUT => mux_jump_out
        );
        
    MAIN_REGISTER_FILE: register_file
        port map (
			CLK => clk,				
			RESET => reset,
			RW	=> register_write,
			RS_ADDR => instruction_register_addr_1,
			RT_ADDR => instruction_register_addr_2,
			RD_ADDR => mux_register_destination_out,
			WRITE_DATA => mux_memory_to_register_out,
			RS => read_data_1,
			RT => read_data_2
        );
		
        process (alu1_result)
        begin
            dmem_address <= std_logic_vector(alu1_result);
        end process;

        process (clk, pc_out)
        begin
            imem_address <= pc_out;
            mux_branch_in_0 <= std_logic_vector(unsigned(pc_out) + 1);
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
            dmem_address_wr <= std_logic_vector(alu1_result);
        end process;
		
		process(branch, alu_flags.zero)
		begin
			mux_branch_enable <= branch and alu_flags.zero;
		end process;
		
end behavioral;


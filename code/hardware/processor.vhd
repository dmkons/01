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
		imem_address 		: out  STD_LOGIC_VECTOR (MEM_ADDR_BUS-1 downto 0);
		imem_data_in 		: in  STD_LOGIC_VECTOR (MEM_DATA_BUS-1 downto 0);
		dmem_data_in 		: in  STD_LOGIC_VECTOR (MEM_DATA_BUS-1 downto 0);
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
		generic (
			N: integer := MEM_DATA_BUS
		);
		port (
		X			: in signed(N-1 downto 0);
		Y			: in signed(N-1 downto 0);
		ALU_IN	    : in ALU_INPUT;
		R			: out signed(N-1 downto 0);
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
            pc_in   : in  STD_LOGIC_VECTOR (N-1 downto 0);
            pc_out  : out  STD_LOGIC_VECTOR (N-1 downto 0)
        );
    end component;
    
    -- memory component for the instruction and data memory blocks
	component memory is 
		generic (
			N: natural := MEM_DATA_BUS;
			M: natural := MEM_ADDR_BUS
		);
		port (
			CLK		    	:   in STD_LOGIC;
			RESET			:	in  STD_LOGIC;	
			W_ADDR		    :	in  STD_LOGIC_VECTOR (M-1 downto 0);	-- Address to write data
			WRITE_DATA	    :	in  STD_LOGIC_VECTOR (N-1 downto 0);	-- Data to be written
			MemWrite		:	in  STD_LOGIC;							-- Write Signal
			ADDR			:	in  STD_LOGIC_VECTOR (M-1 downto 0);	-- Address to access data
			READ_DATA	    :	out STD_LOGIC_VECTOR (N-1 downto 0)		-- Data read from memory
		);
	end component;
    
    
    -- the Registers block
    component register_file is
        generic (
            N: natural; -- RADDR_BUS
            M: natural  -- DDATA_BUS
        );
        port (
			CLK 			:	in	STD_LOGIC;				
			RESET			:	in	STD_LOGIC;				
			RW				:	in	STD_LOGIC;				
			RS_ADDR 		:	in	STD_LOGIC_VECTOR (N-1 downto 0); 
			RT_ADDR 		:	in	STD_LOGIC_VECTOR (N-1 downto 0); 
			RD_ADDR 		:	in	STD_LOGIC_VECTOR (N-1 downto 0);
			WRITE_DATA		:	in	STD_LOGIC_VECTOR (M-1 downto 0); 
			RS				:	out	STD_LOGIC_VECTOR (M-1 downto 0);
			RT				:	out	STD_LOGIC_VECTOR (M-1 downto 0)
        );
    end component;
	 
	 
	 -- the control unit
	 component control_unit is
	 
	 port (
			  clock : in std_logic;
			  instruction : in std_logic_vector(5 downto 0);
			  reset : in std_logic;
				
           register_destination : out std_logic;
			  branch : out std_logic;
			  memory_read : out std_logic;
			  memory_to_register : out std_logic;
			  alu_operation : out std_logic;
			  memory_write : out std_logic; 
			  alu_source : out std_logic;
			  register_write : out std_logic;
			  jump : out std_logic
	 );
	 end component;
            
    signal read_data_1, read_data_2, alu1_result : signed(MEM_DATA_BUS-1 downto 0);
	 signal alu_in : alu_input;
	
begin



	ALU1: alu generic map (N=>MEM_DATA_BUS)
		-- the ALU between Registers and Data memory on the suggested architecture
		port map (
			X => read_data_1,
			Y => read_data_2,
			R => alu1_result,
			ALU_IN => alu_in
		);
	

		
end behavioral;

library ieee;
use ieee.std_logic_1164.all;
use work.opcodes.all;

entity control_unit is
    Port ( 
			  clock : in std_logic;
			  instruction_opcode : in std_logic_vector(5 downto 0);
              instruction_func : in std_logic_vector(5 downto 0);
              
			  reset : in std_logic;
              
              
				
              register_destination : out std_logic;
			  branch : out std_logic;
			  memory_read : out std_logic;
			  memory_to_register : out std_logic;
			  alu_operation : out std_logic;
			  memory_write : out std_logic; 
			  alu_source : out std_logic;
			  register_write : out std_logic;
			  jump : out std_logic; -- I've added this because it looks like we need it,
										  -- even though it is not on figure 4.2
              shift_swap : out std_logic -- the control signal that sends read data 2 into ALU1 rather than read data 1
              
                                          
	  );
end control_unit;

architecture behavioral of control_unit is
	
	type state_type is (fetch, execute, stall);
	signal current_state, next_state: state_type;

begin


process (clock, reset)
begin
	if (reset='1') then
		current_state <= fetch;
	elsif (rising_edge(clock)) then
		current_state <= next_state;
	end if;
end process;


process (current_state, instruction_opcode)
begin

	-- set to defaults
	register_destination <= '0';
	branch <= '0';
	memory_read <= '0';
	memory_to_register <= '0';
	alu_operation <= '0';
	memory_write <= '0';
	alu_source <= '0';
	register_write <= '0';

	case current_state is
		when fetch =>
			next_state <= execute;

     when execute =>
			next_state <= fetch;
			
			case instruction_opcode is
				when OPCODE_R_ALL =>
						alu_operation <= '1';
						register_destination <= '1';
						register_write <= '1';
				
				when OPCODE_ADDI
					| OPCODE_ADDIU
					| OPCODE_ANDI
					| OPCODE_ORI
					| OPCODE_XORI
					| OPCODE_LUI
					| OPCODE_SLTI
					| OPCODE_SLTIU =>
						alu_operation <= '1';
						alu_source <= '1';
						register_write <= '1';					
					
				when OPCODE_BEQ
					| OPCODE_BGEZ
					| OPCODE_BGTZ
					| OPCODE_BLEZ
					| OPCODE_BNE =>
						branch <= '1';
						
				when OPCODE_LB
					| OPCODE_LBU
					| OPCODE_LH
					| OPCODE_LHU
					| OPCODE_LW =>
					   -- TODO: add flip-flips or something since we need to stall?
						memory_read <= '1';
						memory_to_register <= '1';
						alu_source <= '1';
						register_write <= '1';
						next_state <= stall;
					
				when OPCODE_SB
					| OPCODE_SH
					| OPCODE_SW =>
						-- TODO: add flip-flips or something since we need to stall?
						memory_write <= '1';
						alu_source <= '1';
						next_state <= stall;
						
				when OPCODE_J
					| OPCODE_JAL =>
						jump <= '1';
				
				when others => 
			end case;
					
    
	 when stall =>
		next_state <= fetch;

  end case;
end process;


end behavioral;


library ieee;
use ieee.std_logic_1164.all;
use work.mips_constant_pkg.all;
use work.opcodes.all;

entity control_unit is




    generic ( OPCODE_SIZE: natural; FUNCTION_SIZE: natural);
    Port ( 
             clock : in std_logic;
             instruction_opcode : in std_logic_vector(OPCODE_SIZE-1 downto 0);
             instruction_func : in std_logic_vector(FUNCTION_SIZE-1 downto 0);
             processor_enable : in std_logic;
             reset : in std_logic;
             register_destination : out std_logic;
             memory_to_register : out std_logic;
             alu_func : out std_logic_vector(FUNCTION_SIZE-1 downto 0);
             memory_write : out std_logic; 
             alu_source : out std_logic;
             register_write : out std_logic;
             pc_enable : out std_logic;
             jump : out std_logic; -- I've added this because it looks like we need it,
                                   -- even though it is not on figure 4.2
             shift_swap : out std_logic -- the control signal that sends read data 2 into ALU1 rather than read data 1                            
         );
end control_unit;

architecture behavioral of control_unit is

    type state_type is (FETCH, EXECUTE, STALL);
    signal current_state, next_state: state_type;

begin


    process (clock, reset, processor_enable)
    begin
        if processor_enable = '1' then
            if rising_edge(clock) then
                current_state <= next_state;

                if reset = '1' then
                    current_state <= STALL;
                end if;
            end if;
        end if;
    end process;


    process (current_state, instruction_opcode, instruction_func, reset, processor_enable)
    begin
    -- set to defaults
        register_destination <= '0';
        memory_to_register <= '0';
        memory_write <= '0';
        alu_source <= '0';
        register_write <= '0';
        shift_swap <= '0';
        jump <= '0';
        pc_enable <= '0';
        alu_func <= FUNCTION_PASSTHROUGH;

        if processor_enable = '1' and reset = '1' then
            next_state <= FETCH;
        else
            case current_state is
                when FETCH =>
                    next_state <= EXECUTE;
                    memory_write <= '0';

                when EXECUTE =>

                -- set to defaults
                    next_state <= FETCH;
                    pc_enable <= '1';

                    case instruction_opcode is
                        when OPCODE_R_ALL =>
                            alu_func <= instruction_func;
                            case instruction_func is 
                                when FUNCTION_SLL -- shift logical cases
                                | FUNCTION_SRL =>
                                    shift_swap <= '1';
                                when others =>
                         -- do nothing
                            end case; -- end instruction_func
                            register_destination <= '1';
                            register_write <= '1';

                        when OPCODE_ADDI
                        | OPCODE_ADDIU =>
                            alu_func <= FUNCTION_ADD;
                            alu_source <= '1';
                            register_write <= '1';


                        when OPCODE_ANDI =>
                            alu_func <= FUNCTION_AND;
                            alu_source <= '1';
                            register_write <= '1';

                        when OPCODE_ORI =>
                            alu_func <= FUNCTION_OR;
                            alu_source <= '1';
                            register_write <= '1';

                        when OPCODE_XORI =>
                            alu_func <= FUNCTION_XOR;
                            alu_source <= '1';
                            register_write <= '1';

                        when OPCODE_LLI =>
                            alu_source <= '1';
                            register_write <= '1';

                        when OPCODE_SLTI
                        | OPCODE_SLTIU =>
                            alu_func <= FUNCTION_SLT;
                            alu_source <= '1';
                            register_write <= '1';					

                        when OPCODE_BEQ 
                        | OPCODE_BGEZ
                        | OPCODE_BGTZ 
                        | OPCODE_BLEZ 
                        | OPCODE_BNE =>
                            alu_func <= FUNCTION_SUB;

                        when OPCODE_LW =>
                            memory_to_register <= '1';
                            alu_source <= '1';
                            register_write <= '1';
                            next_state <= STALL;
                            pc_enable <= '0';

                        when OPCODE_SW =>
                            memory_write <= '1';
                            alu_source <= '1';
                            next_state <= STALL;
                            pc_enable <= '0';

                        when OPCODE_J =>
                            jump <= '1';

                        when others => 
                    end case;


                when STALL =>
                    next_state <= FETCH;
                    pc_enable <= '1';

            end case; -- end instruction_opcode
        end if;
    end process;


end behavioral;


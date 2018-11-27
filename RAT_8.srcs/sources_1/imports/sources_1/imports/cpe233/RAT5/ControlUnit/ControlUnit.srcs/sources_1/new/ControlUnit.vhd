----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/17/2018 10:40:17 AM
-- Design Name: 
-- Module Name: ControlUnit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlUnit is
    Port ( C_FLAG : in STD_LOGIC;
           Z_FLAG : in STD_LOGIC;
           INT : in STD_LOGIC;
           RESET : in STD_LOGIC;
           OPCODE_HI_5 : in STD_LOGIC_VECTOR (4 downto 0);
           OPCODE_LO_2 : in STD_LOGIC_VECTOR (1 downto 0);
           CLK : in STD_LOGIC;
           I_SET : out STD_LOGIC;
           I_CLR : out STD_LOGIC;
           PC_LD : out STD_LOGIC;
           PC_INC : out STD_LOGIC;
           PC_MUX_SEL : out STD_LOGIC_VECTOR (1 downto 0);
           ALU_OPY_SEL : out STD_LOGIC;
           ALU_SEL : out STD_LOGIC_VECTOR (3 downto 0);
           RF_WR : out STD_LOGIC;
           RF_WR_SEL : out STD_LOGIC_VECTOR (1 downto 0);
           SP_LD : out STD_LOGIC;
           SP_INCR : out STD_LOGIC;
           SP_DECR : out STD_LOGIC;
           SCR_WE : out STD_LOGIC;
           SCR_ADDR_SEL : out STD_LOGIC_VECTOR (1 downto 0);
           SCR_DATA_SEL : out STD_LOGIC;
           FLG_C_SET : out STD_LOGIC;
           FLG_C_CLR : out STD_LOGIC;
           FLG_C_LD : out STD_LOGIC;
           FLG_Z_LD : out STD_LOGIC;
           FLG_LD_SEL : out STD_LOGIC;
           FLG_SHAD_LD : out STD_LOGIC;
           RST : out STD_LOGIC;
           IO_STRB : out STD_LOGIC);
end ControlUnit;

architecture Behavioral of ControlUnit is
Type state is (st_init, st_fetch, st_exec, st_interupt);
signal PS, NS : state;
signal OP_CODE_7 : std_logic_vector(6 downto 0);

begin

OP_CODE_7 <=  OPCODE_HI_5 & OPCODE_LO_2;

sync_proc: process(CLK, RESET)
begin
    if(rising_edge(CLK)) then
        if(RESET ='1') then 
            PS <= st_init;
        else
            PS <= NS;
        end if;
    end if;
end process;

comb_proc: process(PS, OP_CODE_7, Z_FLAG, C_FLAG, INT)
begin
I_SET <= '0';
I_CLR <= '0';
PC_LD <= '0';
PC_INC <= '0';
PC_MUX_SEL <= "00";
ALU_OPY_SEL <= '0';
ALU_SEL <= "0000";
RF_WR <= '0';
RF_WR_SEL <= "00";
SP_LD <= '0';
SP_INCR <= '0';
SP_DECR <= '0';
SCR_WE <= '0';
SCR_ADDR_SEL <= "00";
SCR_DATA_SEL <= '0';
FLG_C_SET <= '0';
FLG_C_CLR <= '0';
FLG_C_LD <= '0';
FLG_Z_LD <= '0';
FLG_LD_SEL <= '0';
FLG_SHAD_LD <= '0';
RST <= '0';
IO_STRB <= '0';
    case PS is
        when st_init =>
            RST <= '1';
            FLG_C_CLR <= '1';
            I_CLR <= '1';
            NS <= st_fetch;
        when st_fetch =>            --added int if statement (DONT KNOW IF CORRECT)
        if(INT = '1') then
            NS <= st_interupt;
        else
            PC_INC <= '1';
            NS <= st_exec;
        end if;
        when st_exec => 
        if(INT ='1') then 
            NS <= st_interupt;
        else
            NS <= st_fetch;
        end if;
            case OP_CODE_7 is
                when "1100100" | "1100101" | "1100110" | "1100111" => --IN
                    RF_WR <= '1';
                    RF_WR_SEL <= "11";
                    
                when "0001001" => --MOV(Rx, Ry)
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "1110";
                    
                when "1101100" | "1101101" | "1101110" | "1101111" => --MOV(Rx, immed)
                    RF_WR <= '1';
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "1110";
                    ALU_OPY_SEL <= '1';
                    
                when "0000010" => --EXOR(Rx, rY)
                    RF_WR <= '1';
                    ALU_SEL <= "0111";
                    
                when "1001000" | "1001001" | "1001010" | "1001011" => --EXOR(Rx, immed)
                    RF_WR <= '1';
                    ALU_SEL <= "0111";
                    ALU_OPY_SEL <= '1';
                    
                when "1101000" | "1101001" | "1101010" | "1101011"  => --OUT
                    IO_STRB <= '1';
                    
                when "0010000" => --BRN
                    PC_LD <= '1';
                    
                when "0000000" => -- AND reg-reg
                    RF_WR_SEL <= "00";
                    RF_WR <= '1';
                    ALU_SEL <= "0101";
                    ALU_OPY_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                    
                when "0000001" => -- OR reg-reg
                    RF_WR_SEL <= "00";
                    RF_WR <= '1';
                    ALU_SEL <= "0110";
                    ALU_OPY_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';

                when "0000011" => -- TEST reg-reg
                    ALU_SEL <= "1000";
                    ALU_OPY_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                    
                when "0000100" => -- ADD reg-reg
                    RF_WR_SEL <= "00";
                    RF_WR <= '1';
                    ALU_SEL <= "0000";
                    ALU_OPY_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                    
                when "0000101" => -- ADDC reg-reg
                    RF_WR_SEL <= "00";
                    RF_WR <= '1';
                    ALU_SEL <= "0001";
                    ALU_OPY_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';

                when "0000110" => -- SUB reg-reg
                    RF_WR     <= '1';
                    ALU_OPY_SEL <= '0';
                    ALU_SEL     <= "0010";
                    RF_WR_SEL <= "00";
                    FLG_C_LD    <= '1';   
                    FLG_Z_LD <= '1';
                    
                when "0000111" => -- SUBC reg-reg
                    RF_WR_SEL <= "00";
                    RF_WR <= '1';
                    ALU_SEL <= "0011";
                    ALU_OPY_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                when "0001010" => -- LD reg-reg 
                    SCR_ADDR_SEL <= "00";
                    RF_WR_SEL <= "01";
                    RF_WR <= '1';

                when "0001011" => -- ST reg-reg
                    SCR_DATA_SEL <= '0';
                    SCR_WE <= '1';
  
                when "1000000" | "1000001" | "1000010" | "1000011" => -- AND reg-immed
                    FLG_LD_SEL <= '0';
                    RF_WR_SEL <= "00";
                    RF_WR <= '1';
                    ALU_SEL <= "0101";
                    ALU_OPY_SEL <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                      
                when "1000100" | "1000101" | "1000110" | "1000111" => -- OR reg-immed
                    FLG_LD_SEL <= '0';
                    RF_WR_SEL <= "00";
                    RF_WR <= '1';
                    ALU_SEL <= "0110";
                    ALU_OPY_SEL <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';

                when "1001100" | "1001101" | "1001110" | "1001111" => -- TEST reg-immed
                    FLG_LD_SEL <= '0';
                    ALU_SEL <= "1000";
                    ALU_OPY_SEL <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
  
                when "1010000" | "1010001" | "1010010" | "1010011" => -- ADD reg-immed
                    RF_WR_SEL <= "00";
                    RF_WR <= '1';
                    ALU_SEL <= "0000";
                    ALU_OPY_SEL <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                    FLG_LD_SEL <= '0';

                when "1010100" | "1010101" | "1010110" | "1010111"  => -- ADDC reg-immed
                    RF_WR_SEL <= "00";
                    RF_WR <= '1';
                    ALU_SEL <= "0001";
                    ALU_OPY_SEL <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                    FLG_LD_SEL <= '0';
  
                when "1011000" | "1011001" | "1011010" | "1011011" => -- SUB reg-immed
                    RF_WR     <= '1';
                    ALU_OPY_SEL <= '1';
                    ALU_SEL     <= "0010";
                    RF_WR_SEL <= "00";
                    FLG_C_LD    <= '1';   
                    FLG_Z_LD    <= '1';
                    FLG_LD_SEL <= '0';

                when "1011100" | "1011101" | "1011110" | "1011111"  => -- SUBC reg-immed
                    RF_WR_SEL <= "00";
                    RF_WR <= '1';
                    ALU_SEL <= "0011";
                    ALU_OPY_SEL <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                    FLG_LD_SEL <= '0';
                    
                when "1100000" | "1100001" | "1100010" | "1100011"   => -- CMP reg-immed
                    ALU_SEL <= "0100";
                    ALU_OPY_SEL <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                    FLG_LD_SEL <= '0';
                
                when "0001000" => --CMP reg-reg
                    ALU_SEL <= "0100";
                    ALU_OPY_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                    
                when "1110000" | "1110001" | "1110010" | "1110011"  => -- LD reg-immed
                    RF_WR <= '1';
                    SCR_ADDR_SEL <= "01";
                    RF_WR_SEL <= "01";

                when "1110100" | "1110101" | "1110110" | "1110111"  => -- ST reg-immed 
                    SCR_WE <= '1';
                    SCR_ADDR_SEL <= "01";

                when "0010001" => -- CALL
                    PC_LD <= '1';
                    PC_MUX_SEL <= "00";
                    SP_DECR <= '1';
                    SCR_DATA_SEL <= '1';
                    SCR_WE <= '1';
                    SCR_ADDR_SEL <= "11";
                    
                when "0110010" => --RET
                    PC_LD <= '1';
                    PC_MUX_SEL <= "01";
                    SP_INCR <= '1';
                    SCR_ADDR_SEL <= "10";
                    
                when "0010010" => -- BREQ
                    if Z_FLAG = '1' then
                        PC_LD <= '1';
                        PC_MUX_SEL <= "00";
                    else
                        PC_LD <= '0';
                    end if;
            
                when "0010011" => -- BRNE
                    if Z_FLAG = '0' then
                        PC_LD <= '1';
                        PC_MUX_SEL <= "00";
                    else
                        PC_LD <= '0';
                    end if;

                when "0010100" => -- BRCS
                    if C_FLAG = '1' then
                        PC_LD <= '1';
                        PC_MUX_SEL <= "00";
                    else
                        PC_LD <= '0';
                    end if;
            
                when "0010101" => -- BRCC
                    if C_FLAG = '0' then
                        PC_LD <= '1';
                        PC_MUX_SEL <= "00";
                    else
                        PC_LD <= '0';
                    end if;
                
                when "0100000" => -- LSL
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "1001";
                    RF_WR <= '1';
                    FLG_LD_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
            
                when "0100001" => -- LSR
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "1010";
                    RF_WR <= '1';
                    FLG_LD_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
            
                when "0100010" => -- ROL
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "1011";
                    RF_WR <= '1';
                    FLG_LD_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
            
                when "0100011" => -- ROR
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "1100";
                    RF_WR <= '1';
                    FLG_LD_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
            
                when "0100100" => -- ASR
                    RF_WR_SEL <= "00";
                    ALU_SEL <= "1101";
                    RF_WR <= '1';
                    FLG_LD_SEL <= '0';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                
                when "0100101" => -- PUSH
                    SCR_DATA_SEL <= '0';
                    SCR_WE <= '1';
                    SCR_ADDR_SEL <= "11";
                    SP_DECR <= '1';
                
                when "0100110" => -- POP
                    RF_WR_SEL <= "01";
                    RF_WR <= '1';
                    SP_INCR <= '1';
                    SCR_ADDR_SEL <= "10";
                
                when "0101000" =>  -- WSP
                    SP_LD <= '1';
                
                when "0101001" => -- RSP
                    RF_WR <= '1';
                    RF_WR_SEL <= "10";
                
                when "0110000" => -- CLC
                    FLG_C_CLR <= '1';
                    
                when "0110001" => -- SEC
                    FLG_C_SET <= '1';
                    
                when "0110100" => --SEI
                    I_SET <= '1';
                    
                when "0110101" => --CLI
                    I_CLR <= '1';
                    
                when "0110110" => --RETID
                    PC_MUX_SEL <= "01";
                    SP_INCR <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                    FLG_LD_SEL <= '1';
                    I_CLR <= '1';
                    PC_LD <= '1';
                    SCR_ADDR_SEL <= "10"; 
                    
                when "0110111" => --RETIE
                    PC_MUX_SEL <= "01";
                    SP_INCR <= '1';
                    FLG_C_LD <= '1';
                    FLG_Z_LD <= '1';
                    FLG_LD_SEL <= '1';
                    I_SET <= '1';
                    PC_LD <= '1';
                    SCR_ADDR_SEL <= "10"; 
                                                          
                when others => 
                    NS <= st_fetch;          
            end case;
       when st_interupt =>
            NS <= st_fetch;
            FLG_C_CLR <= '1';
            SCR_WE <= '1';
            SCR_ADDR_SEL <= "11";
            SP_DECR <= '1';
            SCR_DATA_SEL <= '1';
            FLG_SHAD_LD <= '1';
            PC_LD <= '1';
            PC_MUX_SEL <= "10";
            I_CLR <= '1'; 
                
       when others =>
            NS <= st_init;
    end case;
end process;
                            
                    
                    
                    

end Behavioral;

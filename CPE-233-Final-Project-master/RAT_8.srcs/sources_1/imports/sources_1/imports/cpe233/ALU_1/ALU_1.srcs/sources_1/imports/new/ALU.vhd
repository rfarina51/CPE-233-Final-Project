library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
 
entity ALU is
    Port ( SEL : in STD_LOGIC_VECTOR (3 downto 0);
           A : in std_logic_vector (7 downto 0);
           B : in std_logic_vector (7 downto 0);
           CIN : in STD_LOGIC;
           RESULT : out STD_LOGIC_VECTOR (7 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC);
end ALU;
 
architecture Behavioral of ALU is
 
begin
proc1: process (SEL, A, B, CIN)
variable TEMP : std_logic_vector(8 downto 0) := "000000000";
begin
    C <= '0';
    Z <= '0';
    case SEL is
        when "0000" => --ADD
            TEMP := ('0' & A) + ('0' & B);
            C <= TEMP(8);
        when "0001" => --ADDC
            TEMP := ('0' & A) + ('0' & B) + CIN;
            C <= TEMP(8);
        when "0010" => --SUB
            TEMP := ('0' & A) - ('0' & B);
            C <= TEMP(8);
        when "0100" => --CMP
            TEMP := ('0' & A) - ('0' & B);
            C <= TEMP(8);
        when "0011" => --SUBC (don't know about this one)
            TEMP := ('0' & A) - ('0' & B) - CIN;
            C <= TEMP(8);
        when "0101" => --AND
            TEMP := '0' & (A AND B);
        when "1000" => --TEST
            TEMP := '0' & (A AND B);
        when "0110" => --OR
        TEMP := '0' & (A OR B);
        when "0111" => --EXOR
            TEMP := '0' & (A XOR B);
        when "1001" => --LSL
            TEMP := '0' & (A(6 downto 0) & CIN);
            C  <= A(7);
        when "1010" => --LSR
            TEMP := '0' & (CIN & A(7 downto 1));
            C <= A(0);
        when "1011" => --ROL
            TEMP := '0' & (A(6 downto 0) & A(7));
            C <= A(7);
        when "1100" => --ROR
            TEMP := '0' & (A(0) & A(7 downto 1));
            C <= A(0);
        when "1101" => --ASR
            TEMP := '0' & (A(7) & A(7 downto 1));
            C <= A(0);
        when "1110" => --MOV
            TEMP := '0' & B;
        when others => --else
            TEMP := "000000000";
    end case;
    
    if(TEMP = "00000000") then
        Z <= '1';
    end if;
    RESULT <= TEMP(7 downto 0);
    
end process;
  
end Behavioral;
 

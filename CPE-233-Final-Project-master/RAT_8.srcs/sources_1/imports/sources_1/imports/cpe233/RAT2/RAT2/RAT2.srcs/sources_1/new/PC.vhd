library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
    Port ( DIN : in STD_LOGIC_VECTOR (9 downto 0);
           CLK : in STD_LOGIC;
           PC_LD : in STD_LOGIC;
           PC_INC : in STD_LOGIC;
           RST : in STD_LOGIC;
           PC_COUNT1 : out STD_LOGIC_VECTOR (9 downto 0));
end PC;

architecture Behavioral of PC is
signal int_incr : unsigned( 9 downto 0) := "0000000000";
begin
    pc_proc: process (CLK, PC_LD, PC_INC, RST)
    begin
        if(rising_edge(CLK)) then
            if(RST ='1') then
                int_incr <= "0000000000";
            elsif (PC_LD = '1') then
                int_incr <= unsigned(DIN);
            elsif (PC_INC = '1') then
                int_incr <= int_incr + 1;
            end if;
       end if;
   end process;  
   PC_COUNT1 <= std_logic_vector(int_incr);
end Behavioral;

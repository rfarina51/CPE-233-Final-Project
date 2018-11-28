library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Scratch_RAM is
    Port ( DATA_IN : in STD_LOGIC_VECTOR (9 downto 0);
           SCR_ADDR : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_WE : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0));
end Scratch_RAM;

architecture Behavioral of Scratch_RAM is
TYPE memory is ARRAY (0 to 255) of std_logic_vector(9 downto 0);
signal ram : memory := (others => (others => '0'));
signal tempOUT : std_logic_vector(9 downto 0);
begin
    scr1: process(DATA_IN, tempOUT, SCR_ADDR, SCR_WE, CLK)
    begin
    tempOUT <= ram(to_integer(unsigned(SCR_ADDR)));
    if(rising_edge(CLK)) then
        if(SCR_WE ='1') then
            ram(to_integer(unsigned(SCR_ADDR))) <= DATA_IN;
        end if;
    end if;
    DATA_OUT <= tempOUT;
    end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Register_File is
    Port ( DIN : in STD_LOGIC_VECTOR (7 downto 0);
           ADRX : in STD_LOGIC_VECTOR (4 downto 0);
           ADRY : in STD_LOGIC_VECTOR (4 downto 0);
           RF_WR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT : out STD_LOGIC_VECTOR (7 downto 0));           
end Register_File;

architecture Behavioral of Register_File is
TYPE memory is ARRAY (0 to 31) of std_logic_vector(7 downto 0);
signal ram : memory := (others => (others => '0'));
signal tempX : std_logic_vector(7 downto 0);
signal tempY : std_logic_vector(7 downto 0);
begin
    reg1: process(ADRX, ADRY, RF_WR, DIN, CLK, tempX, tempY)
    begin
    tempX <= ram(to_integer(unsigned(ADRX)));
    tempY <= ram(to_integer(unsigned(ADRY)));
    if(rising_edge(CLK)) then
        if(RF_WR = '1') then
            ram(to_integer(unsigned(ADRX))) <= DIN;
        end if;
    end if;
    DX_OUT <= tempX;
    DY_OUT <= tempY;
    end process;

end Behavioral;

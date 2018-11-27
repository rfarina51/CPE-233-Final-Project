library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_and_MUX is
	Port (
       	CLK : in STD_LOGIC;
       	PC_LD : in STD_LOGIC;
       	PC_INC : in STD_LOGIC;
       	RST : in STD_LOGIC;
       	PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0);
       	FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
       	FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
       	LAST: in STD_LOGIC_VECTOR (9 downto 0);
       	X : in STD_LOGIC_VECTOR (9 downto 0);
       	PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0));
end PC_and_MUX;


architecture Behavioral of PC_and_MUX is
	component PC is
    	Port ( DIN : in STD_LOGIC_VECTOR (9 downto 0);
           	CLK : in STD_LOGIC;
           	PC_LD : in STD_LOGIC;
           	PC_INC : in STD_LOGIC;
           	RST : in STD_LOGIC;
           	PC_COUNT1 : out STD_LOGIC_VECTOR (9 downto 0));
	end component;
    
	component MUX24 is
     	Port (FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
           	FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
           	LAST: in STD_LOGIC_VECTOR (9 downto 0);
           	X : in STD_LOGIC_VECTOR (9 downto 0);
           	PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           	DOUT : out STD_LOGIC_VECTOR (9 downto 0));
	end component;
    
signal D : std_logic_vector(9 downto 0);
    
begin
pc1: PC port map(
    	DIN => D,
    	CLK => CLK,
    	PC_LD => PC_LD,
    	PC_INC => PC_INC,
    	RST => RST,
    	PC_COUNT1 => PC_COUNT);
mux1: MUX24 port map(
    	FROM_IMMED => FROM_IMMED,
    	FROM_STACK => FROM_STACK,
    	LAST => LAST,
    	X => X,
    	PC_MUX_SEL => PC_MUX_SEL,
    	DOUT => D);


end Behavioral;

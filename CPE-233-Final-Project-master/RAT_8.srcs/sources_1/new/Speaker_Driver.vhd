library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Speaker_Driver is
	Port (  CLK_IN : in STD_LOGIC;
       	    NOTE : in STD_LOGIC_VECTOR (7 downto 0);
       	    CLK_OUT : out STD_LOGIC);
end Speaker_Driver;

architecture my_clock_div of Speaker_Driver is
   signal tmp_clk : std_logic := '0';
   signal MAX : integer;
begin
   max_count: process(NOTE)
   Begin
-- find how many times bigger the clock frequency is than the note frequency (then divide by two to account for the 50% duty cycle wave)
   case NOTE is
        when "00000001" => MAX <= 47778;
        when "00000010" => MAX <= 45097;
        when "00000011" => MAX <= 42566;
        when "00000100" => MAX <= 40177;
        when "00000101" => MAX <= 37922;
        when "00000110" => MAX <= 35793;
        when "00000111" => MAX <= 33784;
        when "00001000" => MAX <= 31888;
        when "00001001" => MAX <= 30098;
        when "00001010" => MAX <= 28409;
        when "00001011" => MAX <= 26815;
        when "00001100" => MAX <= 25310;
        when "00001101" => MAX <= 23889;
        when "00001110" => MAX <= 22548;
        when "00001111" => MAX <= 21283;
        when "00010000" => MAX <= 20088;
        when "00010001" => MAX <= 18961;
        when "00010010" => MAX <= 17897;
        when "00010011" => MAX <= 16892;
        when "00010100" => MAX <= 15944;
        when "00010101" => MAX <= 15049;
        when "00010110" => MAX <= 14205;
        when "00010111" => MAX <= 13407;
        when "00011000" => MAX <= 12655;
        when "00011001" => MAX <= 11945;
        when "00011010" => MAX <= 11274;
        when "00011011" => MAX <= 10641;
        when "00011100" => MAX <= 10044;
        when "00011101" => MAX <= 9480;
        when "00011110" => MAX <= 8948;
        when "00011111" => MAX <= 8446;
        when "00100000" => MAX <= 7972;
        when "00100001" => MAX <= 7525;
        when "00100010" => MAX <= 7102;
        when "00100011" => MAX <= 6704;
        when "00100100" => MAX <= 6327;
        when others => MAX <= 0;
  end case;
  end process;
   
div: process (CLK_IN,tmp_clk)         	 
variable div_cnt : integer := 0;   
begin
    if (rising_edge(CLK_IN)) then   	 
            if (div_cnt >= MAX) then --when the accumulator hits our max, invert clock
                tmp_clk <= not tmp_clk ;
                div_cnt := 0; --restart accumulator for next cycle
            else
                div_cnt := div_cnt + 1; --increment until max is reached
            end if;
    end if;

    if (MAX /= 0) then  --give the value to the divided clock
        CLK_OUT <= tmp_clk;
    else
        CLK_OUT <= '0'; --set frequency to zero if value is not one specified
    end if;

end process div;
end my_clock_div;

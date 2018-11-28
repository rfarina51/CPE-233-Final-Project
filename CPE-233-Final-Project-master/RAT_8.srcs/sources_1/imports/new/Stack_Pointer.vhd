----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2018 12:40:28 PM
-- Design Name: 
-- Module Name: Stack_Pointer - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Stack_Pointer is
    Port ( DATA : in STD_LOGIC_VECTOR (7 downto 0);
           RST : in STD_LOGIC;
           SP_LD : in STD_LOGIC;
           SP_INCR : in STD_LOGIC;
           SP_DECR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end Stack_Pointer;

architecture Behavioral of Stack_Pointer is
signal int_incr : unsigned(7 downto 0) := "00000000";
begin

    pc_proc: process (CLK, SP_LD, SP_INCR, RST, SP_DECR)
    begin
        if(rising_edge(CLK)) then
            if(RST ='1') then
                int_incr <= "00000000";
            elsif (SP_LD = '1') then
                int_incr <= unsigned(DATA);
            elsif (SP_INCR = '1') then
                int_incr <= int_incr + 1;
            elsif (SP_DECR = '1') then
                int_incr <= int_incr - 1;      
            end if;
       end if;
   end process;  
   DATA_OUT <= std_logic_vector(int_incr);

end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/03/2018 10:05:43 AM
-- Design Name: 
-- Module Name: MUX24 - Behavioral
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

entity MUX24 is
    Port ( FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
           FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
           LAST: in STD_LOGIC_VECTOR (9 downto 0) := "1111111111";
           X : in STD_LOGIC_VECTOR (9 downto 0) := "0000000000";
           PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           DOUT : out STD_LOGIC_VECTOR (9 downto 0));
end MUX24;

architecture Behavioral of MUX24 is

begin
SEL: process(FROM_IMMED, FROM_STACK, LAST, X, PC_MUX_SEL)
begin
    case PC_MUX_SEL is
        when "00" => DOUT <= FROM_IMMED;
        when "01" => DOUT <= FROM_STACK;
        when "10" => DOUT <= LAST;
        when "11" => DOUT <= X;
        when others =>
    end case;
end process;
end Behavioral;

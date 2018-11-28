----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/19/2018 09:32:21 AM
-- Design Name: 
-- Module Name: ALU_MUX - Behavioral
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

entity ALU_MUX is
    Port ( DY_OUT_TO_ALU : in STD_LOGIC_VECTOR (7 downto 0);
           IR_TO_ALU : in STD_LOGIC_VECTOR (7 downto 0);
           ALU_OPY_SEL : in STD_LOGIC;
           ALU_MUX_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end ALU_MUX;

architecture Behavioral of ALU_MUX is

begin
sel: process(DY_OUT_TO_ALU, IR_TO_ALU, ALU_OPY_SEL)
begin
case ALU_OPY_SEL is
    when '0' => 
        ALU_MUX_OUT <= DY_OUT_TO_ALU;
    when '1' => 
        ALU_MUX_OUT <= IR_TO_ALU;
    when others =>
end case;
end process;
    

end Behavioral;

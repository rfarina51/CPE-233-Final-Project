----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2018 01:02:04 PM
-- Design Name: 
-- Module Name: Scratch_DIN_MUX - Behavioral
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

entity Scratch_DIN_MUX is
    Port ( DX_OUT : in STD_LOGIC_VECTOR (7 downto 0);
           PC_COUNT : in STD_LOGIC_VECTOR (9 downto 0);
           DATA_IN : out STD_LOGIC_VECTOR (9 downto 0);
           SCR_DATA_SEL : in STD_LOGIC);
end Scratch_DIN_MUX;

architecture Behavioral of Scratch_DIN_MUX is

begin
SEL: process(DX_OUT, PC_COUNT, SCR_DATA_SEL)
begin
    if(SCR_DATA_SEL = '0') then
        DATA_IN <= "00" & DX_OUT;
    else
        DATA_IN <= PC_COUNT;
    end if;
end process;

end Behavioral;

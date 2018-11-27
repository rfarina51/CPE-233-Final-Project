----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2018 12:54:03 PM
-- Design Name: 
-- Module Name: Scratch_ADDR_MUX - Behavioral
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

entity Scratch_ADDR_MUX is
    Port ( DY_OUT : in STD_LOGIC_VECTOR (7 downto 0);
           FROM_IR : in STD_LOGIC_VECTOR (7 downto 0);
           SP_DOUT : in STD_LOGIC_VECTOR (7 downto 0);
           SP_DOUT_1 : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_ADDR_SEL : in STD_LOGIC_VECTOR(1 downto 0);
           SCR_ADDR : out STD_LOGIC_VECTOR (7 downto 0));
end Scratch_ADDR_MUX;

architecture Behavioral of Scratch_ADDR_MUX is

begin
SEL: process(DY_OUT, FROM_IR, SP_DOUT, SP_DOUT_1, SCR_ADDR_SEL)
begin
    case SCR_ADDR_SEL is
        when "00" => 
            SCR_ADDR <= DY_OUT;
        when "01" => 
            SCR_ADDR <= FROM_IR;
        when "10" => 
            SCR_ADDR <= SP_DOUT;
        when "11" => 
            SCR_ADDR <= SP_DOUT_1;
        when others =>
    end case;
end process;

end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/19/2018 09:32:21 AM
-- Design Name: 
-- Module Name: REG_MUX - Behavioral
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

entity REG_MUX is
    Port ( ALU_RESULT_TO_REG : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_DATA_OUT_TO_REG : in STD_LOGIC_VECTOR (7 downto 0);
           SP_DATA_OUT_TO_REG : in STD_LOGIC_VECTOR (7 downto 0);
           IN_PORT_TO_REG : in STD_LOGIC_VECTOR (7 downto 0);
           RF_WR_SEL : in STD_LOGIC_VECTOR(1 downto 0);
           REG_MUX_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end REG_MUX;

architecture Behavioral of REG_MUX is

begin
SEL: process(ALU_RESULT_TO_REG, SCR_DATA_OUT_TO_REG, SP_DATA_OUT_TO_REG, IN_PORT_TO_REG, RF_WR_SEL)
begin
    case RF_WR_SEL is
        when "00" => 
            REG_MUX_OUT <= ALU_RESULT_TO_REG;
        when "01" => 
            REG_MUX_OUT <= SCR_DATA_OUT_TO_REG;
        when "10" => 
            REG_MUX_OUT <= SP_DATA_OUT_TO_REG;
        when "11" => 
            REG_MUX_OUT <= IN_PORT_TO_REG;
        when others =>
    end case;
end process;
end Behavioral;


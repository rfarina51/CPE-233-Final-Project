----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2018 11:15:26 AM
-- Design Name: 
-- Module Name: SHAD_FLAGS - Behavioral
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

entity SHAD_FLAGS is
    Port ( C_IN : in STD_LOGIC;
           Z_IN : in STD_LOGIC;
           FLG_SHAD_LD : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Z_OUT : out STD_LOGIC;
           C_OUT : out STD_LOGIC);
end SHAD_FLAGS;

architecture Behavioral of SHAD_FLAGS is

begin
shadcflag: process(C_IN, FLG_SHAD_LD, CLK)
begin
    if(rising_edge(CLK)) then
        if(FLG_SHAD_LD = '1') then
            C_OUT <= C_IN;
        end if;
    end if;
end process;

shadzflag: process(Z_IN, FLG_SHAD_LD, CLK)
begin
    if(rising_edge(CLK)) then
        if(FLG_SHAD_LD = '1') then
            Z_OUT <= Z_IN;
        end if;
    end if;
end process;
           

end Behavioral;

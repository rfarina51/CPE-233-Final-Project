----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/17/2018 08:16:37 PM
-- Design Name: 
-- Module Name: FLAGS - Behavioral
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

entity FLAGS is
    Port ( C : in STD_LOGIC;
           Z : in STD_LOGIC;
           FLG_C_SET : in STD_LOGIC;
           FLG_C_CLR : in STD_LOGIC;
           FLG_C_LD : in STD_LOGIC;
           FLG_Z_LD : in STD_LOGIC;
           CLK : in STD_LOGIC;
           C_FLAG : out STD_LOGIC;
           Z_FLAG : out STD_LOGIC);
end FLAGS;

architecture Behavioral of FLAGS is

begin
cflag: process(CLK, FLG_C_SET, FLG_C_CLR, FLG_C_LD)
begin
    if(rising_edge(CLK)) then
        if(FLG_C_CLR = '1') then
            C_FLAG <= '0';
        elsif(FLG_C_SET = '1') then
            C_FLAG <= '1';
        elsif(FLG_C_LD = '1') then
            C_FLAG <= C;
        end if;
    end if;
end process;

zflag: process(CLK, FLG_Z_LD) 
begin
    if(rising_edge(CLK)) then
        if(FLG_Z_LD = '1') then
           Z_FLAG <= Z;
        end if;
    end if;
end process;

               
     
    
            

end Behavioral;

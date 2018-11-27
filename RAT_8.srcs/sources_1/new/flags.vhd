-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/17/2018 10:29:22 AM
-- Design Name: 
-- Module Name: flags - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/17/2018 10:29:22 AM
-- Design Name: 
-- Module Name: flags - Behavioral
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

entity flags is
    Port ( CLK : in STD_LOGIC;
           C : in STD_LOGIC;
           FLG_C_SET : in STD_LOGIC;
           FLG_C_CLR : in STD_LOGIC;
           FLG_C_LD : in STD_LOGIC;
           Z : in STD_LOGIC;
           FLG_Z_LD : in STD_LOGIC;
           FLG_LD_SEL : in STD_LOGIC;
           FLG_SHAD_LD : in STD_LOGIC;
           C_FLAG : out STD_LOGIC;
           Z_FLAG : out STD_LOGIC);
end flags;

architecture Behavioral of flags is
    signal r_C : STD_LOGIC;
    signal r_Z : STD_LOGIC;
    signal r_shad_C : STD_LOGIC;
    signal r_shad_Z : STD_LOGIC;
    
begin

    Carry: process(CLK,FLG_C_CLR,FLG_C_SET,FLG_C_LD,C, FLG_LD_SEL)
    begin
        if(rising_edge(CLK)) then
            if(FLG_C_CLR = '1') then
                r_C <= '0';
            elsif(FLG_C_SET = '1') then
                r_C <= '1';
            elsif(FLG_C_LD = '1') then
                if (FLG_LD_SEL = '1') then
                    r_C <= r_shad_C;
                else
                    r_C <= C;
                end if;
            end if;
        end if;        
    end process;
    
    C_FLAG <= r_C;
    
    Zero: process(CLK,FLG_Z_LD,Z)
    begin
        if(rising_edge(CLK)) then
            if(FLG_Z_LD = '1') then
                if (FLG_LD_SEL = '1') then
                    r_Z <= r_shad_Z;
                else
                    r_Z <= Z;
                end if;
            end if;
        end if;
    end process;

    Z_FLAG <= r_Z;
    
    shadow_Carry: process(CLK, FLG_SHAD_LD, r_C)
    begin
        if(rising_edge(CLK)) then
            if (FLG_SHAD_LD = '1') then
                r_shad_C <= r_C;
            end if;
        end if;
    end process;
    
    shadow_Zero: process(CLK, FLG_SHAD_LD, r_Z)
    begin
        if(rising_edge(CLK)) then
            if (FLG_SHAD_LD = '1') then
                r_shad_Z <= r_Z;
            end if;
        end if;
    end process;
    
end Behavioral;
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2018 11:19:26 AM
-- Design Name: 
-- Module Name: FLGS - Behavioral
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

entity FLGS is
    Port ( C : in STD_LOGIC;
           Z : in STD_LOGIC;
           FLG_C_SET : in STD_LOGIC;
           FLG_C_CLR : in STD_LOGIC;
           FLG_C_LD : in STD_LOGIC;
           FLG_Z_LD : in STD_LOGIC;
           FLG_SHAD_LD: in STD_LOGIC;
           FLG_LD_SEL: in STD_LOGIC;
           CLK : in STD_LOGIC;
           C_FLG : out STD_LOGIC;
           Z_FLG : out STD_LOGIC);
end FLGS;

architecture Behavioral of FLGS is

component FLAGS is
    Port ( C : in STD_LOGIC;
           Z : in STD_LOGIC;
           FLG_C_SET : in STD_LOGIC;
           FLG_C_CLR : in STD_LOGIC;
           FLG_C_LD : in STD_LOGIC;
           FLG_Z_LD : in STD_LOGIC;
           CLK : in STD_LOGIC;
           C_FLAG : out STD_LOGIC;
           Z_FLAG : out STD_LOGIC);
end component;

component SHAD_FLAGS is
    Port ( C_IN : in STD_LOGIC;
           Z_IN : in STD_LOGIC;
           FLG_SHAD_LD : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Z_OUT : out STD_LOGIC;
           C_OUT : out STD_LOGIC);    
end component;

signal s_Z_IN : std_logic;
signal s_C_IN : std_logic;
signal s_Z_OUT : std_logic;
signal s_C_OUT : std_logic;
signal s_SHADZ_OUT : std_logic;
signal s_SHADC_OUT : std_logic;

begin
flag: FLAGS port map(
    C => s_C_IN,
    Z => s_Z_IN,
    FLG_C_SET => FLG_C_SET,
    FLG_C_CLR => FLG_C_CLR,
    FLG_C_LD => FLG_C_LD,
    FLG_Z_LD => FLG_Z_LD,
    CLK => CLK,
    C_FLAG => s_C_OUT,
    Z_FLAG => s_Z_OUT);
    
shdflag: SHAD_FLAGS port map(
    C_IN => s_C_OUT,
    Z_IN => s_Z_OUT,
    FLG_SHAD_LD => FLG_SHAD_LD,
    CLK => CLK,
    Z_OUT => s_SHADZ_OUT,
    C_OUT => s_SHADC_OUT);
    
mux: process(C, Z, s_SHADZ_OUT, s_SHADC_OUT, FLG_LD_SEL)
begin
    if(FLG_LD_SEL = '1') then
        s_C_IN <= s_SHADC_OUT;
        s_Z_IN <= s_SHADZ_OUT;
    else
        s_C_IN <= C;
        s_Z_IN <= Z;
    end if;
end process;

C_FLG <= s_C_OUT;
Z_FLG <= s_Z_OUT;        

end Behavioral;

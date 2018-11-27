----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 11/09/2018 07:39:06 AM
-- Design Name:
-- Module Name: Keypad - Behavioral
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
 
entity Keypad is
    Port ( COL : in STD_LOGIC_VECTOR (2 downto 0);
           CLK : in STD_LOGIC;
           DATA : out STD_LOGIC_VECTOR (7 downto 0);
           ROW : out STD_LOGIC_VECTOR (3 downto 0);
           INT : out STD_LOGIC);
end Keypad;
 
architecture Behavioral of Keypad is
 
 
type state is (row0, row1, row2, row3, pulse, hold);
signal PS, NS : state;
signal tempData : std_logic_vector(7 downto 0) := "11111111"; --number not utilized to indicate blank display
signal max : integer := 100000; --amount of clock cycles needed to change states at a reasonable time
--found through trial and error with button press timing
signal state_count : integer := 0; --initializes counter
--Rows (B, G, F, D)
--Columns (C, A, E)
 
begin
 
    
my_div: process (PS) --process to decide how long to stay in each state 
begin
    if(PS = pulse) then
        max <= 5; --stay in the pulse state for 6 clock cycles (60ns)
    else
        max <= 100000; --otherwise cycle at 100000 clock cycles
    end if;            
end process my_div;
        
            
sync_proc : process(CLK)
 
begin
    if(rising_edge(CLK)) then
        if(state_count = max) then --only move to next state once counter reaches max
            PS<=NS;
            state_count <= 0;
        else
            state_count <= state_count + 1;
        end if;
    end if;
end process;
 
comb_proc : process(PS, COL,tempDATA)
begin
INT <= '0'; --initialize interrupt signal to '0'
    case PS is
        when row0 =>
            ROW <= "0001"; --set row 0 high, check which columns go high to determine output
                if(COL(0) = '1') then --BC
                    tempDATA  <= "00000001"; --1
                    NS <= pulse; --move to pulse state to send interrupt signal
                elsif(COL(1) = '1') then --BA
                    tempDATA <= "00000010"; --2
                    NS <= pulse;
                elsif (COL(2) = '1') then --BE
                    tempDATA <= "00000011"; --3
                    NS <= pulse;
                else
                    tempDATA <= "11111111";
                    NS <= row1;
                end if;
        when row1 =>
            ROW <= "0010";
                if(COL(0) = '1') then --GC
                    tempDATA  <= "00000100"; --4
                    NS <= pulse;
                elsif(COL(1) = '1') then --GA
                    tempDATA <= "00000101"; --5
                    NS <= pulse;
                elsif (COL(2) = '1') then --GE
                    tempDATA <= "00000110"; --6
                    NS <= pulse;
                else
                    tempDATA <= "11111111";
                    NS <= row2;
                end if;
        when row2 =>
            ROW <= "0100";
                if(COL(0) = '1') then --FC
                    tempDATA  <= "00000111"; --7
                    NS <= pulse;
                elsif(COL(1) = '1') then --FA
                    tempDATA <= "00001000"; --8
                    NS <= pulse;
                elsif (COL(2) = '1') then --FE
                    tempDATA <= "00001001"; --9
                    NS <= pulse;
                else
                    tempDATA <= "11111111";
                    NS <= row3;
                    
                end if;
            
        when row3 =>
            ROW <= "1000";
                if(COL(0) = '1') then --DC
                    tempDATA  <= "00001010"; --* (represented by 0x0A)
                    NS <= pulse;
                elsif(COL(1) = '1') then --DA
                    tempDATA <= "00000000"; --0
                    NS <= pulse;
                elsif (COL(2) = '1') then --DE
                    tempDATA <= "00001011"; --# (represented by 0x0B)
                    NS <= pulse;
                else
                    tempDATA <= "11111111";    
                    NS <= row0;
                end if;
        when pulse => --send interrupt signal
            INT <= '1';
            ROW <= "0000";               
            NS <= hold;
                
        when hold =>
            ROW <= "1111"; --set all rows high to see if the button is still being pressed
            if(COL(0) = '1' OR COL(1) = '1' OR COL(2) = '1') then
                NS <= hold;
            else
                NS <= row0;
            end if;
            
        when others => --outer case,
            ROW <= "0000";
            NS <= row0;
        end case;
        DATA <= tempDATA;
end process;       
 
end Behavioral;
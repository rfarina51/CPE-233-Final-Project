----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/17/2018 06:03:44 PM
-- Design Name: 
-- Module Name: RAT_MCU - Behavioral
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

entity RAT_MCU is
    Port ( IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
           RESET : in STD_LOGIC;
           INT : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID : out STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB : out STD_LOGIC);
end RAT_MCU;

architecture Behavioral of RAT_MCU is
    component PC_and_MUX is
        Port ( CLK : in STD_LOGIC;
               PC_LD : in STD_LOGIC;
               PC_INC : in STD_LOGIC;
               RST : in STD_LOGIC;
               PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0);
               FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
               FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
               LAST: in STD_LOGIC_VECTOR (9 downto 0) := "1111111111";
               X : in STD_LOGIC_VECTOR (9 downto 0) := "0000000000";
               PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0) := "11");
               
    end component;
    
    component ControlUnit is
        Port ( C_FLAG : in STD_LOGIC;
               Z_FLAG : in STD_LOGIC;
               INT : in STD_LOGIC;
               RESET : in STD_LOGIC;
               OPCODE_HI_5 : in STD_LOGIC_VECTOR (4 downto 0);
               OPCODE_LO_2 : in STD_LOGIC_VECTOR (1 downto 0);
               CLK : in STD_LOGIC;
               I_SET : out STD_LOGIC;
               I_CLR : out STD_LOGIC;
               PC_LD : out STD_LOGIC;
               PC_INC : out STD_LOGIC;
               PC_MUX_SEL : out STD_LOGIC_VECTOR (1 downto 0);
               ALU_OPY_SEL : out STD_LOGIC;
               ALU_SEL : out STD_LOGIC_VECTOR (3 downto 0);
               RF_WR : out STD_LOGIC;
               RF_WR_SEL : out STD_LOGIC_VECTOR (1 downto 0);
               SP_LD : out STD_LOGIC;
               SP_INCR : out STD_LOGIC;
               SP_DECR : out STD_LOGIC;
               SCR_WE : out STD_LOGIC;
               SCR_ADDR_SEL : out STD_LOGIC_VECTOR (1 downto 0);
               SCR_DATA_SEL : out STD_LOGIC;
               FLG_C_SET : out STD_LOGIC;
               FLG_C_CLR : out STD_LOGIC;
               FLG_C_LD : out STD_LOGIC;
               FLG_Z_LD : out STD_LOGIC;
               FLG_LD_SEL : out STD_LOGIC;
               FLG_SHAD_LD : out STD_LOGIC;
               RST : out STD_LOGIC;
               IO_STRB : out STD_LOGIC);
   end component;
       
   component ALU is
        Port ( SEL : in STD_LOGIC_VECTOR (3 downto 0);
              A : in std_logic_vector (7 downto 0);
              B : in std_logic_vector (7 downto 0);
              CIN : in STD_LOGIC;
              RESULT : out STD_LOGIC_VECTOR (7 downto 0);
              C : out STD_LOGIC;
              Z : out STD_LOGIC);
   end component;
   
   component flags is
    Port ( CLK : in STD_LOGIC;
            C : in STD_LOGIC;
          FLG_C_SET : in STD_LOGIC;
          FLG_C_CLR : in STD_LOGIC;
          FLG_C_LD : in STD_LOGIC;
          Z : in STD_LOGIC;
          FLG_Z_LD : in STD_LOGIC;
          FLG_LD_SEL: in STD_LOGIC;
          FLG_SHAD_LD: in STD_LOGIC;
          C_FLAG : out STD_LOGIC;
          Z_FLAG : out STD_LOGIC);
   end component;
   
   component PROG_ROM is
        Port ( ADDRESS : in std_logic_vector(9 downto 0); 
              INSTRUCTION : out std_logic_vector(17 downto 0); 
              CLK : in std_logic);  
   end component;
   
   component Register_File is
        Port ( DIN : in STD_LOGIC_VECTOR (7 downto 0);
              ADRX : in STD_LOGIC_VECTOR (4 downto 0);
              ADRY : in STD_LOGIC_VECTOR (4 downto 0);
              RF_WR : in STD_LOGIC;
              CLK : in STD_LOGIC;
              DX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
              DY_OUT : out STD_LOGIC_VECTOR (7 downto 0));           
   end component;
   
   component ALU_MUX is
        Port ( DY_OUT_TO_ALU : in STD_LOGIC_VECTOR (7 downto 0);
              IR_TO_ALU : in STD_LOGIC_VECTOR (7 downto 0);
              ALU_OPY_SEL : in STD_LOGIC;
              ALU_MUX_OUT : out STD_LOGIC_VECTOR (7 downto 0));
   end component;
   
   component REG_MUX is
        Port ( ALU_RESULT_TO_REG : in STD_LOGIC_VECTOR (7 downto 0);
               SCR_DATA_OUT_TO_REG : in STD_LOGIC_VECTOR (7 downto 0);
               SP_DATA_OUT_TO_REG : in STD_LOGIC_VECTOR (7 downto 0);
               IN_PORT_TO_REG : in STD_LOGIC_VECTOR (7 downto 0);
               RF_WR_SEL : in STD_LOGIC_VECTOR(1 downto 0);
               REG_MUX_OUT : out STD_LOGIC_VECTOR (7 downto 0)); 
   end component;  
        
   component Stack_Pointer is 
        Port (DATA : in STD_LOGIC_VECTOR (7 downto 0);
              RST : in STD_LOGIC;
              SP_LD : in STD_LOGIC;
              SP_INCR : in STD_LOGIC;
              SP_DECR : in STD_LOGIC;
              CLK : in STD_LOGIC;
              DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0));
   end component;
   
   component Scratch_RAM is
        Port (DATA_IN : in STD_LOGIC_VECTOR (9 downto 0);
              SCR_ADDR : in STD_LOGIC_VECTOR (7 downto 0);
              SCR_WE : in STD_LOGIC;
              CLK : in STD_LOGIC;
              DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0));
   end component;
   
   component Scratch_ADDR_MUX is
        Port (DY_OUT : in STD_LOGIC_VECTOR (7 downto 0);
              FROM_IR : in STD_LOGIC_VECTOR (7 downto 0);
              SP_DOUT : in STD_LOGIC_VECTOR (7 downto 0);
              SP_DOUT_1 : in STD_LOGIC_VECTOR (7 downto 0);
              SCR_ADDR_SEL : in STD_LOGIC_VECTOR(1 downto 0);
              SCR_ADDR : out STD_LOGIC_VECTOR (7 downto 0));
   end component;
   
   component Scratch_DIN_MUX is
       Port ( DX_OUT : in STD_LOGIC_VECTOR (7 downto 0);
              PC_COUNT : in STD_LOGIC_VECTOR (9 downto 0);
              DATA_IN : out STD_LOGIC_VECTOR (9 downto 0);
              SCR_DATA_SEL : in STD_LOGIC);
   end component;
   
signal I_SET, I_CLR, PC_LD, PC_INC, ALU_OPY_SEL, RF_WR, SP_LD, SP_INCR, SP_DECR, SCR_WE, SCR_DATA_SEL, FLG_C_SET, FLG_C_CLR, FLG_C_LD, FLG_Z_LD, FLG_LD_SEL, FLG_SHAD_LD, RST, C_FLAG, Z_FLAG : std_logic := '0';
signal RF_WR_SEL, SCR_ADDR_SEL : std_logic_vector (1 downto 0) := (others => '0');
signal PC_MUX_SEL : std_logic_vector (1 downto 0) := (others => '0');
signal ALU_SEL : std_logic_vector (3 downto 0) := (others => '0');
signal PC_COUNT_TO_ADDR, DIN_PC : std_logic_vector (9 downto 0);
signal IR : std_logic_vector (17 downto 0) := (others => '0');
signal DIN_REG, DX_OUT, DY_OUT, ALU_B, ALU_RESULT : std_logic_vector (7 downto 0) := (others => '0');
signal C, Z : std_logic := '0';
signal DATA_OUT_FROM_SCR : std_logic_vector (9 downto 0) := (others => '0');
signal DATA_OUT_FROM_SP : std_logic_vector (7 downto 0) := "00000000";
signal DATA_OUT_FROM_SP_1 : std_logic_vector (7 downto 0) := std_logic_vector(unsigned(DATA_OUT_FROM_SP) - 1);
signal SCR_DATA_IN_FROM_MUX : std_logic_vector(9 downto 0) := (others => '0');
signal SCR_ADDR_FROM_MUX : std_logic_vector(7 downto 0) := (others => '0');
signal LAST : std_logic_vector (9 downto 0) := "1111111111";
signal X : std_logic_vector (9 downto 0) := "0000000000";
signal s_INT: std_logic;
signal r_INT: std_logic;


begin
SCR_DIN_MUX : Scratch_DIN_MUX port map(
    DX_OUT => DX_OUT,
    PC_COUNT => PC_COUNT_TO_ADDR,
    DATA_IN =>  SCR_DATA_IN_FROM_MUX,
    SCR_DATA_SEL => SCR_DATA_SEL);
SCR_ADDR_MUX :  Scratch_ADDR_MUX port map(
    DY_OUT => DY_OUT,
    FROM_IR => IR(7 downto 0),
    SP_DOUT => DATA_OUT_FROM_SP,
    SP_DOUT_1 => DATA_OUT_FROM_SP_1,
    SCR_ADDR_SEL => SCR_ADDR_SEL,
    SCR_ADDR => SCR_ADDR_FROM_MUX);
    
SCR_RAM : Scratch_RAM port map(
    DATA_IN => SCR_DATA_IN_FROM_MUX,
    SCR_ADDR => SCR_ADDR_FROM_MUX,
    SCR_WE => SCR_WE,
    CLK => CLK,
    DATA_OUT => DATA_OUT_FROM_SCR);
    
STK_POINTER : Stack_Pointer port map(
    DATA => DX_OUT,
    RST => RST,
    SP_LD => SP_LD,
    SP_INCR => SP_INCR,
    SP_DECR => SP_DECR,
    CLK => CLK,
    DATA_OUT => DATA_OUT_FROM_SP);
    
CONTU : ControlUnit port map (
    C_FLAG => C_FLAG, 
    Z_FLAG => Z_FLAG, 
    INT => s_INT, 
    RESET => RESET, 
    OPCODE_HI_5 => IR(17 downto 13), 
    OPCODE_LO_2 => IR(1 downto 0), 
    CLK => CLK,
    I_SET => I_SET, 
    I_CLR => I_CLR,
    PC_LD => PC_LD, 
    PC_INC =>  PC_INC, 
    PC_MUX_SEL  => PC_MUX_SEL, 
    ALU_OPY_SEL  =>  ALU_OPY_SEL, 
    ALU_SEL  => ALU_SEL, 
    RF_WR  => RF_WR, 
    RF_WR_SEL  => RF_WR_SEL, 
    SP_LD => SP_LD, 
    SP_INCR => SP_INCR, 
    SP_DECR => SP_DECR, 
    SCR_WE => SCR_WE, 
    SCR_ADDR_SEL => SCR_ADDR_SEL , 
    SCR_DATA_SEL => SCR_DATA_SEL, 
    FLG_C_SET => FLG_C_SET, 
    FLG_C_CLR => FLG_C_CLR, 
    FLG_C_LD => FLG_C_LD, 
    FLG_Z_LD => FLG_Z_LD, 
    FLG_LD_SEL => FLG_LD_SEL, 
    FLG_SHAD_LD => FLG_SHAD_LD, 
    RST => RST, 
    IO_STRB => IO_STRB);
PROGC : PC_and_MUX port map (
    CLK => CLK, 
    PC_LD => PC_LD, 
    PC_INC => PC_INC, 
    RST => RST, 
    PC_COUNT => PC_COUNT_TO_ADDR, 
    FROM_IMMED => IR (12 downto 3), 
    FROM_STACK => DATA_OUT_FROM_SCR,
    LAST => LAST,
    X => X, 
    PC_MUX_SEL => PC_MUX_SEL);
PROGR : PROG_ROM port map (
    ADDRESS => PC_COUNT_TO_ADDR, 
    INSTRUCTION => IR, 
    CLK => CLK);
REG : Register_File port map (
    DIN => DIN_REG, 
    ADRX => IR (12 downto 8), 
    ADRY => IR (7 downto 3), 
    RF_WR => RF_WR, 
    CLK => CLK, 
    DX_OUT => DX_OUT, 
    DY_OUT => DY_OUT);
FLAG : flags port map (
    C => C, 
    Z => Z, 
    FLG_C_SET  => FLG_C_SET, 
    FLG_C_CLR  => FLG_C_CLR, 
    FLG_C_LD  => FLG_C_LD, 
    FLG_Z_LD  => FLG_Z_LD,
    FLG_LD_SEL => FLG_LD_SEL,
    FLG_SHAD_LD => FLG_SHAD_LD, 
    CLK  => CLK, 
    C_FLAG  => C_FLAG, 
    Z_FLAG  => Z_FLAG);
ALOU : ALU port map (
    SEL => ALU_SEL, 
    A => DX_OUT, 
    B => ALU_B, 
    CIN => C_FLAG, 
    RESULT => ALU_RESULT, 
    C => C, 
    Z => Z);
REG_MUX1: REG_MUX port map(
    ALU_RESULT_TO_REG => ALU_RESULT,
    SCR_DATA_OUT_TO_REG => DATA_OUT_FROM_SCR(7 downto 0),
    SP_DATA_OUT_TO_REG => DATA_OUT_FROM_SP,
    IN_PORT_TO_REG => IN_PORT,
    RF_WR_SEL => RF_WR_SEL,
    REG_MUX_OUT => DIN_REG);

ALU_MUX1: ALU_MUX port map(
    DY_OUT_TO_ALU => DY_OUT,
    IR_TO_ALU => IR(7 downto 0),
    ALU_OPY_SEL => ALU_OPY_SEL,
    ALU_MUX_OUT => ALU_B);


interrupt: process(I_SET, I_CLR, s_INT, CLK) --interrupt register
begin
    if(rising_edge(CLK)) then
        if(I_CLR ='1') then
            r_INT <= '0';
        elsif(I_SET = '1') then
            r_INT <= '1';
        end if;
    end if;
end process;    
s_INT <= (r_INT AND INT);
OUT_PORT <= DX_OUT;
PORT_ID <= IR(7 downto 0);    

    
    
    
end Behavioral;

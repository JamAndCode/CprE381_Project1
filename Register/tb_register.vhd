---- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_register.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: I am so sorry, I didn't learn about arrays until too late
-- forgive me of my vhdl sins
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_register is
    generic(gCLK_HPER   : time := 50 ns);
end tb_register;

architecture behavior of tb_register is

constant cCLK_PER  : time := gCLK_HPER * 2;

component registerBoi is
  port(	i_CLK	    	: in std_logic;
	i_WriteEnable	: in std_logic;
	i_RST		: in std_logic;
	i_ReadReg1	: in std_logic_vector(4 downto 0);
	i_ReadReg2	: in std_logic_vector(4 downto 0);
	i_WriteReg	: in std_logic_vector(4 downto 0);
	i_WriteData	: in std_logic_vector(31 downto 0);
	o_ReadData1	: out std_logic_vector(31 downto 0);
	o_ReadData2 	: out std_logic_vector(31 downto 0));
end component;

--signals BM (before mux)
  signal s_CLK  	: std_logic;
  signal s_RST 		: std_logic;
  signal s_WriteEnable 	: std_logic := '0'; 
  signal s_ReadReg1	: std_logic_vector(4 downto 0) := "00000";
  signal s_ReadReg2 	: std_logic_vector(4 downto 0) := "00000";
  signal s_WriteReg 	: std_logic_vector(4 downto 0) := "00000";
  signal s_ReadData1 	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_ReadData2 	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal s_WriteData 	: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
--signals AM (After mux)


begin

DUT0: registerBoi
  port map(	i_CLK	    	=> s_CLK,
		i_WriteEnable	=> s_WriteEnable,
		i_RST		=> s_RST,
		i_ReadReg1	=> s_ReadReg1,
		i_ReadReg2	=> s_ReadReg2,
		i_WriteReg	=> s_WriteReg,
		i_WriteData	=> s_WriteData,
		o_ReadData1	=> s_ReadData1,
		o_ReadData2	=> s_ReadData2);

  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_Testy: process
  begin
    -- Reset
    s_RST <= '1';
    s_WriteEnable  <= '0';
    s_WriteReg   <= "00010";
    s_ReadReg1   <= "00011";
    s_ReadReg2   <= "00010";
    s_WriteData   <= x"FFFF0000";
    wait for cCLK_PER;

    s_RST <= '0';
    s_WriteEnable  <= '1';
    s_WriteReg   <= "00010";
    s_ReadReg1   <= "00011";
    s_ReadReg2   <= "00010";
    s_WriteData   <= x"01111111";
    wait for cCLK_PER;  

    s_RST <= '0';
    s_WriteEnable  <= '1';
    s_WriteReg   <= "00010";
    s_ReadReg1   <= "00011";
    s_ReadReg2   <= "00101";
    s_WriteData   <= x"0aaaaaaa";
    wait for cCLK_PER;  

    s_RST <= '0';
    s_WriteEnable  <= '1';
    s_WriteReg   <= "00010";
    s_ReadReg1   <= "00101";
    s_ReadReg2   <= "00010";
    s_WriteData   <= x"0bbbbbbb";
    wait for cCLK_PER;  

    s_RST <= '0';
    s_WriteEnable  <= '1';
    s_WriteReg   <= "00010";
    s_ReadReg1   <= "00011";
    s_ReadReg2  <= "00010";
    s_WriteData   <= x"FFFF0000";
    wait for cCLK_PER;  

    wait;
  end process;

  
end behavior;

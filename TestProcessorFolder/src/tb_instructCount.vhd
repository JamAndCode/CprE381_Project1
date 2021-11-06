-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_instructCount.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for the PC in the MIPS processor
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_instructCount is
   generic(gCLK_HPER	: time := 50 ns);
end tb_instructCount;

architecture behavior of tb_instructCount is

constant cCLK_PER	: time := gCLK_HPER * 2;

component instructCount is
  port (iCLK		: in std_logic;
	iRST		: in std_logic;
	iInstAddr 	: in std_logic_vector(31 downto 0);
	o_F		: out std_logic_vector(31 downto 0));
end component;

signal s_CLK, s_RST		: std_logic;
signal s_InstAddr, s_F		: std_logic_vector(31 downto 0);

begin
proc: instructCount
  port map(iInstAddr	=> s_InstAddr,
	iCLK		=> s_CLK,
	iRST		=> s_RST,
	o_F		=> s_F);

  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;

  P_TB: process
  begin

    --reset
    s_InstAddr <= "11111111111111111111111111111111";
    s_RST <= '1';
    wait for cCLK_PER;

    --Address is FFFFFFF
    s_InstAddr <= "11111111111111111111111111111111";
    s_RST <= '0';
    wait for cCLK_PER;

    --reset
    s_InstAddr <= "11111111111111111111111111111111";
    s_RST <= '1';
    wait for cCLK_PER;

    --Address is AAAAAAAA
    s_InstAddr <= "10101010101010101010101010101010";
    s_RST <= '0';
    wait for cCLK_PER;

    --Address is FFFFFFF
    s_InstAddr <= "11111111111111111111111111111111";
    s_RST <= '0';
    wait for cCLK_PER;

  end process;
  
end behavior;
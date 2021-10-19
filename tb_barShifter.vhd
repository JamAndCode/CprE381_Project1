-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_barShifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for the barrel shifter with 4x1 multiplexor
-- NOTE: DRAFT ONLY, this currently only can shift bits by 7 either direction
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_barShifter is
end tb_barShifter;

architecture behavior of tb_barShifter is

component barShifter is
generic(N : integer := 32);
  port  (i_A :	in std_logic_vector(N-1 downto 0);
	i_LorR	: in std_logic;
	i_Ss 	: in std_logic_vector(4 downto 0);
	o_F : 	out std_logic_vector(N-1 downto 0));
end component;

signal s_A, s_F		: std_logic_vector(31 downto 0);
signal s_LorR		: std_logic;
signal s_S		: std_logic_vector(4 downto 0);

begin

proc: barShifter
  port map	(i_A	=> s_A,
		i_LorR	=> s_LorR,
		i_Ss	=> s_S,
		o_F	=> s_F); 
	
  P_TB: process
  begin

    --Shift left 1
	s_A 	<= "11111111111111111111111111111111";
	s_LorR	<= '0';
	s_S	<= "00001";
    wait for 100 ns;

    --Shift right 1
	s_A 	<= "11111111111111111111111111111111";
	s_LorR	<= '1';
	s_S	<= "00001";
    wait for 100 ns;

    --Shift left 2
	s_A 	<= "11111111111111111111111111111111";
	s_LorR	<= '0';
	s_S	<= "00010";
    wait for 100 ns;

    --Shift right 2
	s_A 	<= "11111111111111111111111111111111";
	s_LorR	<= '1';
	s_S	<= "00010";
	wait for 100 ns;

    --Shift left 4
	s_A 	<= "11111111111111111111111111111111";
	s_LorR	<= '0';
	s_S	<= "00100";
    wait for 100 ns;

    --Shift right 4
	s_A 	<= "11111111111111111111111111111111";
	s_LorR	<= '1';
	s_S	<= "00100";
	wait for 100 ns;

    --Shift left 8
	s_A 	<= "11111111111111111111111111111111";
	s_LorR	<= '0';
	s_S	<= "01000";
    wait for 100 ns;

    --Shift right 8
	s_A 	<= "11111111111111111111111111111111";
	s_LorR	<= '1';
	s_S	<= "01000";
	wait for 100 ns;

    --Shift left 16
	s_A 	<= "11111111111111111111111111111111";
	s_LorR	<= '0';
	s_S	<= "10000";
    wait for 100 ns;

    --Shift right 16
	s_A 	<= "11111111111111111111111111111111";
	s_LorR	<= '1';
	s_S	<= "10000";
	wait for 100 ns;

    --Shift left 31
	s_A 	<= "11111111111111111111111111111111";
	s_LorR	<= '0';
	s_S	<= "11111";
    wait for 100 ns;

    --Shift right 31
	s_A 	<= "11111111111111111111111111111111";
	s_LorR	<= '1';
	s_S	<= "11111";
	wait for 100 ns;

  end process;
  
end behavior;
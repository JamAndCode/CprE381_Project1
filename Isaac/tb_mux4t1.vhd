-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_mux4t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for the 4 to 1 multiplexor
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mux4t1 is
end tb_mux4t1;

architecture behavior of tb_mux4t1 is

component mux4t1 is
  generic(N : integer := 32);
  port (i_S	: in std_logic_vector(1 downto 0);
	i_D	: in std_logic_vector(3 downto 0);
	o_F	: out std_logic);
end component;

signal s_S	: std_logic_vector(1 downto 0);
signal s_D	: std_logic_vector(3 downto 0);
signal s_F	: std_logic;

begin

proc: mux4t1
  port map	(i_S	=> s_S,
		i_D	=> s_D,
		o_F	=> s_F); 
	
  P_TB: process
  begin

    --Choose first in mux
	s_S	<= "00";
	s_D	<= "0001";
    wait for 100 ns;

	--choose second
	s_S	<= "10";
	s_D	<= "0010";
    wait for 100 ns;

	--choose third
	s_S	<= "01";
	s_D	<= "0100";
    wait for 100 ns;
	s_S	<= "11";
	s_D	<= "1000";
	--choose fourth

    wait for 100 ns;
    wait;
  end process;
  
end behavior;
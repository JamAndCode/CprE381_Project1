-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_overflowDetect.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for the overflow detector connected to the Adder
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_overflowDetect is
end tb_overflowDetect;

architecture behavior of tb_overflowDetect is

component overflowDetect is
  port (i_RS		: in std_logic; --NOTE: these are the MSB of RS, RT, and the adder output
	i_RT		: in std_logic;
	i_ADDresult	: in std_logic;
	o_Overflow	: out std_logic);
end component;

signal s_RS, s_RT, s_ADDresult, s_Overflow	: std_logic;

begin
proc: overflowDetect
  port map	(i_RS	=> s_RS,
		i_RT	=> s_RT,
		i_ADDresult	=> s_ADDresult,
		o_Overflow	=> s_Overflow); 
	
  P_TB: process
  begin
    --no overflow since signs are opposite
	s_RS		<= '1';
	s_RT		<= '0';
	s_ADDresult	<= '1';
    wait for 100 ns;

    --no overflow since result is same as signs
	s_RS		<= '1';
	s_RT		<= '1';
	s_ADDresult	<= '1';
    wait for 100 ns;

    --no overflow since result is same as signs
	s_RS		<= '0';
	s_RT		<= '0';
	s_ADDresult	<= '0';
    wait for 100 ns;

    --overflow since result is opposite of signs
	s_RS		<= '1';
	s_RT		<= '1';
	s_ADDresult	<= '0';
    wait for 100 ns;

  end process;
end behavior;
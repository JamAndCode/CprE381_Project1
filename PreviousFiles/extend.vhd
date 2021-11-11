-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- extend.vhd
----------------------------------------------------------------------------
-- DESCRIPTION: This file is both the extenders needed for the lab, with a selecter
----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity extend is
  port( i_A		: in std_logic_vector(15 downto 0);
	i_S		: in std_logic;
	o_F		: out std_logic_vector(31 downto 0));
end extend;

architecture dataflow of extend is

signal use_bits	: std_logic;
begin
	with i_S select
	use_bits <= '0' when '0',
		i_A(15) when others;

	tophalf: for i in 31 downto 16 generate
	begin
		o_F(i) <= use_bits;
	end generate;

	bottom: for i in 15 downto 0 generate
	begin
		o_F(i)	<= i_A(i);	--Just taking the input since already 16 bits
	end generate;
end dataflow;

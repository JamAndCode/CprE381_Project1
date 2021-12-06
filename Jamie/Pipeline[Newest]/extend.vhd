-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- extend.vhd
------------------------------------------------------------------------------------
-- DESCRIPTION: This file is both the extenders needed for the lab, with a selecter
------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity extend is
  port( i_A		: in std_logic_vector(15 downto 0);
	i_Sign		: in std_logic;
	o_F		: out std_logic_vector(31 downto 0));
end extend;

architecture dataflow of extend is
begin
	o_F(15 downto 0) <= i_A;
	signBits: for i in 16 to 31 generate
		o_F(i) <= i_Sign and i_A(15);
	end generate;
	
end dataflow;

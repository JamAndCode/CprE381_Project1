-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux4t1.vhd
----------------------------------------------------------------------------
-- DESCRIPTION: a 4 to 1 mulitplexor
----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity mux4t1 is
  generic(N : integer := 32);
  port (i_S	: in std_logic_vector(1 downto 0);
	i_D	: in std_logic_vector(3 downto 0);
	o_F	: out std_logic);
end mux4t1;

architecture dataflow of mux4t1 is
begin
	o_F <= (not i_S(0) and not i_S(1) and i_D(0)) or (not i_S(0) and i_S(1) and i_D(1)) or (i_S(0) and not i_S(1) and i_D(2)) or (i_S(0) and i_S(1) and i_D(3));
end dataflow;
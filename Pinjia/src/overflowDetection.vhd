-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- overflowDetect.vhd
----------------------------------------------------------------------------
-- DESCRIPTION: a detector for overflow, to be attached to the ALU
----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity overflowDetect is
  port (i_RS		: in std_logic; --NOTE: these are the MSB of RS, RT, and the adder output
	i_RT		: in std_logic;
	i_ADDresult	: in std_logic;
	o_Overflow	: out std_logic);
end overflowDetect;

architecture dataflow of overflowDetect is
begin
	o_Overflow <= (i_RS and i_RT and not i_ADDresult) or (not i_RS and not i_RT and i_ADDresult);
end dataflow;

---
--Hazard detection and avoider
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity hazards is
  port (i_Branch	: std_logic;
	i_JUmp		: std_logic;
	

	inst_IDEX	: std_logic_vector(31 downto 0);
	inst_EXMEM	: std_logic_vector(31 downto 0);
	flush_IFID	: std_logic;
	stall_IFID	: std_logic;
	flush_IDEX	: std_logic;
	stall_IDEX	: std_logic;
	stall_PC	: std_logic);
end entity;

architecture dataflow of hazards is
begin

end dataflow;
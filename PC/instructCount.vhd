-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- instructCount.vhd
----------------------------------------------------------------------------
-- DESCRIPTION: an N-bit barrel shifter using mux
----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity instructCount is
  generic(N : integer := 32);
  port (iCLK		: in std_logic;
	iRST		: in std_logic;
	iInstAddr 	: in std_logic_vector(N-1 downto 0);
	o_F		: out std_logic_vector(N-1 downto 0));
end instructCount;

architecture behavioral of instructCount is
begin
proc : process(iCLK)
begin
	if rising_edge(iCLK) then
		if iRST = '0' then
			o_F	<= iInstAddr;
		elsif iRST = '1' then
			o_F	<= (others => '0');
		end if;
	end if;
end process;
end behavioral;
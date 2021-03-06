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
	i_Enable	: in std_logic; --enable jumps and such
	iInstAddr 	: in std_logic_vector(N-1 downto 0);
	o_F		: out std_logic_vector(N-1 downto 0));
end instructCount;

architecture structure of instructCount is
  signal s_InstAddr     : std_logic_vector(N-1 downto 0);
  signal s_F   		: std_logic_vector(N-1 downto 0); 

begin

  o_F <= s_F;
  
with i_Enable select
	s_InstAddr <= iInstAddr when '1',
	s_F when others;

  process (iCLK, iRST)
  begin
    if (iRST = '1') then
      s_F <= x"00400000";
    elsif (rising_edge(iCLK)) then
      s_F <= s_InstAddr;
    end if;

  end process;
  
end structure;


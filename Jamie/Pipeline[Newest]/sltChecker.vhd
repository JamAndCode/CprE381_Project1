library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity sltChecker is
  port (i_Reg1      	: in std_logic_vector(31 downto 0);
        i_Reg2      	: in std_logic_vector(31 downto 0);
        o_Difference    : out std_logic_vector(31 downto 0));
end entity;

architecture behavior of sltChecker is
signal s_Reg1, s_Reg2	: signed(31 downto 0);

begin
s_Reg1	<= signed(i_Reg1);
s_Reg2	<= signed(i_Reg2);
process(s_Reg1, s_Reg2)
begin
	if (s_Reg1 > s_Reg2) then 
		o_Difference <= x"00000000";
	else
		o_Difference <= x"00000001";
	end if;
end process;
end behavior;
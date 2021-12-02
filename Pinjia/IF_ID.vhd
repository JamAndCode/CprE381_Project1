library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.numeric_std_unsigned.all;

entity IF_FD is(
Hazard_Detection:	in std_logic;
I_Inst:	in std_logic_vector(31 downto 0);--write back register address,S_Inst
O_Inst:	out std_logic_vector(31 downto 0);
I_jumpTop:	in std_logic_vector(31 downto 0);
O_jumpTop:	out std_logic_vector(31 downto 0);


)
architecture of IF_FD is(
DUT0:process(Hazard_Detection)
begin
	if(Hazard_Detection=="1") then
	O_Inst<=x"00000000";
	O_jump_Top<=x"00000000";
	else
	O_Inst<=I_Inst;
	O_jumpTop<=I_jumpTop;
	end if;
end process;


)
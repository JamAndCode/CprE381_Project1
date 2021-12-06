library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity branchChecker is
  port (i_ALUzero      : in std_logic;
        i_Control      : in std_logic_vector(1 downto 0);
        o_Branch    : out std_logic);
end entity;

architecture behavior of branchChecker is
begin
process(i_ALUzero, i_Control)
begin
	if (i_Control = "00") then 
		o_Branch <= '0';
	elsif (i_Control = "01") then
		if (i_ALUzero = '0') then
			o_Branch <= '0';
		else
			o_Branch <= '1';
		end if;
	else
		if (i_ALUzero = '0') then
			o_Branch <= '1';
		else
			o_Branch <= '0';
		end if;
	end if;
end process;
end behavior;

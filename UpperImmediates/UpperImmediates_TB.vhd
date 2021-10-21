--use "vsim -novopt UpperImmediates_TB -suppress 12110" to run test bench
--use "add wave sim:/upperimmediates_tb/*" to add wave
--use "run 100" to view results

library IEEE;
use IEEE.std_logic_1164.all;

entity UpperImmediates_TB is
end UpperImmediates_TB;

architecture dataflow of UpperImmediates_TB is

component UpperImmediates
port(largeVar	: in  std_logic_vector(31 downto 0);
     lowerbits	: out std_logic_vector(15 downto 0);
     upperbits	: out std_logic_vector(15 downto 0));
end component;

signal lowerbits, upperbits : std_logic_vector(15 downto 0);
signal largeVar : std_logic_vector(31 downto 0);

begin

UpperImmediate1 : UpperImmediates
port map(
	largeVar => largeVar,
	lowerbits => lowerbits,
	upperbits => upperbits);

process
begin

largeVar <= x"00AA00AA";
wait for 100 ns;

largeVar <= x"0FF0FF0F";
wait for 100 ns;

end process;

end dataflow;
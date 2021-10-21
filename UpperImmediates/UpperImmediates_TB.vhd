--use "vsim -novopt UpperImmediates_TB -suppress 12110" to run test bench
--use "add wave sim:/UpperImmediates_TB/*" to add wave
--use "run 100" to view results

library IEEE;
use IEEE.std_logic_1164.all;

entity UpperImmediates_TB is
end UpperImmediates_TB;

architecture dataflow of UpperImmediates_TB is

component UpperImmediates
port(largeVariable	: in  std_logic_vector(15 downto 0);
     lower8bitsVariable	: out std_logic_vector(7 downto 0);
     upper8bitsVariable	: out std_logic_vector(7 downto 0));
end component;

signal lower8bitsVariable, upper8bitsVariable : std_logic_vector(7 downto 0);
signal largeVariable : std_logic_vector(15 downto 0);

begin

UpperImmediate1 : UpperImmediates
port map(
	largeVariable => largeVariable,
	lower8bitsVariable => lower8bitsVariable,
	upper8bitsVariable => upper8bitsVariable);

process
begin

largeVariable <= x"00AA";
wait for 100 ns;

largeVariable <= x"0FF0";
wait for 100 ns;

end process;

end dataflow;
library IEEE;
use IEEE.std_logic_1164.all;

entity UpperImmediates is
port(largeVariable	: in  std_logic_vector(15 downto 0);
     lower8bitsVariable	: out std_logic_vector(7 downto 0);
     upper8bitsVariable	: out std_logic_vector(7 downto 0));
end UpperImmediates;

architecture dataflow of UpperImmediates is

begin
lower8bitsVariable <= largeVariable(7 downto 0);     --Store the lower 8 bits of largeVariable
upper8bitsVariable <= largeVariable(15 downto 8);    --Store the upper 8 bits of largerVatiable
end dataflow;
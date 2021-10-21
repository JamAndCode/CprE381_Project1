library IEEE;
use IEEE.std_logic_1164.all;

entity UpperImmediates is
port(largeVariable	: in  std_logic_vector(31 downto 0);
     lower8bitsVariable	: out std_logic_vector(15 downto 0);
     upper8bitsVariable	: out std_logic_vector(15 downto 0));
end UpperImmediates;

architecture dataflow of UpperImmediates is

begin
lower16bitsVariable <= largeVariable(15 downto 0);     --Store the lower 16 bits of largeVariable
upper8bitsVariable <= largeVariable(31 downto 16);    --Store the upper 16 bits of largerVatiable
end dataflow;

library IEEE;
use IEEE.std_logic_1164.all;

entity UpperImmediates is
port(largeVar	: in  std_logic_vector(31 downto 0); 
     lowerbits	: out std_logic_vector(15 downto 0); 
     upperbits	: out std_logic_vector(15 downto 0)); 
end UpperImmediates;

architecture dataflow of UpperImmediates is

begin
lowerbits <= largeVar(15 downto 0);     --Store the lower 16 bits of largeVar
upperbits <= largeVar(31 downto 16);    --Store the upper 16 bits of largeVar
end dataflow;
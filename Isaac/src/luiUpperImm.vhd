library IEEE;
use IEEE.std_logic_1164.all;

entity luiUpperImmediates is
port(i_A	: in  std_logic_vector(15 downto 0); 
     o_F	: out std_logic_vector(31 downto 0)); 
end luiUpperImmediates;

architecture dataflow of luiUpperImmediates is

begin
o_F(31 downto 16) <= i_A;
o_F(15 downto 0) <= "0000000000000000";

end dataflow;
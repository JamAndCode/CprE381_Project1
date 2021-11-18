library IEEE;
use IEEE.std_logic_1164.all;

entity and32N is
generic(N : integer := 32);
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));

end and32N;

architecture dataflow of and32N is
begin

  o_F <= i_A and i_B;
  
end dataflow;
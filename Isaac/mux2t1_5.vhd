library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_5 is
  generic(N : integer := 5);
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(4 downto 0);
       i_D1         : in std_logic_vector(4 downto 0);
       o_O          : out std_logic_vector(4 downto 0));

end mux2t1_5;

architecture structural of mux2t1_5 is

  component mux2t1 is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic;
         i_D1                 : in std_logic;
         o_O                  : out std_logic);
  end component;

begin


  Mux_N: for i in 0 to 4 generate
    MUXI: mux2t1 port map(
              i_S      => i_S,      
              i_D0     => i_D0(i),  
              i_D1     => i_D1(i),  
              o_O      => o_O(i));  
  end generate Mux_N;
  
end structural;

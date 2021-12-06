-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- muxALU4t1.vhd
----------------------------------------------------------------------------
-- DESCRIPTION: i stopped doing these for awhile for "teamwork"
----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all; 

entity muxALU4t1 is
  generic(N : integer := 32);
  port (i_S	: in std_logic_vector(1 downto 0); 
	i_0	: in std_logic_vector(31 downto 0);
	i_1	: in std_logic_vector(31 downto 0);
	i_2	: in std_logic_vector(31 downto 0);
	i_3	: in std_logic_vector(31 downto 0);
	o_F	: out std_logic_vector(31 downto 0));
end muxALU4t1;

architecture structural of muxALU4t1 is

component mux2t1_N is
  generic(N : integer := 32);
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;

signal layer1MUX1, layer1MUX2	: std_logic_vector(N-1 downto 0);

begin
	mlayer1MUX1: mux2t1_N
	port MAP(i_S         => i_S(0),
       		i_D0         => i_0,
       		i_D1         => i_1,
       		o_O          => layer1MUX1);

	mlayer1MUX2: mux2t1_N
	port MAP(i_S         => i_S(0),
       		i_D0         => i_2,
       		i_D1         => i_3,
       		o_O          => layer1MUX2);

	layer2: mux2t1_N
	port MAP(i_S         => i_S(1),
       		i_D0         => layer1MUX1,
       		i_D1         => layer1MUX2,
       		o_O          => o_F);
end structural;
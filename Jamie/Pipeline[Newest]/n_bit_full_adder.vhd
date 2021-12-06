library IEEE;
use IEEE.std_logic_1164.ALL;

entity n_bit_full_adder is
   generic(N : integer := 32);
   port(i_A	: in std_logic_vector(N-1 downto 0);
	i_B	: in std_logic_vector(N-1 downto 0);
	i_Cin	: in std_logic;
	o_Cout	: out std_logic;
	o_Sum	: out std_logic_vector(N-1 downto 0));
end n_bit_full_adder;

architecture structure of n_bit_full_adder is

component full_adder is
   port(i_A	: in std_logic;
	i_B	: in std_logic;
	i_Cin	: in std_logic;
	o_Cout	: out std_logic;
	o_Sum	: out std_logic);
end component;

signal carry : std_logic_vector(N-2 downto 0);

begin

full_adder_0 : full_adder
   port map(i_A => i_A(0),
	    i_B => i_B(0),
	    i_Cin => i_Cin,
	    o_Cout => carry(0),
	    o_Sum => o_Sum(0));

G1: for i in 1 to N-2 generate
   full_adder_i : full_adder
      port map(i_A => i_A(i),
	       i_B => i_B(i),
	       i_Cin => carry(i-1),
	       o_Cout => carry(i),
	       o_Sum => o_Sum(i));
end generate;

full_adder_N : full_adder
   port map(i_A => i_A(N-1),
	    i_B => i_B(N-1),
	    i_Cin => carry(N-2),
	    o_Cout => o_Cout,
	    o_Sum => o_Sum(N-1));

end structure;
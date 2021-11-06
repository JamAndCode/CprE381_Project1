library IEEE;
use IEEE.std_logic_1164.ALL;

entity full_adder is
   port(i_A	: in std_logic;
	i_B	: in std_logic;
	i_Cin	: in std_logic;
	o_Cout	: out std_logic;
	o_Sum	: out std_logic);
end full_adder;

architecture structure of full_adder is

component andg2
   port(i_A	: in std_logic;
	i_B	: in std_logic;
	o_F	: out std_logic);
end component;

component org2
   port(i_A	: in std_logic;
	i_B	: in std_logic;
	o_F	: out std_logic);
end component;

component xorg2
   port(i_A	: in std_logic;
	i_B	: in std_logic;
	o_F	: out std_logic);
end component;

signal xor_1_out, and_1_out, and_2_out : std_logic;

begin

xor_1 : xorg2
   port map(i_A => i_A,
	    i_B => i_B,
	    o_F => xor_1_out);

xor_2 : xorg2
   port map(i_A => xor_1_out,
	    i_B => i_Cin,
	    o_F => o_Sum);

and_1 : andg2
   port map(i_A => i_A,
	    i_B => i_B,
	    o_F => and_1_out);

and_2 : andg2
   port map(i_A => i_Cin,
	    i_B => xor_1_out,
	    o_F => and_2_out);

or_1 : org2
   port map(i_A => and_2_out,
	    i_B => and_1_out,
	    o_F => o_Cout);
end structure;
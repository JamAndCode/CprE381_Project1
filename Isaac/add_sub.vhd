library IEEE;
use IEEE.std_logic_1164.all;
 
entity add_sub is
generic(N : integer := 32);
port(i_A	: in std_logic_vector(N-1 downto 0);
     i_B 	: in std_logic_vector(N-1 downto 0); 	
     S		: in std_logic;
     o_Sum	: out std_logic_vector(N-1 downto 0);
     o_Cout	: out std_logic);
end add_sub;

architecture structure of add_sub is

component OnesComplementor is
port(i_A	: in std_logic_vector(N-1 downto 0);
     o_F	: out std_logic_vector(N-1 downto 0));
end component;

component mux2t1_N is
port(i_D0, i_D1	: in std_logic_vector(N-1 downto 0); 
     i_S	: in std_logic;
     o_O  	: out std_logic_vector(N-1 downto 0));
end component;

component n_bit_full_adder is
port(i_A 	: in std_logic_vector(N-1 downto 0); 
     i_B 	: in std_logic_vector(N-1 downto 0); 		 
     i_Cin 	: in std_logic; 
     o_Sum 	: out std_logic_vector(N-1 downto 0); 
     o_Cout 	: out std_logic);	
end component;

signal complement, sel_in, sel_value, post_op: std_logic_vector(N-1 downto 0);

begin

inv : OnesComplementor
port map(i_A => sel_value,
         o_F => complement); 

mux : mux2t1_N
port map(i_D0  => i_A,
         i_D1  => i_B,
         i_S  => S,
  	 o_O  => sel_in);


adder : n_bit_full_adder
port map(i_A => i_A,
         i_B => i_B,
         i_Cin => S,
         o_Sum => o_Sum,
         o_Cout => o_Cout);

end structure;
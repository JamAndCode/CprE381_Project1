-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_decode_5to32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench of the created n_bit add-sub
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_decode_5to32 is
end tb_decode_5to32;

architecture behaviour of tb_decode_5to32 is

    component decode_5to32 is
  	port(	i_Enable	: in std_logic;
		i_A		: in std_logic_vector(4 downto 0);
		o_F		: out std_logic_vector(31 downto 0));
        end component;

    --inputs
    signal s_Enable : std_logic := '1';
    signal s_A  : std_logic_vector(4 downto 0) := "00000";
    --output
    signal s_F : std_logic_vector(31 downto 0);

    begin

	DUT0 : decode_5to32
	port map(i_Enable => s_Enable,
		i_A	=> s_A,
		o_F	=> s_F);
	
	P_TEST_CASES: process
	begin
		s_A	<= "00000";
		wait for 100 ns;
		s_A	<= "00001";
		wait for 100 ns;
		s_A	<= "00010";
		wait for 100 ns;
		s_A	<= "00011";
		wait for 100 ns;
		s_A	<= "00100";
		wait for 100 ns;
		s_A	<= "00101";
		wait for 100 ns;
		s_A	<= "00110";
		wait for 100 ns;
		s_A	<= "00111";
		wait for 100 ns;
		s_A	<= "01000";
		wait for 100 ns;
		s_A	<= "01001";
		wait for 100 ns;
		s_A	<= "01010";
		wait for 100 ns;
		s_A	<= "01011";
		wait for 100 ns;
		s_A	<= "01100";
		wait for 100 ns;
		s_A	<= "01101";
		wait for 100 ns;
		s_A	<= "01110";
		wait for 100 ns;
		s_A	<= "01111";
		wait for 100 ns;
		s_A	<= "10000";
		wait for 100 ns;
		s_A	<= "10001";
		wait for 100 ns;
		s_A	<= "10010";
		wait for 100 ns;
		s_A	<= "10011";
		wait for 100 ns;
		s_A	<= "10100";
		wait for 100 ns;
		s_A	<= "10101";
		wait for 100 ns;
		s_A	<= "10110";
		wait for 100 ns;
		s_A	<= "10111";
		wait for 100 ns;
		s_A	<= "11000";
		wait for 100 ns;
		s_A	<= "11001";
		wait for 100 ns;
		s_A	<= "11010";
		wait for 100 ns;
		s_A	<= "11011";
		wait for 100 ns;
		s_A	<= "11100";
		wait for 100 ns;
		s_A	<= "11101";
		wait for 100 ns;
		s_A	<= "11110";
		wait for 100 ns;
		s_A	<= "11111";
		wait for 100 ns;

	end process;

end behaviour;
-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- muxALU.vhd
----------------------------------------------------------------------------
-- DESCRIPTION: i stopped doing these for awhile for "teamwork"
----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity muxALU is
  generic(N : integer := 32);
  port (i_S	: in std_logic_vector(3 downto 0); --select pins, matches those of ALU control
	i_0	: in std_logic_vector(31 downto 0);
	i_1	: in std_logic_vector(31 downto 0);
	i_2	: in std_logic_vector(31 downto 0);
	i_3	: in std_logic_vector(31 downto 0);
	i_4	: in std_logic_vector(31 downto 0);
	i_5	: in std_logic_vector(31 downto 0);
	i_6	: in std_logic_vector(31 downto 0);
	i_7	: in std_logic_vector(31 downto 0);
	i_8	: in std_logic_vector(31 downto 0);
	i_9	: in std_logic_vector(31 downto 0);
	i_10	: in std_logic_vector(31 downto 0);
	i_11	: in std_logic_vector(31 downto 0);
	i_12	: in std_logic_vector(31 downto 0);
	i_13	: in std_logic_vector(31 downto 0);
	i_14	: in std_logic_vector(31 downto 0);
	i_15	: in std_logic_vector(31 downto 0);
	o_F	: out std_logic_vector(31 downto 0));
end muxALU;

architecture structural of muxALU is

component muxALU4t1 is
  generic(N : integer := 32);
  port (i_S	: in std_logic_vector(1 downto 0); 
	i_0	: in std_logic_vector(31 downto 0);
	i_1	: in std_logic_vector(31 downto 0);
	i_2	: in std_logic_vector(31 downto 0);
	i_3	: in std_logic_vector(31 downto 0);
	o_F	: out std_logic_vector(31 downto 0));
end component;

--signals
signal s_Layer1MUX1, s_Layer1MUX2, s_Layer1MUX3, s_Layer1MUX4	: std_logic_vector(31 downto 0);

begin

	layer1MUX1: muxALU4t1
  	port MAP(i_S	=> i_S(1 downto 0),
		i_0	=> i_0,
		i_1	=> i_1, 
		i_2	=> i_2,
		i_3	=> i_3,
		o_F	=> s_Layer1MUX1);

	layer1MUX2: muxALU4t1
  	port MAP(i_S	=> i_S(1 downto 0),
		i_0	=> i_4,
		i_1	=> i_5, 
		i_2	=> i_6,
		i_3	=> i_7,
		o_F	=> s_Layer1MUX2);

	layer1MUX3: muxALU4t1
  	port MAP(i_S	=> i_S(1 downto 0),
		i_0	=> i_8,
		i_1	=> i_9, 
		i_2	=> i_10,
		i_3	=> i_11,
		o_F	=> s_Layer1MUX3);

	layer1MUX4: muxALU4t1
  	port MAP(i_S	=> i_S(1 downto 0),
		i_0	=> i_12,
		i_1	=> i_13, 
		i_2	=> i_14,
		i_3	=> i_15,
		o_F	=> s_Layer1MUX4);

	layer2MUX: muxALU4t1
  	port MAP(i_S	=> i_S(3 downto 2),
		i_0	=> s_Layer1MUX1,
		i_1	=> s_Layer1MUX2, 
		i_2	=> s_Layer1MUX3,
		i_3	=> s_Layer1MUX4,
		o_F	=> o_F);

end structural;
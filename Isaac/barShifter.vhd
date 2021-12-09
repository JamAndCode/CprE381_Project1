-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- barShifter.vhd
----------------------------------------------------------------------------
-- DESCRIPTION: an N-bit barrel shifter using mux
----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity barShifter is
  generic(N : integer := 32);
  port (i_A 	: in std_logic_vector(N-1 downto 0);
	i_LorR	: in std_logic;
	i_Log	: in std_logic;
	i_Ss 	: in std_logic_vector(4 downto 0);
	o_F 	: out std_logic_vector(N-1 downto 0));
end barShifter;

architecture mixed of barShifter is

--MUX
  component mux4t1 is
  port (i_S	: in std_logic_vector(1 downto 0);
	i_D	: in std_logic_vector(3 downto 0);
	o_F	: out std_logic);
  end component;

--Signal between layer 1 and 2
signal s_B	: std_logic_vector(N-1 downto 0);
--Signal between layer 2 and 3
signal s_D	: std_logic_vector(N-1 downto 0);
--signal between layer 3 and 4
signal s_E	: std_logic_vector(N-1 downto 0);
--signal between layer 4 and 5
signal s_G	: std_logic_vector(N-1 downto 0);

begin
---------------------------------------------------------------------------
--First MUX in first layer
	startMUX : mux4t1
	port MAP(i_S(0)	=> i_LorR,
		i_S(1)	=> i_Ss(0),
		i_D(0)	=> i_A(0),
		i_D(1)	=> '0',
		i_D(2)	=> i_A(0),
		i_D(3)	=> i_A(1),
		o_F	=> s_B(0));
--First layer
	layer1 : for i in N-2 downto 1 generate
	begin
		mux1 : mux4t1
		port MAP(i_S(0)	=> i_LorR,
			i_S(1)	=> i_Ss(0),
			i_D(0)	=> i_A(i),
			i_D(1)	=> i_A(i-1),
			i_D(2)	=> i_A(i),
			i_D(3)	=> i_A(i+1),
			o_F	=> s_B(i));
	end generate;
--last mux in first layer
	endMUX1 : mux4t1
		port MAP(i_S(0)	=> i_LorR,
			i_S(1)	=> i_Ss(0),
			i_D(0)	=> i_A(31),
			i_D(1)	=> i_A(30),
			i_D(2)	=> i_A(31),
			i_D(3)	=> '0',
			o_F	=> s_B(31));
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--First and Second MUX in second layer
	secondMux1 : mux4t1
	port MAP(i_S(0)	=> i_LorR,
		i_S(1)	=> i_Ss(1),
		i_D(0)	=> s_B(0),
		i_D(1)	=> '0',
		i_D(2)	=> s_B(0),
		i_D(3)	=> s_B(2),
		o_F	=> s_D(0));

	secondMux2 : mux4t1
	port MAP(i_S(0)	=> i_LorR,
		i_S(1)	=> i_Ss(1),
		i_D(0)	=> s_B(1),
		i_D(1)	=> '0',
		i_D(2)	=> s_B(1),
		i_D(3)	=> s_B(3),
		o_F	=> s_D(1));
--second layer
	layer2 : for i in N-3 downto 2 generate
	begin
		mux2 : mux4t1
		port MAP(i_S(0)	=> i_LorR,
			i_S(1)	=> i_Ss(1),
			i_D(0)	=> s_B(i),
			i_D(1)	=> s_B(i-2),
			i_D(2)	=> s_B(i),
			i_D(3)	=> s_B(i+2),
			o_F	=> s_D(i));
	end generate;
--final and second final in second layer
	secondMux30 : mux4t1
	port MAP(i_S(0)	=> i_LorR,
		i_S(1)	=> i_Ss(1),
		i_D(0)	=> s_B(30),
		i_D(1)	=> s_B(28),
		i_D(2)	=> s_B(30),
		i_D(3)	=> '0',
		o_F	=> s_D(30));

	secondMux31 : mux4t1
	port MAP(i_S(0)	=> i_LorR,
		i_S(1)	=> i_Ss(1),
		i_D(0)	=> s_B(31),
		i_D(1)	=> s_B(29),
		i_D(2)	=> s_B(31),
		i_D(3)	=> '0',
		o_F	=> s_D(31));
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--1-4 MUX in third layer
	layer3_1 : for i in 3 downto 0 generate
	begin
		mux3_1 : mux4t1
		port MAP(i_S(0)	=> i_LorR,
			i_S(1)	=> i_Ss(2),
			i_D(0)	=> s_D(i),
			i_D(1)	=> '0',
			i_D(2)	=> s_D(i),
			i_D(3)	=> s_D(i+4),
			o_F	=> s_E(i));
	end generate;
--third layer (minus last four)
	layer3_2 : for i in N-5 downto 4 generate
	begin
		mux3_2 : mux4t1
		port MAP(i_S(0)	=> i_LorR,
			i_S(1)	=> i_Ss(2),
			i_D(0)	=> s_D(i),
			i_D(1)	=> s_D(i-4),
			i_D(2)	=> s_D(i),
			i_D(3)	=> s_D(i+4),
			o_F	=> s_E(i));
	end generate;
--third layer final four
	layer3_3 : for i in 31 downto 28 generate
	begin
		mux3_3 : mux4t1
		port MAP(i_S(0)	=> i_LorR,
			i_S(1)	=> i_Ss(2),
			i_D(0)	=> s_D(i),
			i_D(1)	=> s_D(i-4),
			i_D(2)	=> s_D(i),
			i_D(3)	=> '0',
			o_F	=> s_E(i));
	end generate;
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--1-8 MUX in fourth layer
	layer4_1 : for i in 7 downto 0 generate
	begin
		mux4_1 : mux4t1
		port MAP(i_S(0)	=> i_LorR,
			i_S(1)	=> i_Ss(3),
			i_D(0)	=> s_E(i),
			i_D(1)	=> '0',
			i_D(2)	=> s_E(i),
			i_D(3)	=> s_E(i+8),
			o_F	=> s_G(i));
	end generate;
--third layer (minus first+last eight)
	layer4_2 : for i in N-9 downto 8 generate
	begin
		mux4_2 : mux4t1
		port MAP(i_S(0)	=> i_LorR,
			i_S(1)	=> i_Ss(3),
			i_D(0)	=> s_E(i),
			i_D(1)	=> s_E(i-8),
			i_D(2)	=> s_E(i),
			i_D(3)	=> s_E(i+8),
			o_F	=> s_G(i));
	end generate;
--third layer final eight
	layer4_3 : for i in N-1 downto N-8 generate
	begin
		mux4_3 : mux4t1
		port MAP(i_S(0)	=> i_LorR,
			i_S(1)	=> i_Ss(3),
			i_D(0)	=> s_E(i),
			i_D(1)	=> s_E(i-8),
			i_D(2)	=> s_E(i),
			i_D(3)	=> '0',
			o_F	=> s_G(i));
	end generate;
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--1-16 MUX in fourth layer
	layer5_1 : for i in 15 downto 0 generate
	begin
		mux5_1 : mux4t1
		port MAP(i_S(0)	=> i_LorR,
			i_S(1)	=> i_Ss(4),
			i_D(0)	=> s_G(i),
			i_D(1)	=> '0',
			i_D(2)	=> s_G(i),
			i_D(3)	=> s_G(i+16),
			o_F	=> o_F(i));
	end generate;
--fourth layer (minus first+last sixteen)
	layer5_2 : for i in N-17 downto 16 generate
	begin
		mux5_2 : mux4t1
		port MAP(i_S(0)	=> i_LorR,
			i_S(1)	=> i_Ss(4),
			i_D(0)	=> s_G(i),
			i_D(1)	=> s_G(i-16),
			i_D(2)	=> s_G(i),
			i_D(3)	=> s_G(i+16),
			o_F	=> o_F(i));
	end generate;
--fourth layer final sixteen
	layer5_3 : for i in N-2 downto N-16 generate
	begin
		mux5_3 : mux4t1
		port MAP(i_S(0)	=> i_LorR,
			i_S(1)	=> i_Ss(4),
			i_D(0)	=> s_G(i),
			i_D(1)	=> s_G(i-16),
			i_D(2)	=> s_G(i),
			i_D(3)	=> '0',
			o_F	=> o_F(i));
	end generate;
			process(i_Log, i_A, i_LorR) --changes MSB to 1 if arithmetic and was 1 or logical left and 30 is 1
			begin
			if ((i_Log = '1') and (i_A(31) = '1')) then
				o_F(31) <= '1';
			elsif ((i_Log = '0') and (i_A(30) = '1') and (i_LorR = '0')) then
				o_F(31) <= '1';
			else
				o_F(31) <= '0';
			end if;
			end process;
---------------------------------------------------------------------------
end mixed;
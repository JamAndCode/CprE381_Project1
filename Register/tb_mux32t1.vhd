-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_mux32t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench of the created 32 to 1 mux
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mux32t1 is
end tb_mux32t1;

architecture behaviour of tb_mux32t1 is

    component mux32t1 is
 	port( i_S	: in std_logic_vector(4 downto 0);
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
	i_16	: in std_logic_vector(31 downto 0);
	i_17	: in std_logic_vector(31 downto 0);
	i_18	: in std_logic_vector(31 downto 0);
	i_19	: in std_logic_vector(31 downto 0);
	i_20	: in std_logic_vector(31 downto 0);
	i_21	: in std_logic_vector(31 downto 0);
	i_22	: in std_logic_vector(31 downto 0);
	i_23	: in std_logic_vector(31 downto 0);
	i_24	: in std_logic_vector(31 downto 0);
	i_25	: in std_logic_vector(31 downto 0);
	i_26	: in std_logic_vector(31 downto 0);
	i_27	: in std_logic_vector(31 downto 0);
	i_28	: in std_logic_vector(31 downto 0);
	i_29	: in std_logic_vector(31 downto 0);
	i_30	: in std_logic_vector(31 downto 0);
	i_31	: in std_logic_vector(31 downto 0);
	o_F	: out std_logic_vector(31 downto 0));
     end component;

    --inputs
    signal s_0  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_1  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_2  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_3  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_4  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_5  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_6  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_7  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_8  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_9  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_10  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_11  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_12  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_13  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_14  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_15  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_16  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_17  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_18  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_19  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_20  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_21  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_22  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_23  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_24  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_25  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_26  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_27  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_28  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_29  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_30  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal s_31  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
   --SELECT
    signal s_S : std_logic_vector(4 downto 0) := "00000";
    --output
    signal s_F : std_logic_vector(31 downto 0);

    begin

	DUT0 : mux32t1
	port map(
  		i_S	=> s_S,
       		i_0	=> s_0,
       		i_1	=> s_1,
       		i_2	=> s_2,
       		i_3	=> s_3,
       		i_4	=> s_4,
       		i_5	=> s_5,
       		i_6	=> s_6,
       		i_7	=> s_7,
       		i_8	=> s_8,
       		i_9	=> s_9,
       		i_10	=> s_10,
       		i_11	=> s_11,
       		i_12	=> s_12,
       		i_13	=> s_13,
       		i_14	=> s_14,
       		i_15	=> s_15,
       		i_16	=> s_16,
       		i_17	=> s_17,
       		i_18	=> s_18,
       		i_19	=> s_19,
       		i_20	=> s_20,
       		i_21	=> s_21,
       		i_22	=> s_22,
       		i_23	=> s_23,
       		i_24	=> s_24,
       		i_25	=> s_25,
       		i_26	=> s_26,
       		i_27	=> s_27,
       		i_28	=> s_28,
       		i_29	=> s_29,
       		i_30	=> s_30,
       		i_31	=> s_31,
       		o_F     => s_F);
	
	P_TEST_CASES: process
	begin
		s_23	<= "01101100001100001100011110001111";
		s_S	<= "10111";
		wait for 100 ns;
		s_6	<= "11010000110101001101110101010100";
		s_S	<= "00110";
		wait for 100 ns;
		s_19	<= "00011001101010100110111111001111";
		s_S	<= "10011";
		wait for 100 ns;
		s_4	<= "11110100100001000001110110010011";
		s_S	<= "00100";
		wait for 100 ns;
		s_1	<= "00000000000000010000000000000000";
		s_S	<= "00001";
		wait for 100 ns;

	end process;

end behaviour;
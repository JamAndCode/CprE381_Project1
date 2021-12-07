-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux32t1.vhd
----------------------------------------------------------------------------
-- DESCRIPTION: This file contains a 5-to-32 bit decoder for a MIPS register
----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity mux32t1 is
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
end mux32t1;

architecture dataflow of mux32t1 is
begin
	process(i_S, i_0, i_1, i_2, i_3, i_4, i_5, i_6, i_7, i_8, i_9, i_10, i_11, i_12, i_13, i_14, i_15, i_16, i_17, i_18, i_19, i_20, i_21, i_22, i_23, i_24, i_25, i_26, i_27, i_28, i_29, i_30, i_31) is
	begin
	case i_S is
		when  "00000" => o_F <= i_0;
		when  "00001" => o_F <= i_1;
		when  "00010" => o_F <= i_2;
		when  "00011" => o_F <= i_3;
		when  "00100" => o_F <= i_4;
		when  "00101" => o_F <= i_5;
		when  "00110" => o_F <= i_6;
		when  "00111" => o_F <= i_7;
		when "01000" => o_F <=  i_8;
		when "01001" => o_F <=  i_9;
		when "01010" => o_F <=  i_10;
		when  "01011" => o_F <= i_11;
		when  "01100" => o_F <= i_12;
		when  "01101" => o_F <= i_13;
		when  "01110" => o_F <=  i_14;
		when  "01111" => o_F <= i_15;
		when  "10000" => o_F <= i_16;
		when  "10001" => o_F <= i_17;
		when  "10010" => o_F <= i_18;
		when  "10011" => o_F <= i_19;
		when  "10100" => o_F <= i_20;
		when  "10101" => o_F <=  i_21;
		when  "10110" => o_F <=  i_22;
		when  "10111" => o_F <=  i_23;
		when  "11000" => o_F <=  i_24;
		when  "11001" => o_F <=  i_25;
		when  "11010" => o_F <= i_26 ;
		when  "11011" => o_F <=  i_27;
		when  "11100" => o_F <= i_28;
		when  "11101" => o_F <= i_29;
		when  "11110" => o_F <= i_30;
		when  "11111" => o_F <= i_31;
		when others => o_F <=  "00000000000000000000000000000000";
	end case;
	end process;
end dataflow;
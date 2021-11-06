-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- register.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: I am so sorry, I didn't learn about arrays until too late
-- forgive me of my vhdl sins
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity registerBoi is
  port(	i_CLK	    : in std_logic;
	i_WriteEnable	: in std_logic;
	i_RST		: in std_logic;
	i_ReadReg1	: in std_logic_vector(4 downto 0);
	i_ReadReg2	: in std_logic_vector(4 downto 0);
	i_WriteReg	: in std_logic_vector(4 downto 0);
	i_WriteData	: in std_logic_vector(31 downto 0);
	o_ReadData1	: out std_logic_vector(31 downto 0);
	o_ReadData2	: out std_logic_vector(31 downto 0));
end registerBoi;

architecture structural of registerBoi is
type t_Mux is array (0 to 31) of std_logic_vector(31 downto 0); --array bussiness
    signal s_Mux : t_Mux;
signal s_Of	: std_logic_vector(31 downto 0);

  component dffg_n_alt
    port(i_CLK        : in std_logic;
         i_RST        : in std_logic;
         i_WrE         : in std_logic;
         i_D          : in std_logic_vector(31 downto 0);
         o_Q          : out std_logic_vector(31 downto 0)); 
  end component;

  component decode_5to32
    port(i_Enable : in std_logic;
	 i_A  : in std_logic_vector(4 downto 0);
         o_F  : out std_logic_vector(31 downto 0));
  end component;

  component mux32t1
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
  begin
  
  decoder: decode_5to32
    port map(	i_Enable=> i_WriteEnable,
		i_A	=> i_WriteReg,
		o_F	=> s_Of);

  r_Zero: dffg_n_alt		--$zero == 000000000000000000
    port map(i_CLK => i_CLK,
	 i_RST => '1',
         i_WrE => '1',
         i_D => (others => '0'),
         o_Q => s_Mux(0));

  G1: for i in 1 to 31 generate
    reg_i: dffg_n_alt
    port map(i_CLK => i_CLK,
         i_RST => i_RST,
         i_WrE => s_Of(i),
         i_D => i_WriteData,
         o_Q => s_Mux(i)); 

  mux_1: mux32t1
    port map(	i_S	=> i_ReadReg1,
		o_F	=> o_ReadData1,
		i_0	=> s_Mux(0),
		i_1	=> s_Mux(1),
		i_2	=> s_Mux(2),
		i_3	=> s_Mux(3),
		i_4	=> s_Mux(4),
		i_5	=> s_Mux(5),
		i_6	=> s_Mux(6),
		i_7	=> s_Mux(7),
		i_8	=> s_Mux(8),
		i_9	=> s_Mux(9),
		i_10	=> s_Mux(10),
		i_11	=> s_Mux(11),
		i_12	=> s_Mux(12),
		i_13	=> s_Mux(13),
		i_14	=> s_Mux(14),
		i_15	=> s_Mux(15),
		i_16	=> s_Mux(16),
		i_17	=> s_Mux(17),
		i_18	=> s_Mux(18),
		i_19	=> s_Mux(19),
		i_20	=> s_Mux(20),
		i_21	=> s_Mux(21),
		i_22	=> s_Mux(22),
		i_23	=> s_Mux(23),
		i_24	=> s_Mux(24),
		i_25	=> s_Mux(25),
		i_26	=> s_Mux(26),
		i_27	=> s_Mux(27),
		i_28	=> s_Mux(28),
		i_29	=> s_Mux(29),
		i_30	=> s_Mux(30),
		i_31	=> s_Mux(31));

  mux_2: mux32t1
    port map(	i_S	=> i_ReadReg2,
		o_F	=> o_ReadData2,
		i_0	=> s_Mux(0),
		i_1	=> s_Mux(1),
		i_2	=> s_Mux(2),
		i_3	=> s_Mux(3),
		i_4	=> s_Mux(4),
		i_5	=> s_Mux(5),
		i_6	=> s_Mux(6),
		i_7	=> s_Mux(7),
		i_8	=> s_Mux(8),
		i_9	=> s_Mux(9),
		i_10	=> s_Mux(10),
		i_11	=> s_Mux(11),
		i_12	=> s_Mux(12),
		i_13	=> s_Mux(13),
		i_14	=> s_Mux(14),
		i_15	=> s_Mux(15),
		i_16	=> s_Mux(16),
		i_17	=> s_Mux(17),
		i_18	=> s_Mux(18),
		i_19	=> s_Mux(19),
		i_20	=> s_Mux(20),
		i_21	=> s_Mux(21),
		i_22	=> s_Mux(22),
		i_23	=> s_Mux(23),
		i_24	=> s_Mux(24),
		i_25	=> s_Mux(25),
		i_26	=> s_Mux(26),
		i_27	=> s_Mux(27),
		i_28	=> s_Mux(28),
		i_29	=> s_Mux(29),
		i_30	=> s_Mux(30),
		i_31	=> s_Mux(31));
  
  end generate;
end structural;
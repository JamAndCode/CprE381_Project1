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
signal s_Mux0,s_Mux1,s_Mux2,s_Mux3,s_Mux4,s_Mux5,s_Mux6,s_Mux7,s_Mux8,s_Mux9,s_Mux10,s_Mux11,s_Mux12,s_Mux13,s_Mux14,s_Mux15,s_Mux16,s_Mux17,s_Mux18,s_Mux19,s_Mux20,s_Mux21,s_Mux22,s_Mux23,s_Mux24,s_Mux25,s_Mux26,s_Mux27,s_Mux28,s_Mux29,s_Mux30,s_Mux31	: std_logic_vector(31 downto 0);
signal s_Of	: std_logic_vector(31 downto 0);
signal s_Out1, s_Out2	: std_logic_vector(31 downto 0);

  component dffg_n_alt
    port(i_CLK        : in std_logic;
         i_RST        : in std_logic;
         i_WrE        : in std_logic;
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
         o_Q => s_Mux0);

    reg_1: dffg_n_alt
    port map(i_CLK => i_CLK,
         i_RST => i_RST,
         i_WrE => s_Of(1),
         i_D => i_WriteData,
         o_Q => s_Mux1); 

reg_2: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(2),
i_D => i_WriteData,
o_Q => s_Mux2);
reg_3: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(3),
i_D => i_WriteData,
o_Q => s_Mux3);
reg_4: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(4),
i_D => i_WriteData,
o_Q => s_Mux4);
reg_5: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(5),
i_D => i_WriteData,
o_Q => s_Mux5);

reg_6: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(6),
i_D => i_WriteData,
o_Q => s_Mux6);
reg_7: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(7),
i_D => i_WriteData,
o_Q => s_Mux7);
reg_8: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(8),
i_D => i_WriteData,
o_Q => s_Mux8);

reg_9: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(9),
i_D => i_WriteData,
o_Q => s_Mux9);
reg_10: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(10),
i_D => i_WriteData,
o_Q => s_Mux10);
reg_11: dffg_n_alt
    port map(i_CLK => i_CLK,
         i_RST => i_RST,
         i_WrE => s_Of(11),
         i_D => i_WriteData,
         o_Q => s_Mux11);
reg_12: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(12),
i_D => i_WriteData,
o_Q => s_Mux12);
reg_13: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(13),
i_D => i_WriteData,
o_Q => s_Mux13);
reg_14: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(14),
i_D => i_WriteData,
o_Q => s_Mux14);
reg_15: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(15),
i_D => i_WriteData,
o_Q => s_Mux15);

reg_16: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(16),
i_D => i_WriteData,
o_Q => s_Mux16);
reg_17: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(17),
i_D => i_WriteData,
o_Q => s_Mux17);
reg_18: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(18),
i_D => i_WriteData,
o_Q => s_Mux18);

reg_19: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(19),
i_D => i_WriteData,
o_Q => s_Mux19);
reg_20: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(20),
i_D => i_WriteData,
o_Q => s_Mux20);
reg_21: dffg_n_alt
    port map(i_CLK => i_CLK,
         i_RST => i_RST,
         i_WrE => s_Of(21),
         i_D => i_WriteData,
         o_Q => s_Mux21);
reg_22: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(22),
i_D => i_WriteData,
o_Q => s_Mux22);
reg_23: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(23),
i_D => i_WriteData,
o_Q => s_Mux23);
reg_24: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(24),
i_D => i_WriteData,
o_Q => s_Mux24);
reg_25: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(25),
i_D => i_WriteData,
o_Q => s_Mux25);

reg_26: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(26),
i_D => i_WriteData,
o_Q => s_Mux26);
reg_27: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(27),
i_D => i_WriteData,
o_Q => s_Mux27);
reg_28: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(28),
i_D => i_WriteData,
o_Q => s_Mux28);

reg_29: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(29),
i_D => i_WriteData,
o_Q => s_Mux29);

reg_30: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(30),
i_D => i_WriteData,
o_Q => s_Mux30);

reg_31: dffg_n_alt
port MAP(i_CLK => i_CLK,
i_RST => i_RST,
i_WrE => s_OF(31),
i_D => i_WriteData,
o_Q => s_Mux31);

  mux_1: mux32t1
    port map(	i_S	=> i_ReadReg1,
		i_0	=> s_Mux0,
		i_1	=> s_Mux1,
		i_2	=> s_Mux2,
		i_3	=> s_Mux3,
		i_4	=> s_Mux4,
		i_5	=> s_Mux5,
		i_6	=> s_Mux6,
		i_7	=> s_Mux7,
		i_8	=> s_Mux8,
		i_9	=> s_Mux9,
		i_10	=> s_Mux10,
		i_11	=> s_Mux11,
		i_12	=> s_Mux12,
		i_13	=> s_Mux13,
		i_14	=> s_Mux14,
		i_15	=> s_Mux15,
		i_16	=> s_Mux16,
		i_17	=> s_Mux17,
		i_18	=> s_Mux18,
		i_19	=> s_Mux19,
		i_20	=> s_Mux20,
		i_21	=> s_Mux21,
		i_22	=> s_Mux22,
		i_23	=> s_Mux23,
		i_24	=> s_Mux24,
		i_25	=> s_Mux25,
		i_26	=> s_Mux26,
		i_27	=> s_Mux27,
		i_28	=> s_Mux28,
		i_29	=> s_Mux29,
		i_30	=> s_Mux30,
		i_31	=> s_Mux31,
		o_F	=> s_Out1);
o_ReadData1 <= s_Out1;

  mux_2: mux32t1
    port map(	i_S	=> i_ReadReg2,
		o_F	=> s_Out2,
		i_0	=> s_Mux0,
		i_1	=> s_Mux1,
		i_2	=> s_Mux2,
		i_3	=> s_Mux3,
		i_4	=> s_Mux4,
		i_5	=> s_Mux5,
		i_6	=> s_Mux6,
		i_7	=> s_Mux7,
		i_8	=> s_Mux8,
		i_9	=> s_Mux9,
		i_10	=> s_Mux10,
		i_11	=> s_Mux11,
		i_12	=> s_Mux12,
		i_13	=> s_Mux13,
		i_14	=> s_Mux14,
		i_15	=> s_Mux15,
		i_16	=> s_Mux16,
		i_17	=> s_Mux17,
		i_18	=> s_Mux18,
		i_19	=> s_Mux19,
		i_20	=> s_Mux20,
		i_21	=> s_Mux21,
		i_22	=> s_Mux22,
		i_23	=> s_Mux23,
		i_24	=> s_Mux24,
		i_25	=> s_Mux25,
		i_26	=> s_Mux26,
		i_27	=> s_Mux27,
		i_28	=> s_Mux28,
		i_29	=> s_Mux29,
		i_30	=> s_Mux30,
		i_31	=> s_Mux31);
o_ReadData2 <= s_Out2;
  
end structural;
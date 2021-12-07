library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
generic(N : integer := 32);
  port (i_read1      : in std_logic_vector(N-1 downto 0);
        i_read2      : in std_logic_vector(N-1 downto 0);
        i_control    : in std_logic_vector(4-1 downto 0);
	i_ShiftBits	: in std_logic_vector(4 downto 0);
	i_overflow_enabled: in std_logic:='1';
        o_result      : out std_logic_vector(N-1 downto 0);
        o_zero        : out std_logic;
	o_overflow    : out std_logic);
end entity;

architecture behavior of ALU is

component barShifter is
  port (i_A 	: in std_logic_vector(N-1 downto 0);
	i_LorR	: in std_logic;
	i_Log	: in std_logic;
	i_Ss 	: in std_logic_vector(4 downto 0);
	o_F 	: out std_logic_vector(N-1 downto 0));
end component;

component add_sub is
port(i_A	: in std_logic_vector(N-1 downto 0);
     i_B 	: in std_logic_vector(N-1 downto 0); 	
     S		: in std_logic;
     o_Sum	: out std_logic_vector(N-1 downto 0);
     o_Cout	: out std_logic);
end component;

component muxALU is
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
end component;

signal add,subtract			: std_logic_vector(N-1 downto 0);
signal c,d,e				: std_logic;
signal tmp				: std_logic_vector(N-1 downto 0);
signal s_Breakout			: std_logic;
signal sllResult, srlResult, sraResult	: std_logic_vector(N-1 downto 0);
signal muxALUresult			: std_logic_vector(N-1 downto 0);
signal SLT				: std_logic_vector(N-1 downto 0);
signal holdMeDead			: std_logic;

begin
tmp<=std_logic_vector(unsigned(not (i_read2))+1); 
d<=i_read1(30) and i_read2(30);
add_alu : add_sub
port map(i_A => i_read1,
         i_B => i_read2,
	 S=>	'0',
	 o_Sum=>add,
	 o_Cout=>c);

add_alu2 : add_sub
port map(i_A => i_read1,
         i_B => tmp,
	 S=>	'0',
	 o_Sum=>subtract,
	 o_Cout=>c);

shiftLefLogical: barShifter
port MAP(i_A 	=> i_read2,
	i_LorR	=> '0',
	i_Log	=> '0',
	i_Ss 	=> i_ShiftBits,
	o_F 	=> sllResult);

shiftRightLogical: barShifter
port MAP(i_A 	=> i_read2,
	i_LorR	=> '1',
	i_Log	=> '0',
	i_Ss 	=> i_ShiftBits,
	o_F 	=> srlResult);

shiftRightArithm: barShifter
port MAP(i_A 	=> i_read2,
	i_LorR	=> '1',
	i_Log	=> '1',
	i_Ss 	=> i_ShiftBits,
	o_F 	=> sraResult);

process(subtract, SLT)
begin
	s_Breakout <= '0';
	if (subtract(31) = '1') then
		SLT <= x"00000001";
	else
		slt <= x"00000000";
	end if;
end process;

aluResults: muxALU
  port MAP(i_S	=> i_control,
	i_0	=> i_read1 AND i_read2, --and
	i_1	=> i_read1 OR i_read2, --or
	i_2	=> add, --add
	i_3	=> i_read1 nor i_read2, --nor
	i_4	=> slt, --SLT
	i_5	=> sllResult, --SLL
	i_6	=> subtract, --Subtract
	i_7	=> sraResult, --sra
	i_8	=> x"00000000",
	i_9	=> x"00000000",
	i_10	=> x"00000000",
	i_11	=> x"00000000",
	i_12	=> x"00000000",
	i_13	=> x"00000000",
	i_14	=> srlResult, --srl
	i_15	=> i_read1 xor i_read2, --xor
	o_F	=> muxALUresult);
o_result	<= muxALUresult;

--set zero to true if output is 0
with muxALUresult select
	o_zero <= '1' when x"00000000",
		  '0' when others;

process(i_overflow_enabled, i_control, muxALUresult, i_read1, i_read2)
begin
	if (i_overflow_enabled = '1') then
		if (i_control = "0010") then --adding
			o_overflow <= (i_read1(31) and i_read2(31) and (not(muxALUresult(31)))) or ((not(i_read1(31))) and (not(i_read2(31))) and muxALUresult(31));
		elsif (i_control = "0110") then
			o_overflow <= (i_read1(31) and (not(i_read2(31))) and (not(muxALUresult(31)))) or ((not(i_read1(31))) and (i_read2(31)) and muxALUresult(31));
		else
			o_overflow <= '0';
		end if;
	else
		o_overflow <= '0';
	end if;
end process;
end behavior;




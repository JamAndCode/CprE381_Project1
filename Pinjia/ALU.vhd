library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.numeric_std_unsigned.all;

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

signal add,subtract			: std_logic_vector(N-1 downto 0);
signal c,d,e				: std_logic;
signal tmp				: std_logic_vector(N-1 downto 0);
signal s_Breakout			: std_logic;
signal sllResult, srlResult, sraResult	: std_logic_vector(N-1 downto 0);

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

DUT0:process(i_control,i_read1,i_read2,s_Breakout,i_overflow_enabled)

begin

case (i_control) is
      when "0000" =>      -- AND
        o_result <= i_read1 AND i_read2;
	o_overflow<='0';
      when "0001" =>      -- OR
	o_result <= i_read1 OR i_read2;
	o_overflow<='0';
	when "0011"=>	  -- NOR
	o_result <= i_read1 nor i_read2;
	o_overflow<='0';

	when "1111"=>	  -- XOR
	o_result <= i_read1 xor i_read2;
	o_overflow<='0';

	when "0100"=>	  -- SLT
	s_Breakout <= '0';
	for i in N-1 downto 0 loop
		if (((i_read1(i) = '0') and (i_read2(i) = '1')) or((i_read1(i) = '1') and (i_read2(i) = '0'))) then
			if ((i_read1(i) = '1') and (i_read2(i) = '0')) then
				o_result <= x"00000000";
				s_Breakout <= '1';
				exit;
			elsif ((i_read1(i) = '0') and (i_read2(i) = '1')) then
				o_result <= x"00000001";
				s_Breakout <= '1';
				exit;
			end if;
		end if;
	end loop;
	if (s_Breakout = '0') then
		o_result <= x"00000000";
	end if;

	when "0101"=>	  -- SLL
	o_result <= sllResult;

	when "1110"=>	  -- SRL
	o_result<=srlResult;

	when "0111"=>	  -- SRA
	o_result<=sraResult;
	
	when "0010"=>     -- ADD
	o_result <= add;
	case(i_overflow_enabled) is
	when '1'=>
	o_overflow <= (i_read1(31) and i_read2(31) and (not(o_result(31)))) or ((not(i_read1(31))) and (not(i_read2(31))) and o_result(31));
	when others=>
	o_overflow<='0';
	end case;
	
	when "0110"=>     -- SUB
	o_result <= subtract;
	o_overflow <= (i_read1(31) and (not(i_read2(31))) and (not(o_result(31)))) or ((not(i_read1(31))) and (i_read2(31)) and o_result(31));	

      when others=>
	--do nothing
	
end case;


end process;

with o_result select
o_zero <= '1' when x"00000000",
'0' when others;
	


end behavior;




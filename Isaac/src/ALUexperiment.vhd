library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.numeric_std_unsigned.all;

entity ALUex is
generic(N : integer := 32);
  port (i_read1      : in std_logic_vector(N-1 downto 0); --input 1
        i_read2      : in std_logic_vector(N-1 downto 0); --input 2
        i_control    : in std_logic_vector(4-1 downto 0); --the code needed to determine operation type
	i_overflow_enabled: in std_logic:='1'; --overflow enablor, Im not removing since we already have it implemented in processor

        o_result      : out std_logic_vector(N-1 downto 0); --the result of the operation
        o_zero        : out std_logic; --if the operation has a result of zero (boolean)
	o_overflow    : out std_logic); --if the operation would result in an overflow (boolean)
end entity;

architecture behavior of ALUex is



component add_sub is
port(i_A	: in std_logic_vector(N-1 downto 0);
     i_B 	: in std_logic_vector(N-1 downto 0); 	
     S		: in std_logic;
     o_Sum	: out std_logic_vector(N-1 downto 0);
     o_Cout	: out std_logic);
end component;

signal add,subtract:std_logic_vector(N-1 downto 0);
signal c,d,e	:std_logic;
signal tmp	:std_logic_vector(N-1 downto 0);

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
port map(i_A 	=> i_read1,
         i_B 	=> tmp,
	 S	=> '0',
	 o_Sum 	=> subtract,
	 o_Cout => c);



DUT0:process(i_control,o_overflow,o_result,o_zero,i_read1,i_read2,add,subtract)

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
	e<=((not i_read1(31)) and i_read2(31))  or (i_read1(31) and i_read2(31) and subtract(31)) or ((not i_read1(31)) and (not i_read2(31)) and subtract(31));
	o_overflow<='0';
	o_result <=e and x"80000000";
	o_result<=o_result(31) and x"00000001";

	when "0101"=>	  -- SLL
	o_result<=i_read1 sll to_integer(unsigned(i_read2));

	when "1110"=>	  -- SRL
	o_result<=i_read1 srl to_integer(unsigned(i_read2));

	when "0111"=>	  -- SRA
	o_result<=i_read1 sra to_integer(unsigned(i_read2));
	

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
	o_overflow <= (i_read1(31) and i_read2(31) and (not(o_result(31)))) or ((not(i_read1(31))) and (not(i_read2(31))) and o_result(31));	

      when others=>
	--do nothing
	
end case;


end process;

with o_result select
o_zero <= '1' when x"00000000",
'0' when others;
	


end behavior;




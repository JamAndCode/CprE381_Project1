library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control is
  port (op_code	      		: in std_logic_vector(5 downto 0);
	fun       		: in std_logic_vector(5 downto 0);
	reg_dst	       		: out std_logic;
	jump	       		: out std_logic;
	jump_link      		: out std_logic;
	jump_reg       		: out std_logic;
	upper	       		: out std_logic;
	branch       		: out std_logic;
	mem_read       		: out std_logic;
	mem_to_reg    		: out std_logic;
	mem_write     		: out std_logic;
	alu_src			: out std_logic;
	reg_write         	: out std_logic;
	o_overflow_enabled	: out std_logic;
	o_Log			: out std_logic;
	o_Left			: out std_logic;
	o_Shift			: out std_logic;
	use_alu			: out std_logic;
        alu_control    		: out std_logic_vector(3 downto 0)	---alu control combination

	

	);
end entity;

architecture behavior of control is
begin
DUT0:process (op_code)

begin
case(op_code) is
when "000000"=>		---R type Instruction

reg_dst<='1';
jump<='0';
branch<='0';
mem_read<='0';
mem_to_reg<='0';
mem_write<='0';
alu_src<='0';
reg_write<='1';
jump_link<='0';
jump_reg<='0';
upper<='0';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu <= '0';



when "000010"=>	--jump type instruction
reg_dst<='0';		--may be not care?(set 0 for defulat)
jump<='1';
branch<='0';
mem_read<='0';
mem_to_reg<='0';
mem_write<='0';
alu_src<='0';
reg_write<='0';
alu_control <= "0010";	--does not care,implement by default
o_overflow_enabled<='1';
jump_link<='0';
jump_reg<='0';
upper<='0';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "000011"=>	--jal type instruction
reg_dst<='0';		
jump<='1';
branch<='0';
mem_read<='0';
mem_to_reg<='0';
mem_write<='0';
alu_src<='0';
reg_write<='1';
alu_control <= "0010";	--does not care,implement by default
o_overflow_enabled<='1';
jump_link<='1';
jump_reg<='0';
upper<='0';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';


when "001000"=>	--addi(I type)
reg_dst<='0';		
jump<='0';
branch<='0';
mem_read<='0';
mem_to_reg<='0';
mem_write<='0';
alu_src<='1';
reg_write<='1';
alu_control <= "0010";	
o_overflow_enabled<='1';
jump_link<='0';
jump_reg<='0';
upper<='0';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "001001"=>	--addiu(I type)
reg_dst<='0';		
jump<='0';
branch<='0';
mem_read<='0';
mem_to_reg<='0';
mem_write<='0';
alu_src<='1';
reg_write<='1';
alu_control <= "0010";	
o_overflow_enabled<='0';
jump_link<='0';
jump_reg<='0';
upper<='0';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "001100"=>	--andi(I type)
reg_dst<='0';		
jump<='0';
branch<='0';
mem_read<='0';
mem_to_reg<='0';
mem_write<='0';
alu_src<='1';
reg_write<='1';
alu_control <= "0000";
o_overflow_enabled<='1';
jump_link<='0';
jump_reg<='0';
upper<='0';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "001111"=>	--lui(I type)---need implement in alu
reg_dst<='0';		
jump<='0';
branch<='0';
mem_read<='1';
mem_to_reg<='1';
mem_write<='0';
alu_src<='1';
reg_write<='1';
alu_control <= "0010";	
o_overflow_enabled<='1';
jump_link<='0';
jump_reg<='0';
upper<='1';
o_Log<='1';
o_Left<='1';
o_Shift<='0';
use_alu<='1';

when "100011"=>	--lw(I type)
reg_dst<='0';		
jump<='0';
branch<='0';
mem_read<='1';
mem_to_reg<='1';
mem_write<='0';
alu_src<='1';
reg_write<='1';
alu_control <= "0010";	
o_overflow_enabled<='1';
jump_link<='0';
jump_reg<='0';
upper<='0';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "001110"=>	--xori(I type)
reg_dst<='0';		
jump<='0';
branch<='0';
mem_read<='0';
mem_to_reg<='0';
mem_write<='0';
alu_src<='1';
reg_write<='1';
alu_control <= "1111";	
o_overflow_enabled<='1';
jump_link<='0';
jump_reg<='0';
upper<='0';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "001101"=>	--ori(I type)
reg_dst<='0';		
jump<='0';
branch<='0';
mem_read<='0';
mem_to_reg<='0';
mem_write<='0';
alu_src<='1';
reg_write<='1';
alu_control <= "0001";	
o_overflow_enabled<='1';
jump_link<='0';
jump_reg<='0';
upper<='0';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "001010"=>	--slti(I type)
reg_dst<='0';		
jump<='0';
branch<='0';
mem_read<='0';
mem_to_reg<='0';
mem_write<='0';
alu_src<='1';
reg_write<='0';
alu_control <= "0100";
o_overflow_enabled<='1';
jump_link<='0';
jump_reg<='0';
upper<='0';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "101011"=>	--sw(I type)
reg_dst<='0';		
jump<='0';
branch<='0';
mem_read<='0';
mem_to_reg<='0';
mem_write<='1';
alu_src<='1';
reg_write<='0';
alu_control <= "0010";
o_overflow_enabled<='1';
jump_link<='0';
jump_reg<='0';
upper<='0';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "000100"=>	--beq(I type)
reg_dst<='0';		
jump<='0';
branch<='1';
mem_read<='0';
mem_to_reg<='0';
mem_write<='0';
alu_src<='1';
reg_write<='0';
alu_control <= "0110";
o_overflow_enabled<='1';
jump_link<='0';
jump_reg<='0';
upper<='0';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "000101"=>	--bne(I type)
reg_dst<='0';		
jump<='0';
branch<='1';
mem_read<='0';
mem_to_reg<='0';
mem_write<='0';
alu_src<='1';
reg_write<='0';
alu_control <= "0110";
o_overflow_enabled<='1';
jump_link<='0';
jump_reg<='0';
upper<='0';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';


when others=>

end case;

case(op_code) is
when "000000"=>	--R type only
case(fun) is
when "100100" =>
alu_control <= "0000";	--and
o_overflow_enabled<='1';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "100101" =>
alu_control <= "0001";	--or
o_overflow_enabled<='1';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "100000" =>
alu_control <= "0010";	--add
o_overflow_enabled<='1';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "100001" =>
alu_control <= "0010";	--addu
o_overflow_enabled<='0';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "100010" =>
alu_control <= "0110";	--sub
o_overflow_enabled<='1';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "100111" =>
alu_control <= "0011";	--nor
o_overflow_enabled<='1';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "101010" =>
alu_control <= "0100";	--slt
o_overflow_enabled<='1';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "000000" =>
alu_control <= "0101";	--sll
o_overflow_enabled<='1';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='1';

when "000010" =>
alu_control <= "1110";	--srl
o_overflow_enabled<='1';
o_Log<='0';
o_Left<='1';
use_alu<='1';
o_Shift<='0';

when "000011" =>
alu_control <= "0111";	--sra
o_overflow_enabled<='1';
o_Log<='1';
o_Left<='1';
o_Shift<='0';
use_alu<='1';

when "100110" =>
alu_control <= "1111";	--xor
o_overflow_enabled<='1';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when "001000"=>	--jr type instruction
alu_control <= "0010";	--does not care,implement by default
o_overflow_enabled<='1';
jump<='1';
jump_link<='0';
jump_reg<='1';
o_Log<='0';
o_Left<='0';
o_Shift<='0';
use_alu<='0';

when others=>
end case;

when others=>
end case;

end process;


end behavior;



-- tb_Controller.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for the controller
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_Controller is
end tb_Controller;

architecture behavior of tb_Controller is

component control is
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
	o_Signed		: out std_logic;
	o_SLT			: out std_logic;
        alu_control    		: out std_logic_vector(3 downto 0)	---alu control combination
	);
end component;

signal s_OP, s_Fun				: std_logic_vector(5 downto 0);
signal s_ALUcontrol				: std_logic_vector(3 downto 0);
signal s_RegDst, s_RegWr, s_RegJump		: std_logic;
signal s_Jump, s_JumpLink, s_Upper		: std_logic;
signal s_Branch, s_MemRead, s_MemToReg		: std_logic;
signal s_MemWrite, s_ALUsrc, s_Overflow		: std_logic;
signal s_Log, s_Left, s_Signed, s_SLT		: std_logic;

begin

proc: control
  port map(op_code		=> s_OP,
	fun       		=> s_Fun,
	reg_dst	       		=> s_RegDst,
	jump	       		=> s_Jump,
	jump_link      		=> s_JumpLink,
	jump_reg       		=> s_RegJump,
	upper	       		=> s_Upper,
	branch       		=> s_Branch,
	mem_read       		=> s_MemRead,
	mem_to_reg    		=> s_MemToReg,
	mem_write     		=> s_MemWrite,
	alu_src			=> s_ALUsrc,
	reg_write         	=> s_RegWr,
	o_overflow_enabled	=> s_Overflow,
	o_Log			=> s_Log,
	o_Left			=> s_Left,
	o_Signed		=> s_Signed,
	o_SLT			=> s_SLT,
        alu_control    		=> s_ALUcontrol);
	
  P_TB: process
  begin
	--ignore this, it won't show the ALUcontrol unless this is here because...?
	--it hates me?
	s_ALUcontrol <= "0000";

	--and
	s_OP	<= "000000";
	s_fun 	<= "100100";
	wait for 100 ns;

	--subu
	s_OP	<= "000000";
	s_fun 	<= "100011";
	wait for 100 ns;

	--or
	s_OP	<= "000000";
	s_fun 	<= "100101";
	wait for 100 ns;

	--add
	s_OP	<= "000000";
	s_fun 	<= "100000";
	wait for 100 ns;

	--addu
	s_OP	<= "000000";
	s_fun 	<= "100001";
	wait for 100 ns;

	--sub
	s_OP	<= "000000";
	s_fun 	<= "100010";
	wait for 100 ns;

	--nor
	s_OP	<= "000000";
	s_fun 	<= "100111";
	wait for 100 ns;

	--slt
	s_OP	<= "000000";
	s_fun 	<= "101010";
	wait for 100 ns;

	--sll
	s_OP	<= "000000";
	s_fun 	<= "000000";
	wait for 100 ns;

	--srl
	s_OP	<= "000000";
	s_fun 	<= "000010";
	wait for 100 ns;

	--sra
	s_OP	<= "000000";
	s_fun 	<= "000011";
	wait for 100 ns;

	--xor
	s_OP	<= "000000";
	s_fun 	<= "100110";
	wait for 100 ns;

	--jr
	s_OP	<= "000000";
	s_fun 	<= "001000";
	wait for 100 ns;


	--jump
	s_OP	<= "000010";
	wait for 100 ns;

	--jal
	s_OP	<= "000011";
	wait for 100 ns;

	--addi
	s_OP	<= "001000";
	wait for 100 ns;

	--addiu
	s_OP	<= "001001";
	wait for 100 ns;

	--andi
	s_OP	<= "001100";
	wait for 100 ns;

	--lui
	s_OP	<= "001111";
	wait for 100 ns;

	--lw
	s_OP	<= "100011";
	wait for 100 ns;

	--xori
	s_OP	<= "001110";
	wait for 100 ns;

	--ori
	s_OP	<= "001101";
	wait for 100 ns;

	--slti
	s_OP	<= "001010";
	wait for 100 ns;

	--sw
	s_OP	<= "101011";
	wait for 100 ns;

	--beq
	s_OP	<= "000100";
	wait for 100 ns;

	--bne
	s_OP	<= "000101";
	wait for 100 ns;


  end process;
  
end behavior;
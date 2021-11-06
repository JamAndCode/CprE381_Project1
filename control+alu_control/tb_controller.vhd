library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_controller is
generic(N : integer := 32);
  port(
	reg_dst	       : out std_logic;
	jump	       : out std_logic;
	jump_link      : out std_logic;
	jump_reg       : out std_logic;
	upper	       : out std_logic;
	branch         : out std_logic;
	mem_read         : out std_logic;
	mem_to_reg         : out std_logic;
	mem_write         : out std_logic;
	alu_src         : out std_logic;
	reg_write         : out std_logic;
	o_overflow_enabled: out std_logic;
        alu_control    : out std_logic_vector(3 downto 0));
end entity;

architecture structure of tb_controller is
  component control is
 port (op_code	       : in std_logic_vector(5 downto 0);
	reg_dst	       : out std_logic;
	jump	       : out std_logic;
	jump_link      : out std_logic;
	jump_reg       : out std_logic;
	upper	       : out std_logic;
	branch         : out std_logic;
	mem_read         : out std_logic;
	mem_to_reg         : out std_logic;
	mem_write         : out std_logic;
	alu_src         : out std_logic;
	reg_write         : out std_logic;
	o_overflow_enabled: out std_logic;
	fun       :   in std_logic_vector(5 downto 0);
        alu_control    : out std_logic_vector(3 downto 0)	---alu control combination

	

	);
  end component;

signal op:std_logic_vector(5 downto 0);
signal func:std_logic_vector(5 downto 0);
signal ju,jul,jur,up,br,mmread,mmreg,mmwrite,alusource,regw,oe:std_logic;
signal aluc:std_logic_vector(3 downto 0);

begin
controller_tb:control
port map(
	op_code=>op,
	fun=>func,
	reg_dst=>reg_dst,
	jump=>jump,
	jump_link=>jump_link,
	jump_reg=>jump_reg,
	upper=>upper,
	branch=>branch,
	mem_read=>mem_read,
	mem_to_reg=>mem_to_reg,
	mem_write=>mem_write,
	alu_src=>alu_src,
	reg_write=>reg_write,
	o_overflow_enabled=>o_overflow_enabled,
	alu_control=>alu_control

);

process 
begin
		---Test the whole R instruction required inside the document
op<="000000";	---add
func<="100000";
wait for 100ns;


op<="000000";
func<="100001";---addu
wait for 100ns;

op<="000000";
func<="100100";---and
wait for 100ns;

op<="000000";
func<="100010";---sub
wait for 100ns;

---Test the whole I instruction required inside the document
op<="001111";
func<="000000";---can do nothing for func since it is predesigned inside controller with func set to default value
wait for 100ns;---lui

op<="000101";
func<="000000";---can do nothing for func since it is predesigned inside controller with func set to default value
wait for 100ns;---bne

op<="001000";
func<="000000";---can do nothing for func since it is predesigned inside controller with func set to default value
wait for 100ns;---addi


end process;
end structure;




library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_hazard is

  port(	flush_IFID	: out std_logic;
	stall_IFID	:  out std_logic;
	flush_IDEX	:  out std_logic;
	stall_IDEX	:  out std_logic;
	stall_PC	:  out std_logic);
end entity;


architecture structure of tb_hazard is
  component hazard is
  port (i_Branch	: in std_logic;
  	real_branch		:in std_logic;
	i_JUmp		:in std_logic;
	mem_read	:in std_logic;
	ex_write	:in std_logic_vector(4 downto 0);
	inst_IFID	:in std_logic_vector(31 downto 0);
	inst_IDEX	:in std_logic_vector(31 downto 0);
	inst_EXMEM	:in std_logic_vector(31 downto 0);
	flush_IFID	: out std_logic;
	stall_IFID	:  out std_logic;
	flush_IDEX	:  out std_logic;
	stall_IDEX	:  out std_logic;
	stall_PC	:  out std_logic);
  end component;

signal branch,real_b,jump,mem_r	:std_logic;
signal ifid,idex,exmem: std_logic_vector(31 downto 0);
signal exwrite: std_logic_vector(4 downto 0);
 begin
    hazard_case : hazard
      port map(i_Branch	   => branch,
               real_branch   =>real_b ,
               i_JUmp => jump,
               mem_read   => mem_r,
               ex_write     => exwrite,
	       inst_IFID	=>ifid,
		inst_IDEX	=>idex,
		inst_EXMEM	=>exmem,
		flush_IFID=>flush_IFID,
		stall_IFID=>stall_IFID,
flush_IDEX=>flush_IDEX,
stall_IDEX=>stall_IDEX,
stall_PC=>stall_PC



);

process
	begin

branch<='0';
real_b<='0';
jump<='0';
mem_r<='0';
exwrite<="01010";
ifid<=x"02519820";
idex<=x"02519820";
exmem<=x"0293a820";

wait for 10 ns;
real_b<='0';
jump<='1';

wait for 10 ns;
ifid<=x"11491100";
idex<=x"10101000";
wait for 10 ns;

end process;
end structure;

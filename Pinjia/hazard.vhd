LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

entity hazard is
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
end entity;

architecture dataflow of hazard is

signal load_hazard,branch_hazard	:BOOLEAN;
begin

load_hazard<=((mem_read='1') and (((inst_IDEX(20 downto 16)=inst_IFID(25 downto 21)) and (inst_IFID(25 downto 21)/="00000")) or ((inst_IDEX(20 downto 16)=inst_IFID(20 downto 16)) and (inst_IFID(20 downto 16)=/"00000"))));
branch_hazard<=((i_Branch='1') and ((ex_write=inst_IFID(25 downto 21) and (inst_IFID(25 downto 21)/="00000")) or ((ex_write=inst_IFID(20 downto 16)) and (inst_IFID(20 downto 16)/="00000"))));


DUT0:process(i_JUmp,load_hazard,i_Branch,real_branch,branch_hazard)
begin


if(i_JUmp='1') then
	flush_IFID<='1';
	flush_IDEX<='1';
	stall_PC<='0';
	stall_IDEX<='1';
	stall_IFID<='1';


elsif(real_branch='1') then
flush_IFID<='1';
flush_IDEX<='0';
stall_PC<='0';
stall_IFID<='1';


elsif(load_hazard) then
flush_IDEX<='1';
flush_IFID<='0';
stall_PC<='1';
stall_IDEX<='1';
stall_IFID<='0';


elsif(branch_hazard) then
flush_IDEX<='0';
flush_IFID<='0';
stall_PC<='1';
stall_IDEX<='1';
stall_IFID<='1';

else
flush_IFID<='0';
flush_IDEX<='0';
stall_IDEX<='0';
stall_IFID<='0';
stall_PC<='0';

end if;
end process;


end dataflow;

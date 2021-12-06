library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IdToEx is
generic(N : integer := 32);
  port (i_CLK	: in std_logic;
	i_RST	: in std_logic;
	i_WE	: in std_logic;
	--Control signals in
	i_upper		: in std_logic;
	i_RegDst	: in std_logic;
	i_RegWr		: in std_logic;
	i_MemToReg	: in std_logic;
	i_MemWr		: in  std_logic;
	i_ALUsrc	: in std_logic;
	i_SLT		: in std_logic;
	i_Jr		: in std_logic;
	i_Jal		: in std_logic;
	i_Branch	: in std_logic;
	i_overflowEnable: in std_logic;
	--Control signals out
	o_upper		: out std_logic;
	o_RegDst	: out std_logic;
	o_RegWr		: out std_logic;
	o_MemToReg	: out std_logic;
	o_MemWr		: out std_logic;
	o_ALUsrc	: out std_logic;
	o_SLT		: out std_logic;
	o_Jr		: out std_logic;
	o_Jal		: out std_logic;
	o_Branch	: out std_logic;
	o_OverflowEnable: out std_logic;
	--the registers in
	i_Read1		: in std_logic_vector(4 downto 0);
 	i_Read2		: in std_logic_vector(4 downto 0);
	--the registers out
	o_Read1		: out std_logic_vector(4 downto 0);
	o_Read2		: out std_logic_vector(4 downto 0);
	--controlling ALU in and out
	i_ALUcontrol	: in std_logic_vector(3 downto 0);
	o_ALUcontrol	: out std_logic_vector(3 downto 0);
	--long bois in
	i_PC		: in std_logic_vector(31 downto 0);
	i_INst		: in std_logic_vector(31 downto 0);
	i_extended	: in std_logic_vector(31 downto 0);
	--long bois out
	o_PC		: out std_logic_vector(31 downto 0);
	o_Inst		: out std_logic_vector(31 downto 0);
	o_extended	: out std_logic_vector(31 downto 0));
	
end entity;

architecture structure of IdToEx is
component dffg_n_alt is
  generic(N : integer := 32);
  port(i_CLK		: in std_logic;
       i_RST            : in std_logic;
       i_WrE             : in std_logic;
       i_D          	: in std_logic_vector(N-1 downto 0);
       o_Q		: out std_logic_vector(N-1 downto 0));
end component;

component dffg is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
end component;

begin

upper: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_upper,
       o_Q          => o_upper);

overflowEnable: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_OverflowEnable,
       o_Q          => o_overflowENable);

REgDst: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_REgDst,
       o_Q          => o_RegDst);

MemToReg: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_MemToReg,
       o_Q          => o_MemToReg);

MemWr: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_MemWR,
       o_Q          => o_MemWR);

ALUsrc: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_ALUsrc,
       o_Q          => o_ALUsrc);

SLT: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_slt,
       o_Q          => o_slt);

jr: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_jr,
       o_Q          => o_jr);

jal: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_jal,
       o_Q          => o_jal);

branch: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_branch,
       o_Q          => o_branch);

WrAdder: dffg_n_alt
	generic map (N => 3)
	port MAP(i_CLK  => i_CLK,
       i_RST            => i_RST,
       i_WrE          	=> i_WE,
       i_D         	=> i_ALUcontrol,
       o_Q		=> o_ALUcontrol);

Reg1: dffg_n_alt
	generic map (N => 5)
	port MAP(i_CLK  => i_CLK,
       i_RST            => i_RST,
       i_WrE          	=> i_WE,
       i_D         	=> i_Read1,
       o_Q		=> o_Read1);

REg2: dffg_n_alt
	generic map (N => 5)
	port MAP(i_CLK  => i_CLK,
       i_RST            => i_RST,
       i_WrE          	=> i_WE,
       i_D         	=> i_Read2,
       o_Q		=> o_Read2);

PC: dffg_n_alt
	port MAP(i_CLK  => i_CLK,
       i_RST            => i_RST,
       i_WrE          	=> i_WE,
       i_D         	=> i_PC,
       o_Q		=> o_PC);

Inst: dffg_n_alt
	port MAP(i_CLK  => i_CLK,
       i_RST            => i_RST,
       i_WrE          	=> i_WE,
       i_D         	=> i_Inst,
       o_Q		=> o_Inst);

Extended: dffg_n_alt
	port MAP(i_CLK  => i_CLK,
       i_RST            => i_RST,
       i_WrE          	=> i_WE,
       i_D         	=> i_Extended,
       o_Q		=> o_Extended);
end structure;
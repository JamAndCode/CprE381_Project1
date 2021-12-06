library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ExToMem is
  port (i_CLK	: in std_logic;
	i_RST	: in std_logic;
	i_WE	: in std_logic;
	--Add more signals here
	--Control signals IN
	i_upper	: in std_logic;
	i_jal	: in std_logic;
	i_MemToReg	: in std_logic;
	i_MemWr		: in std_logic;
	i_RegWr		: in std_logic;
	i_slt		: in std_logic;
	--control signals out
	o_upper		: out std_logic;
	o_jal		: out std_logic;
	o_MemToReg	: out std_logic;
	o_MemWr		: out std_logic;
	o_RegWr		: out std_logic;
	o_slt		: out std_logic;
	--write adder in and out
	i_WrAddr	: in std_logic_vector(4 downto 0);
	o_WrAddr	: out std_logic_vector(4 downto 0);
	--long bois
	i_ALUresult	: in std_logic_vector(31 downto 0);
	i_PC		: in std_logic_vector(31 downto 0);
	i_extended	: in std_logic_vector(31 downto 0);
	i_Inst		: in std_logic_vector(31 downto 0);
	i_sltMUX	: in std_logic_vector(31 downto 0);
	--long bois heading out on the town
	o_ALUresult	: out std_logic_vector(31 downto 0);
	o_PC		: out std_logic_vector(31 downto 0);
	o_extended	: out std_logic_vector(31 downto 0);
	o_Inst		: out std_logic_vector(31 downto 0);
	o_sltMUX	: out std_logic_vector(31 downto 0));
end entity;

architecture structure of ExToMem is
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

REgWR: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_RegWr,
       o_Q          => o_REgWr);

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

SLT: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_slt,
       o_Q          => o_slt);

jal: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_jal,
       o_Q          => o_jal);

WrAdder: dffg_n_alt
	generic map (N => 5)
	port MAP(i_CLK  => i_CLK,
       i_RST            => i_RST,
       i_WrE          	=> i_WE,
       i_D         	=> i_WrAddr,
       o_Q		=> o_WrAddr);

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

SLTmux: dffg_n_alt
	port MAP(i_CLK  => i_CLK,
       i_RST            => i_RST,
       i_WrE          	=> i_WE,
       i_D         	=> i_SLTmux,
       o_Q		=> o_sltMUX);

ALUresult: dffg_n_alt
	port MAP(i_CLK  => i_CLK,
       i_RST            => i_RST,
       i_WrE          	=> i_WE,
       i_D         	=> i_ALUresult,
       o_Q		=> o_ALUresult);
end structure;
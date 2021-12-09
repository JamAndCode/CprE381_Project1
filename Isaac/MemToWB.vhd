---
--Memory to WriteBack REgister
--weeeee
--also I stole the flipflop out of the register cause its easier to use on the mux controls
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MemToWB is
generic(N : integer := 32);
  port (i_CLK	: in std_logic;
	i_RST	: in std_logic;
	i_WE	: in std_logic;
	--The control inputs coming in
	i_upper		: in std_logic;
	i_slt		: in std_logic;
	i_jump		: in std_logic;
	i_MemToREg	: in std_logic;
	i_RegWr		: in std_logic;
	--The control outputs coming out
	o_upper		: out std_logic;
	o_slt		: out std_logic;
	o_jump		: out std_logic;
	o_MemToREg	: out std_logic;
	o_RegWr		: out std_logic;
	--The actual values we want to (maybe) keep
	i_DMem		: in std_logic_vector(31 downto 0);
	i_ALUresult	: in std_logic_vector(31 downto 0);
	i_upperCon	: in std_logic_vector(31 downto 0);
	i_PC		: in std_logic_vector(31 downto 0);
	i_Inst		: in std_logic_vector(31 downto 0);
	--The actual values we want to come out
	o_DMem		: out std_logic_vector(31 downto 0);
	o_ALUresult	: out std_logic_vector(31 downto 0);
	o_upperCon	: out std_logic_vector(31 downto 0);
	o_PC		: out std_logic_vector(31 downto 0);
	o_Inst		: out std_logic_vector(31 downto 0));
end entity;

architecture structure of MemToWB is
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

DMem: dffg_n_alt
	port MAP(i_CLK  => i_CLK,
       i_RST            => i_RST,
       i_WrE          	=> i_WE,
       i_D         	=> i_DMem,
       o_Q		=> o_Dmem);

ALU: dffg_n_alt
	port MAP(i_CLK  => i_CLK,
       i_RST            => i_RST,
       i_WrE          	=> i_WE,
       i_D         	=> i_ALUresult,
       o_Q		=> o_ALUresult);

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

UpperReg: dffg_n_alt
	port MAP(i_CLK  => i_CLK,
       i_RST            => i_RST,
       i_WrE          	=> i_WE,
       i_D         	=> i_upperCon,
       o_Q		=> o_upperCon);

SLT: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_slt,
       o_Q          => O_slt);

UPPER: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_upper,
       o_Q          => o_upper);

jump: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_jump,
       o_Q          => o_jump);

RegWR: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_REgWr,
       o_Q          => o_RegWr);

MemToReg: dffg 
  port MAP(i_CLK    => i_CLK,
       i_RST        => i_RST,
       i_WE         => i_WE,
       i_D          => i_MemToReg,
       o_Q          => o_MemToReg);

end structure;
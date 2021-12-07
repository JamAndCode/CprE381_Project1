library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IfToId is
generic(N : integer := 32);
  port (i_CLK	: in std_logic;
	i_RST	: in std_logic;
	i_WE	: in std_logic;
	--PC signals
	i_PC	: in std_logic_vector(31 downto 0);
	o_PC	: out std_logic_vector(31 downto 0);
	--Inst signals
	i_Inst	: in std_logic_vector(31 downto 0);
	o_Inst	: out std_logic_vector(31 downto 0));
end entity;

architecture structure of IfToId is
component dffg_n_alt is
  generic(N : integer := 32);
  port(i_CLK		: in std_logic;
       i_RST            : in std_logic;
       i_WrE            : in std_logic;
       i_D          	: in std_logic_vector(N-1 downto 0);
       o_Q		: out std_logic_vector(N-1 downto 0));
end component;

begin

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
end structure;
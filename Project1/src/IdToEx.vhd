library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IdToEx is
generic(N : integer := 32);
  port (i_CLK	: in std_logic;
	i_RST	: in std_logic;
	i_WE	: in std_logic);
	--Add more signals here
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

end structure;
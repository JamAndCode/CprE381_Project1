-------------------------------------------------------------------------
-- Jamie Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- dffg_n_alt.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset for N bits.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity dffg_n_alt is
  generic(N : integer := 32);
  port(i_CLK		: in std_logic;
       i_RST            : in std_logic;
       i_WrE             : in std_logic;
       i_D          	: in std_logic_vector(N-1 downto 0);
       o_Q		: out std_logic_vector(N-1 downto 0));

end dffg_n_alt;

architecture structural of dffg_n_alt is

--Original edge-triggered flip-flop
  component dffg is
    port(i_CLK		: in std_logic;
       i_RST            : in std_logic;
       i_WE             : in std_logic;
       i_D          	: in std_logic;
       o_Q		: out std_logic);
  end component;

begin

G1: for i in N-1 downto 0 generate
	begin
	flipflop: dffg
		port map(i_CLK => i_CLK,
			i_RST	=> i_RST,
			i_WE	=> i_WrE,
			i_D	=> i_D(i),
			o_Q	=> o_Q(i));
end generate;

end structural;
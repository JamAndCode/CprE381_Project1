library IEEE;
use IEEE.std_logic_1164.all;


entity mux2t1 is

  port(i_S			    : in std_logic;
       i_D0 		            : in std_logic;
       i_D1 		            : in std_logic;
       o_O 		            : out std_logic);

end mux2t1;

architecture structure of mux2t1 is

  component andg2
   port(i_A          : in std_logic;
        i_B          : in std_logic;
        o_F          : out std_logic);
  end component;

  component invg
     port(i_A          : in std_logic;
          o_F          : out std_logic);
  end component;

  component org2
       port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  signal D0_S         : std_logic;
  signal D1_S         : std_logic;
  signal No_S         : std_logic;

begin

  D0: andg2
	port MAP(
             i_A               => i_D0,
             i_B              => No_s,
             o_F               => D0_S);
  No: invg
	port MAP(
             i_A               => i_S,
             o_F               =>No_S);

  D1: andg2
	port MAP(
             i_A               => i_D1,
             i_B              => i_S,
             o_F               => D1_S);

  OR12:org2
	port MAP(
             i_A               => D0_S,
             i_B              => D1_S,
             o_F               => o_O);
end structure;
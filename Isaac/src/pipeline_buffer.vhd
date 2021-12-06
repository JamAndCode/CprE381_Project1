
library IEEE;
use IEEE.std_logic_1164.all;

entity pipeline_buffer is
   port(i_CLK		: in std_logic; --Clock
	i_RST		: in std_logic; --Reset
	i_WE		: in std_logic; --Write Enable
	
	i_pipeline0	: in std_logic_vector(N-1 downto 0);
	o_pipeline0	: out std_logic_vector(N-1 downto 0);

	i_pipeline1	: in std_logic_vector(N-1 downto 0);
	o_pipeline1	: out std_logic_vector(N-1 downto 0);

	i_pipeline2	: in std_logic_vector(N-1 downto 0);
	o_pipeline2	: out std_logic_vector(N-1 downto 0);

	i_pipeline3	: in std_logic_vector(N-1 downto 0);
	o_pipeline3	: out std_logic_vector(N-1 downto 0);

	i_pipeline4	: in std_logic_vector(N-1 downto 0);
	o_pipeline4	: out std_logic_vector(N-1 downto 0);

	i_pipeline5	: in std_logic_vector(N-1 downto 0);
	o_pipeline5	: out std_logic_vector(N-1 downto 0);

 	i_pipeline6	: in std_logic_vector(N-1 downto 0);
	o_pipeline6	: out std_logic_vector(N-1 downto 0);

	i_pipeline7	: in std_logic_vector(N-1 downto 0);
	o_pipeline7	: out std_logic_vector(N-1 downto 0);

	i_pipeline8	: in std_logic_vector(N-1 downto 0);
	o_pipeline8	: out std_logic_vector(N-1 downto 0));

	--may need more or less of these, I just put 8 for now.
end pipeline_buffer;

architecture mixed of pipeline_buffer is
	--idea: have the input signals go to an internal register "buffer_reg" and have the reg
	--	hold the data until (reset and/or write enable)
	
	signal s_in	: reg_bus(8 downto 0); --Change leading integer (8) to represent the number of data lines shown above.
	signal s_out	: reg_bus(8 downto 0); --Same as above. 

	component buffer_reg is
	   port(i_CLK	: in std_logic;
		i_RST	: in std_logic;
		i_WE	: in std_logic;
		i_data	: in std_logic_vector(N-1 downto 0);
		o_data	: out std_logic_vector(N-1 downto 0));
	end component;


	begin
	   s_in(0) <= i_pipeline0;
	   o_pipeline0 <= s_out(0);

	   s_in(1) <= i_pipeline1;
	   o_pipeline1 <= s_out(1);

	   s_in(2) <= i_pipeline2;
	   o_pipeline2 <= s_out(2);

	   s_in(3) <= i_pipeline3;
	   o_pipeline3 <= s_out(3);

	   s_in(4) <= i_pipeline4;
	   o_pipeline4 <= s_out(4);

	   s_in(5) <= i_pipeline5;
	   o_pipeline5 <= s_out(5);

	   s_in(6) <= i_pipeline6;
	   o_pipeline6 <= s_out(6);

	   s_in(7) <= i_pipeline7;
	   o_pipeline7 <= s_out(7);

	   s_in(8) <= i_pipeline8;
	   o_pipeline8 <= s_out(8);


	   reg : for i in 0 to 9 generate
		buffer_register: buffer_reg port map(   --I don't think this is correct format. Anyone else know? -Isaac
			(i_CLK	=> iCLK,
			i_RST	=> i_RST,
			i_WE	=> i_WE,
			i_data	=> s_in(i),
			o_data	=> s_data(i));
	   end generate reg;

end mixed;
			

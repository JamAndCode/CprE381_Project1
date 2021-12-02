library IEEE;
use IEEE.std_logic_1164.all;

entity pipeline_IF_ID is
   port(i_CLK		: in std_logic;
	i_RST		: in std_logic;
	
	--need to have reset for each of these? maybe.
	i_pipeline0	: in std_logic_vector(__________);
	o_pipeline0	: out std_logic_vector(__________);

	i_pipeline1	: in std_logic_vector(__________);
	o_pipeline1	: out std_logic_vector(__________);

	--may need more of these, I just put 8 for now.
end pipeline_buffer;

architecture structural of pipeline_IF_ID is


end structural;

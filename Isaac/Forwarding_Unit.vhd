-----------------------------------Forwarding Unit--------------------------------------------------------------------------
--Purpose of the forwarding unit is to make sure data going into the EX stage has the correct values. 
--   This involves looking at the next set of instructions and seeing if there is any data dependencies. 
--   If there is a dependency, we need to identufy what data we need, where it is located, pull it, and then load it where it
--   needs to go (probably mainly the ID/EX).
--
--Will need to have input signals from each of the pipelines
--Will have output signals to the two MUXs to change for what register it's looking at whne comparing
--Will need output signals from the FU to three pipeline registers (Ex/MEM, MEM/WB, ID/EX).
--When writing data to the register after a dependency detection, write that info
--   to the register (since there is no data currenetly written there) and then use the MUXs
--   to pick that important path. 
---There are several dependencies that are present than just the ones presented in Lec9_1
--Sometimes the output from execution is needed right away and is able to be feed back into before the ALU
--   if it is being needed for the very next instruction.

--need to know:
	--When going to load new data into a register (ex: ID/EX), we will need to re-write data to those pipelined register.
-----------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity forwarding_unit is
   port(i_CLK		: in std_logic; --Clock --Unsure if we need CLK, RST, both, or none.  
	i_RST		: in std_logic; --Reset
	
--inputs
	i_IF_ID_RegWrite	: in std_logic;
	i_ID_EX_RegWrite	: in std_logic;
	i_MEM_WB_RegWrite 	: in std_logic;
	i_EX_MEM_RegWrite 	: in std_logic;

	--Connections from IF/EX
	i_ID_EX_RegisterRs 	: in std_logic_vector(25 downto 21);
	i_ID_EX_RegisterRd	: in std_logic_vector(15 downto 11);
	i_ID_EX_RegisterRt	: in std_logic_vector(20 downto 16);
	
	--Connections from IF/ID
	i_IF_ID_RegisterRs	: in std_logic_vector(25 downto 21);
	i_IF_ID_RegisterRd	: in std_logic_vector(15 downto 11);
	i_IF_ID_RegisterRt	: in std_logic_vector(20 downto 16);

	--Connections from MEM/WB
	i_MEM_WB_ResisterRd	: in std_logic_vector(15 downto 11);

	--Connections from EX/MEM
	i_EX_MEM_ResisterRd	: in std_logic_vector(15 downto 11);
	
	

--outputs
	o_Forward A (bottom MUX before ALU)	: out std_logic_vector(___) --two bits
	o_Forward B (top MUX)			: out std_logic_vector(___) --two bits
	o_ToReg_IF_ID				: out std_logic_vector(31 downto 0) --moving full reg size
	o_ToReg_ID_EX				: out std_logic_vector(31 downto 0) 
	o_ToReg_MEM_WB				: out std_logic_vector(31 downto 0) 
	o_ToGet_EX_MEM				: out std_logic_vector(31 downto 0) 
	

end forwarding_unit;

architecture mixed of forwarding_unit is
	--idea: Look at the inputs from 

	--------------------- Reference code from pipeline_buffer -------------------------------------------------------------
	signal s_in	: reg_bus(8 downto 0); --Change leading integer (8) to represent the number of data lines shown above.
	signal s_out	: reg_bus(8 downto 0); --Same as above. 

	component buffer_reg is
	   port(i_CLK	: in std_logic;
		i_RST	: in std_logic;
		i_WE	: in std_logic;
		i_data	: in std_logic_vector(N-1 downto 0);
		o_data	: out std_logic_vector(N-1 downto 0));
	end component;
	------------------------------------------------------------------------------------------------------------------------


	signal s_ID_EX_RegisterRd	:
	signal s_IF_ID_RegisterRs	:

	component forward_unit is
		port(

		)
	end component;

	begin
	--may want to rename outputs to make them more general
	   s_ID_EX_RegisterRd <= i_ID_EX_RegisterRd;
	   o_ID_EX_RegisterRd <= s_ID_EX_RegisterRd;

	   s_IF_ID_RegisterRs <= i_IF_ID_RegisterRs;
	   o_IF_ID_RegisterRs <= s_IF_ID_RegisterRs;

	   s_IF_ID_RegisterRt <= i_IF_ID_RegisterRt;
	   o_IF_ID_RegisterRt <= s_IF_ID_RegisterRt;

	   s_EX_MEM_RegisterRd <= i_EX_MEM_RegisterRd;
	   o_EX_MEM_RegisterRd <= s_EX_MEM_RegisterRd;

	   --will need to add more, but after we know what to look for.

	--Possible data hazards when:
	(s_ID_EX_RegisterRd == 

--



end mixed;
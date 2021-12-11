-----------------------------------Forwarding Unit--------------------------------------------------------------------------
--Purpose of the forwarding unit is to make sure data going into the EX stage has the correct values. 
--   This involves looking at the next set of instructions and seeing if there is any data dependencies. 
--   If there is a RAW dependency, then the post-execution value must be sent to the ID/EX register. If
--   there is a lw followed by a R-type instruction, then a nop/bubble must be sent to ID/EX register while
--   instructions in IF/ID will be stalled. 
--
--When writing data to the register after a dependency detection, write that info
--   to the register (since there is no data currenetly written there) and then use the MUXs
--   to pick that important path. 
--
--If the forwarding unit (FwU) detects a hazard, then we need to prevent the update of the PC and IF/ID register.
--	A nop/ bubble will be inserted into the ID/EX pipeline.
-----------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity forwarding_unit is
   port(
--inputs
	i_MEM_WB_RegWrite 	: in std_logic;
	i_EX_MEM_RegWrite 	: in std_logic;
	--Connections from IF/EX
	i_ID_EX_RegisterRs 	: in std_logic_vector(25 downto 21);
	i_ID_EX_RegisterRt	: in std_logic_vector(20 downto 16);
	--Connections from MEM/WB
	i_MEM_WB_RegisterRd	: in std_logic_vector(15 downto 11);
	--Connections from EX/MEM
	i_EX_MEM_RegisterRd	: in std_logic_vector(15 downto 11);
--outputs
	o_ForwardA		: out std_logic_vector(1 downto 0):="00"; --two bits 
	o_ForwardB		: out std_logic_vector(1 downto 0):="00"; --two bits
	--Returning connections to registers
	o_ToReg_ID_EX		: out std_logic_vector(31 downto 0); 
	o_ToReg_MEM_WB		: out std_logic_vector(31 downto 0));
end forwarding_unit;

--------------------------------------------------------------------

architecture dataflow of forwarding_unit is

component mux4t1
	port(i_S	: in std_logic_vector(1 downto 0);
	     i_D	: in std_logic_vector(3 downto 0); --need to change this somehow for pipeline signals
	     o_F	: out std_logic);
end component;

	signal s_MEM_WB_RegWrite 	: std_logic;
	signal s_EX_MEM_RegWrite 	: std_logic;
	signal s_ID_EX_RegisterRs 	: std_logic_vector(25 downto 21);
	signal s_ID_EX_RegisterRt	: std_logic_vector(20 downto 16);
	signal s_MEM_WB_RegisterRd	: std_logic_vector(15 downto 11); --destination reg (like above)
	signal s_EX_MEM_RegisterRd	: std_logic_vector(15 downto 11);
	signal s_ForwardA		: std_logic_vector(1 downto 0);
	signal s_ForwardB		: std_logic_vector(1 downto 0);
	signal s_ToReg_ID_EX		: std_logic_vector(31 downto 0); 
	signal s_ToReg_MEM_WB		: std_logic_vector(31 downto 0));

	begin
	   s_MEM_WB_RegWrite <= i_MEM_WB_RegWrite;
	   o_MEM_WB_RegWrite <= s_MEM_WB_RegWrite;

	   s_EX_MEM_RegWrite <= i_EX_MEM_RegWrite;
	   o_EX_MEM_RegWrite <= s_EX_MEM_RegWrite;

	   s_ID_EX_RegisterRs <= i_ID_EX_RegisterRs;
	   o_ID_EX_RegisterRs <= s_ID_EX_RegisterRs;

	   s_MEM_WB_RegisterRd <= i_MEM_WB_RegisterRd;
	   o_MEM_WB_RegisterRd <= s_MEM_WB_RegisterRd;

	   s_EX_MEM_RegisterRd <= i_EX_MEM_RegisterRd;
	   o_EX_MEM_RegisterRd <= s_EX_MEM_RegisterRd;


--EX Hazard:
	if(s_EX_MEM.RegWrite && (s_EX_MEM.RegisterRd == s_ID_EX_RegisterRs)) then
		ForwardA <= '10';
	elsif(s_EX_MEM.RegWrite && (s_EX_MEM.RegisterRd == s_ID_EX_RegisterRt)) then
		ForwardB <= '10';
--MEM Hazard:
	elsif(s_MEM_WB.RegWrite && (s_MEM_WB_RegisterRd == s_ID_EX_RegisterRs)) then
		ForwardA <= '01';
	elsif(s_MEM_WB.RegWrite && (s_MEM_WB_RegisterRd == s_ID_EX_RegisterRt)) then
		ForwardB <= '01';
	elsif(s_MEM_WB_RegWrite and (s_MEM_WB_RegisterRd /= '0') and not (s_EX_MEM_RegWrite and (s_EX_MEM_RegisterRd /= '0') 
		and (s_EX_MEM_RegisterRd == s_ID_EX_RegisterRs)) and (s_MEM_WB_RegisterRd == s_ID_EX_RegisterRs)) then
		ForwardA <= '01';
	elsif(s_MEM_WB_RegWrite and (s_MEM_WB_RegisterRd /= '0') and not (s_EX_MEM_RegWrite and (s_EX_MEM_RegisterRd /= '0') 
		and (s_EX_MEM_RegisterRd == s_ID_EX_RegisterRs)) and (s_MEM_WB_RegisterRd == s_ID_EX_RegisterRt)) then
		ForwardB <= '01';

--Load-Use Hazard Detection:
	--elsif(ID_EX_MemRead and ((ID_EX_RegisterRt == IF_ID_RegisterRs) or (ID_EX_RegisterRt == IF_ID_RegisterRt));
	--if detected, stall and insert bubble
	
	else
		ForwardA <= '00'; --double zero means no hazard
		ForwardB <= '00';

--MUX Gates
--idea: To make re-wiring a little more simple (at least in theory), since we already have wires feeding
--	into the Forwarding Unit, we process the mux inside it. A few other changes will need to be made such as
--	the pass-through of data that is not being processed in the Forwarding Unit process such as the full 
--	length of the instruction from the ID/EX pipeline, execution output from the EX/MEM pipeline, and the output from
--	our series of mux's after the MEM/WB pipeline.
mux4t1_A : mux4t1
	port map(i_S => ForwardA,
	     	 i_D => __,
	     	 o_F => __);

mux4t1_B : mux4t1
	port map(i_S => ForwardB,
	     	 i_D => __,
	     	 o_F => __);

	end if;
	end process;	
end dataflow;
-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
---Implement pipelining, which includes adding registers between phases
---
---
entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.
end  MIPS_Processor;

architecture structure of MIPS_Processor is
  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  -- Signals from before the great merge
  signal s_MemToReg, s_Reg_Dst, s_Jump, s_Branch, s_MemRead, s_ALUsrc, s_jump_link, s_jump_reg, s_upper, s_overflowEnable, s_Left, s_Signed, s_SLT, s_trueBranch, s_ALUzero: std_logic; 
  signal s_TestMe		: std_logic_vector(1 downto 0);
  signal s_ALUcontrol		: std_logic_vector(3 downto 0); --OP code that controls ALU operation
  signal s_RegDstWrite		: std_logic_vector(4 downto 0); --Signal between register destination write mux and jump and link mux
  signal s_Extended, s_RegReadData1, s_RegReadData2, s_OutALUsrc, s_MtRUI, s_UItSLT, s_SLTtJALC, s_PC, s_jumpAddr, s_jumpTop, s_jumpBot, s_ShiftAdd, s_branchAdd	: std_logic_vector(31 downto 0);
  signal s_ExtendShift, s_shiftedBranch, s_ALUout, s_backToPC, s_JCtJRC, s_BCtJC	: std_logic_vector(31 downto 0);

  -- SIgnals from after the great merge 

signal s_PC_IFID, s_InstIFID	: std_logic_vector(31 downto 0);
signal s_PC_IDEX, s_Inst_IDEX, s_Extended_IDEX	: std_logic_vector(31 downto 0);
signal s_reg1_IDEX, s_reg2_IDEX	: std_logic_vector(31 downto 0);
signal s_branch_IDEX, s_REgDst_IDEX, s_REgWr_IDEX, s_MemToReg_IDEX, s_MemWr_IDEX, s_ALUsrc_IDEX, s_SLT_IDEX, s_JR_IDEX, s_jump_IDEX, s_upper_IDEX	: std_logic;
signal s_sltMUX_EXMEM, s_Inst_EXMEM, s_Extended_EXMem, s_ALU_ExMem, s_PC_ExMem	: std_logic_vector(31 downto 0);
signal s_slt_ExMem, s_RegWr_ExMem, s_MemWr_ExMem, s_MemToReg_ExMem, s_Jal_ExMem, s_Upper_ExMem	: std_logic;
signal s_branchZero	: std_logic_vector(31 downto 0);
signal s_zeroBranch	: std_logic;
signal s_ALUcontrol_IDEX	: std_logic_vector(3 downto 0);
signal s_inst_MemWB, s_PC_MemWB, s_UpperCon_MemWB, s_ALUresult_MemWB, s_Dmem_MemWB : std_logic_vector(31 downto 0);
signal s_RegWr_MemWB, s_MemToREg_MemWB, s_Jump_MemWB, s_SLT_MemWB, s_upper_MemWb, s_OverflowEnable_IDEX, s_DMemWr_Control, s_RegWr_Control: std_logic;

  --Components
  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

 component overflowDetect is
	port(	i_RS		: in std_logic; --NOTE: these are the MSB of RS, RT, and the adder output
		i_RT		: in std_logic;
		i_ADDresult	: in std_logic;
		o_Overflow	: out std_logic);
	end component;

--NEW: pipelining registers
component IfToId is
  port (i_CLK	: in std_logic;
	i_RST	: in std_logic;
	i_WE	: in std_logic;
	--PC signals
	i_PC	: in std_logic_vector(31 downto 0);
	o_PC	: out std_logic_vector(31 downto 0);
	--Inst signals
	i_Inst	: in std_logic_vector(31 downto 0);
	o_Inst	: out std_logic_vector(31 downto 0));
end component;

component ExToMem is
  port (i_CLK	: in std_logic;
	i_RST	: in std_logic;
	i_WE	: in std_logic;
	--Add more signals here
	--Control signals IN
	i_upper		: in std_logic;
	i_jump		: in std_logic;
	i_MemToReg	: in std_logic;
	i_MemWr		: in std_logic;
	i_RegWr		: in std_logic;
	i_slt		: in std_logic;
	--control signals out
	o_upper		: out std_logic;
	o_jump		: out std_logic;
	o_MemToReg	: out std_logic;
	o_MemWr		: out std_logic;
	o_RegWr		: out std_logic;
	o_slt		: out std_logic;
	--long bois
	i_ALUresult	: in std_logic_vector(31 downto 0);
	i_PC		: in std_logic_vector(31 downto 0);
	i_extended	: in std_logic_vector(31 downto 0);
	i_Inst		: in std_logic_vector(31 downto 0);
	i_reg2out	: in std_logic_vector(31 downto 0);
	--long bois heading out on the town
	o_ALUresult	: out std_logic_vector(31 downto 0);
	o_PC		: out std_logic_vector(31 downto 0);
	o_extended	: out std_logic_vector(31 downto 0);
	o_reg2out	: out std_logic_vector(31 downto 0);
	o_Inst		: out std_logic_vector(31 downto 0));
end component;

component MemToWB is
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
end component;

component IdToEx is
generic(N : integer := 32);
  port (i_CLK	: in std_logic;
	i_RST	: in std_logic;
	i_WE	: in std_logic;
	--Control signals in
	i_ALUsrc	: in std_logic;
	i_overflowEnable: in std_logic;	

	--passing through to final register
	i_upper		: in std_logic;
	i_SLT		: in std_logic;
	i_Jump		: in std_logic;
	i_RegDst	: in std_logic;
	i_MemToReg	: in std_logic;

	--passing through to 2nd next register
	i_RegWr		: in std_logic;
	i_MemWr		: in  std_logic;
	--Control signals out
	o_ALUsrc	: out std_logic;
	o_overflowEnable: out std_logic;	

	--passing through to final register
	o_upper		: out std_logic;
	o_SLT		: out std_logic;
	o_Jump		: out std_logic;
	o_RegDst	: out std_logic;
	o_MemToReg	: out std_logic;

	--passing through to 2nd next register
	o_RegWr		: out std_logic;
	o_MemWr		: out  std_logic;
	--the registers in
	i_Read1		: in std_logic_vector(31 downto 0);
 	i_Read2		: in std_logic_vector(31 downto 0);
	--the registers out
	o_Read1		: out std_logic_vector(31 downto 0);
	o_Read2		: out std_logic_vector(31 downto 0);
	--controlling ALU in and out
	i_ALUcontrol	: in std_logic_vector(3 downto 0);
	o_ALUcontrol	: out std_logic_vector(3 downto 0);
	--long bois in
	i_PC		: in std_logic_vector(31 downto 0);
	i_INst		: in std_logic_vector(31 downto 0);
	i_extended	: in std_logic_vector(31 downto 0);
	--long bois out
	o_PC		: out std_logic_vector(31 downto 0);
	o_Inst		: out std_logic_vector(31 downto 0);
	o_extended	: out std_logic_vector(31 downto 0));
end component;

component control is
  port (op_code	       		: in std_logic_vector(5 downto 0);
	fun     	  	: in std_logic_vector(5 downto 0);
	reg_dst	       		: out std_logic;
	jump	       		: out std_logic;
	jump_link      		: out std_logic;
	jump_reg       		: out std_logic;
	upper	       		: out std_logic;
	branch         		: out std_logic;
	mem_read         	: out std_logic;
	mem_to_reg         	: out std_logic;
	mem_write         	: out std_logic;
	alu_src         	: out std_logic;
	reg_write         	: out std_logic;
	o_overflow_enabled	: out std_logic;
	o_Left			: out std_logic;
	o_Signed		: out std_logic;
	o_SLT			: out std_logic;
        alu_control   		: out std_logic_vector(3 downto 0));	---alu control combination
end component;

component registerBoi is
  port(	i_CLK	   	: in std_logic;
	i_WriteEnable	: in std_logic;
	i_RST		: in std_logic;
	i_ReadReg1	: in std_logic_vector(4 downto 0);
	i_ReadReg2	: in std_logic_vector(4 downto 0);
	i_WriteReg	: in std_logic_vector(4 downto 0);
	i_WriteData	: in std_logic_vector(31 downto 0);
	o_ReadData1	: out std_logic_vector(31 downto 0);
	o_ReadData2	: out std_logic_vector(31 downto 0));
end component;

component extend is
  port( i_A		: in std_logic_vector(15 downto 0);
	i_Sign		: in std_logic;
	o_F		: out std_logic_vector(31 downto 0));
end component;

component instructCount is
  port (iCLK		: in std_logic;
	iRST		: in std_logic;
	i_Enable	: in std_logic;
	iInstAddr 	: in std_logic_vector(N-1 downto 0);
	o_F		: out std_logic_vector(N-1 downto 0));
end component;

component barShifter is
  port (i_A 	: in std_logic_vector(N-1 downto 0);
	i_LorR	: in std_logic;
	i_Log	: in std_logic;
	i_Ss 	: in std_logic_vector(4 downto 0);
	o_F 	: out std_logic_vector(N-1 downto 0));
end component;

component UpperImmediates is
port(largeVar	: in  std_logic_vector(15 downto 0); 
     lowerbits	: out std_logic_vector(7 downto 0); 
     upperbits	: out std_logic_vector(15 downto 8)); 
end component;

component luiUpperImmediates is
port(i_A	: in  std_logic_vector(15 downto 0); 
     o_F	: out std_logic_vector(31 downto 0)); 
end component;

component ALU is
  port (i_read1      		: in std_logic_vector(N-1 downto 0);
        i_read2      		: in std_logic_vector(N-1 downto 0);
        i_control    		: in std_logic_vector(4-1 downto 0);
	i_ShiftBits		: in std_logic_vector(4 downto 0);
	i_overflow_enabled	: in std_logic;
        o_result      		: out std_logic_vector(N-1 downto 0);
        o_zero        		: out std_logic;
	o_overflow    		: out std_logic);
end component;

component branchChecker is
  port (i_ALUzero      : in std_logic;
        i_Control      : in std_logic_vector(1 downto 0);
        o_Branch    : out std_logic);
end component;

component n_bit_full_adder is
   port(i_A	: in std_logic_vector(N-1 downto 0);
	i_B	: in std_logic_vector(N-1 downto 0);
	i_Cin	: in std_logic;
	o_Cout	: out std_logic;
	o_Sum	: out std_logic_vector(N-1 downto 0));
end component;

component mux32_N is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component add_sub is
port(i_A	: in std_logic_vector(N-1 downto 0);
     i_B 	: in std_logic_vector(N-1 downto 0); 	
     S		: in std_logic;
     o_Sum	: out std_logic_vector(N-1 downto 0);
     o_Cout	: out std_logic);
end component;

component mux2t1_5 is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(4 downto 0);
       i_D1         : in std_logic_vector(4 downto 0);
       o_O          : out std_logic_vector(4 downto 0));
end component;

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

--START
  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
s_Halt <='1' when (s_Inst = "01010000000000000000000000000000") or (s_Inst = x"2402000a") else '0';
--that extra instruction (x"240200A") is for programs written by students cause for SOME reason it doesn't write a normal halt
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

--Control Unit
 controller : control
port MAP(op_code	        => s_InstIFID(N-1 downto N-6),
	fun      		=> s_InstIFID(5 downto 0),
	reg_dst	       		=> s_Reg_Dst,
	jump	       		=> s_Jump,
	jump_link      		=> s_jump_link,
	jump_reg       		=> s_jump_reg,
	upper	      		=> s_upper,
	branch        		=> s_Branch,
	mem_read         	=> s_MemRead,
	mem_to_reg         	=> s_MemToReg,
	mem_write         	=> s_DMemWr_Control,
	alu_src         	=> s_ALUsrc,
	reg_write         	=> s_RegWr_Control,
	o_overflow_enabled 	=> s_overflowEnable,
	o_Left 			=> s_Left,
	o_Signed 		=> s_Signed,
	o_SLT			=> s_SLT,
        alu_control    		=> s_ALUcontrol);	---alu control combination

--change this?
--Register Destination Write Mux
RegDestWrite: mux2t1_5
  port MAP(i_S      => s_REgDst_IDEX,
       i_D0         => s_Inst_IDEX(20 downto 16),
       i_D1         => s_Inst_IDEX(15 downto 11),
       o_O          => s_RegDstWrite);

--Jump and Link Mux [READ]
   JumpAndLink: mux2t1_5
	port MAP(i_S    => s_Jump_MemWB,
       		i_D0   	=> s_RegDstWrite,
       		i_D1 	=> "11111", --31 in binary
       		o_O	=> s_RegWrAddr); 

--Jump and Link Mux [Write]
  JumpAndLinkDataWriter: mux32_N
	port MAP(i_S    => s_Jump_MemWB,
       		i_D0   	=> s_SLTtJALC,
       		i_D1 	=> s_PC_MemWB, 
       		o_O	=> s_RegWrData);


--Register File
register1: registerBoi
  port MAP(	i_CLK	    	=> iCLK,
		i_WriteEnable	=> s_RegWr,
		i_RST		=> iRST,
		i_ReadReg1	=> s_InstIFID(25 downto 21),
		i_ReadReg2	=> s_InstIFID(20 downto 16),
		i_WriteReg	=> s_RegWrAddr,
		i_WriteData	=> s_RegWrData,
		o_ReadData1	=> s_RegReadData1,
		o_ReadData2	=> s_RegReadData2);

--Extender
  Extender: extend
  port MAP(i_A	=> s_InstIFID(15 downto 0),
	i_Sign	=> s_Signed,
	o_F	=> s_Extended);

--ALUSsrc control Mux
  ALUsrc: mux32_N
	port MAP(i_S    => s_ALUsrc_IDEX,
       		i_D0   	=> s_Reg2_IDEX,
       		i_D1 	=> s_Extended_IDEX,  
       		o_O	=> s_OutALUsrc);

--ALU
TheALU: ALU 
  port MAP(i_read1      	=> s_reg1_IDEX,
        i_read2      		=> s_OutALUsrc,		
        i_control    		=> s_ALUcontrol_IDEX,
	i_overflow_enabled 	=> s_OverflowEnable_IDEX,
	i_ShiftBits		=> s_Inst_IDEX(10 downto 6),
        o_result     		=> s_ALUout,
        o_zero      		=> s_ALUzero,
	o_overflow   		=> s_Ovfl);

oALUOut <= s_ALUout;

--Memory to Register control mux
  MemtoReg: mux32_N
	port MAP(i_S    => s_MemToREg_MemWB,
       		i_D0   	=> s_ALUresult_MemWB,
       		i_D1 	=> s_Dmem_MemWB,
       		o_O	=> s_MtRUI); 

upperImmShifter: barShifter
  port MAP(i_A 	=> s_Extended_IDEX,
	i_LorR	=> '0',
	i_Log	=> '0',
	i_Ss 	=> "10000",
	o_F 	=> s_ExtendShift);

--Upper immediate control mux
  UpperImmediate: mux32_N
	port MAP(i_S    => s_upper_MemWb,
       		i_D0   	=> s_MtRUI,
       		i_D1 	=> s_UpperCon_MemWB,
       		o_O	=> s_UItSLT);

--SLTU mux
  SLTUmux: mux32_N
	port MAP(i_S    => s_SLT_MemWB,
       		i_D0   	=> s_UItSLT,
       		i_D1 	=> s_ALUresult_MemWB, 
       		o_O	=> s_SLTtJALC);

--PC
  PC: instructCount
  port MAP(iCLK		=> iCLK,
	iRST		=> iRST,
	i_Enable	=> '1',
	iInstAddr 	=> s_backToPC,
	o_F		=> s_PC);

 s_NextInstAddr <= s_PC;

--increase the jumpto loction if there is a jump
  IncreasePC : add_sub
  port MAP(i_A	=> s_PC,
    	 i_B 	=> x"00000004",
     	S	=> '0',
     	o_Sum	=> s_jumpTop,
     	o_Cout	=> open);

--basically ignores the opcode and stores the address we want to branch/jump to
s_ShiftAdd(31 downto 26) <= "000000";
s_ShiftAdd(25 downto 0) <= s_InstIFID(25 downto 0);


--Control the signal for branching
WITH s_InstIFID(N-1 downto N-6) select
	s_TestMe <= "01" when "000100",
		"10" when "000101",
		"00" when others;

branchCheck: add_sub
port MAP(i_A	=> s_regReadData1,
     i_B 	=> s_regREadData2,	
     S		=> '1',
     o_Sum	=> s_branchZero,
     o_Cout	=> open);

process(s_branchZero, s_zeroBranch)
begin
	if (s_branchZero = x"00000000") then
		s_zeroBranch <= '1';
	else
		s_zeroBranch <= '0';
	end if;
end process;

testBranch: branchChecker
  port MAP(i_ALUzero	=> s_zeroBranch,
        i_Control   	=> s_TestMe,
        o_Branch    	=> s_trueBranch);

branchShift: barShifter
  port MAP(i_A 	=> s_Extended,
	i_LorR	=> '0',
	i_Log	=> '0',
	i_Ss 	=> "00010",
	o_F 	=> s_shiftedBranch);

branchAdder: add_sub
  port MAP(i_A	=> s_PC_IFID,
    	 i_B 	=> s_shiftedBranch,
     	S	=> '0',
     	o_Sum	=> s_branchAdd,
     	o_Cout	=> open);

--Branch control Mux
  BranchControl: mux32_N
	port MAP(i_S    => s_trueBranch, 
       		i_D0   	=> s_PC_IFID,
       		i_D1 	=> s_branchAdd,
       		o_O	=> s_BCtJC);

jumpShifter: barShifter
  port MAP(i_A 	=> s_ShiftAdd,
	i_LorR	=> '0',
	i_Log	=> '0',
	i_Ss 	=> "00010",
	o_F 	=> s_jumpBot);

s_JumpAddr(31 downto 28) <= s_PC_IFID(31 downto 28);

--since I didn't set up barShifter correctly, we must set its MSB indepent of bar shift
s_JumpAddr(27) <= s_ShiftAdd(25);
s_JumpAddr(26 downto 0) <= s_jumpBot(26 downto 0);

--Jump control mux
  JumpControl: mux32_N
	port MAP(i_S    => s_Jump, 
       		i_D0   	=> s_BCtJC,
       		i_D1 	=> s_jumpAddr, 
       		o_O	=> s_JCtJRC);

--Jump and Register Control
JumpReg: mux32_N
port MAP(i_S    => s_jump_reg, 
      	i_D0   	=> s_JCtJRC,
      	i_D1 	=> s_RegReadData1, 
  	o_O	=> s_backToPC);

--IF/ID register
If_To_ID: IfToId
  port MAP(i_CLK => iCLK,
	i_RST	 => iRST,
	i_WE	 => '1',
	--PC signals
	i_PC	=> s_jumpTop,
	o_PC	=> s_PC_IFID,
	--Inst signals
	i_Inst	=> s_Inst,
	o_Inst	=> s_InstIFID);

ID_to_EX : IdToEx
  port MAP(i_CLK	=> iCLK,
	i_RST		=> iRST,
	i_WE		=> '1',

	i_ALUsrc	=> s_ALUsrc,
	i_overflowEnable=> s_Overflowenable,	

	--passing through to final register
	i_upper		=> s_upper,
	i_SLT		=> s_SLT,
	i_Jump		=> s_jump,
	i_RegDst	=> s_Reg_Dst,
	i_MemToReg	=> s_MemToReg,

	--passing through to 2nd next register
	i_RegWr		=> s_RegWr_Control,
	i_MemWr		=> s_DMemWr_Control,

	--Control signals out
	o_ALUsrc	=> s_ALUsrc_IDEX,
	o_overflowEnable=> s_OverflowEnable_IDEX,

	--passing through to final register
	o_upper		=> s_upper_IDEX,
	o_SLT		=> s_SLT_IDEX,
	o_Jump		=> s_jump_IDEX,
	o_RegDst	=> s_REgDst_IDEX,
	o_MemToReg	=> s_MemToReg_IDEX,

	--passing through to 2nd next register
	o_RegWr		=> s_REgWr_IDEX,
	o_MemWr		=> s_MemWr_IDEX,
	--the registers in
	i_Read1		=> s_RegReadData1,
 	i_Read2		=> s_RegReadData2,
	--the registers out
	o_Read1		=> s_reg1_IDEX,
	o_Read2		=> s_reg2_IDEX,
	--ALU control signal in and out
	i_ALUcontrol	=> s_ALUcontrol,
	o_ALUcontrol	=> s_ALUcontrol_IDEX,
	--long bois in
	i_PC		=> s_PC_IFID,
	i_INst		=> s_InstIFID,
	i_extended	=> s_extended,
	--long bois out
	o_PC		=> s_PC_IDEX,
	o_Inst		=> s_Inst_IDEX,
	o_extended	=> s_Extended_IDEX);

EX_to_MEM: ExToMem
  port MAP(i_CLK	=> iCLK,
	i_RST		=> iRST,
	i_WE		=> '1',
	--Add more signals here
	--Control signals IN
	i_upper		=> s_upper_IDEX,
	i_jump		=> s_jump_IDEX,
	i_MemToReg	=> s_MemToReg_IDEX,
	i_MemWr		=> s_MemWr_IDEX,
	i_RegWr		=> s_REgWr_IDEX,
	i_slt		=> s_SLT_IDEX,
	--control signals out
	o_upper		=> s_Upper_ExMem,
	o_jump		=> s_Jal_ExMem,
	o_MemToReg	=> s_MemToReg_ExMem,
	o_MemWr		=> s_DMemWr,
	o_RegWr		=> s_RegWr_ExMem,
	o_slt		=> s_slt_ExMem,
	--long bois
	i_ALUresult	=> s_ALUout,
	i_PC		=> s_PC_IDEX,
	i_extended	=> s_Extended_IDEX,
	i_Inst		=> s_Inst_IDEX,
	i_reg2out	=> s_reg2_IDEX,
	--long bois heading out on the town
	o_ALUresult	=> s_ALU_ExMem,
	o_PC		=> s_PC_ExMem,
	o_extended	=> s_Extended_EXMem,
	o_reg2out	=> s_DMemData,
	o_Inst		=> s_Inst_EXMEM);

s_DMemAddr <= s_ALU_ExMem;

Mem_to_WB: MemToWB
  port MAP(i_CLK	=> iCLK,
	i_RST		=> iRST,
	i_WE		=> '1',
	--The control inputs coming in
	i_upper		=> s_Upper_ExMem,
	i_slt		=> s_slt_ExMem,
	i_jump		=> s_Jal_ExMem,
	i_MemToREg	=> s_MemToReg_ExMem,
	i_RegWr		=> s_RegWr_ExMem,
	--The control outputs coming out
	o_upper		=> s_upper_MemWb,
	o_slt		=> s_SLT_MemWB,
	o_jump		=> s_Jump_MemWB,
	o_MemToREg	=> s_MemToREg_MemWB,
	o_RegWr		=> s_RegWr,
	--The actual values we want to (maybe) keep
	i_DMem		=> s_DMemOut,
	i_ALUresult	=> s_ALU_ExMem,
	i_upperCon	=> s_ExtendShift,
	i_PC		=> s_PC_ExMem,
	i_Inst		=> s_Inst_EXMEM,
	--The actual values we want to come out
	o_DMem		=> s_Dmem_MemWB,
	o_ALUresult	=> s_ALUresult_MemWB,
	o_upperCon	=> s_UpperCon_MemWB,
	o_PC		=> s_PC_MemWB,
	o_Inst		=> s_inst_MemWB);

end structure;

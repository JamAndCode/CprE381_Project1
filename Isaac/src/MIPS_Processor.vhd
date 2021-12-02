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
use ieee.numeric_std_unsigned.all;

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

  -- Other control signals (from controller to various muxes)
  signal s_MemToReg		: std_logic; --signal between Memory-to-register mux
  signal s_Reg_Dst		: std_logic; 
  signal s_Jump			: std_logic; 
  signal s_Branch		: std_logic; 
  signal s_MemRead		: std_logic; 
  signal s_ALUsrc		: std_logic;
  signal s_jump_link      	: std_logic;
  signal s_jump_reg       	: std_logic;
  signal s_upper	      	: std_logic;
  signal s_overflowEnable	: std_logic; 
  signal s_Log			: std_logic;
  signal s_Left			: std_logic;
  signal s_Signed		: std_logic;
  signal s_SLT			: std_logic;
  signal s_ALUcontrol		: std_logic_vector(3 downto 0); --OP code that controls ALU operation

signal s_SLTtJALC		: std_logic_vector(31 downto 0);
signal s_PC			: std_logic_vector(31 downto 0);
signal s_jumpAddr		: std_logic_vector(31 downto 0);
signal s_jumpTop		: std_logic_vector(31 downto 0);
signal s_jumpBot		: std_logic_vector(31 downto 0);
signal s_ShiftAdd		: std_logic_vector(31 downto 0);
signal s_branchAdd		: std_logic_vector(31 downto 0);
signal s_TestMe			: std_logic_vector(1 downto 0);

  -- Signals between components
signal s_Extended		: std_logic_vector(31 downto 0);
signal s_RegDstWrite		: std_logic_vector(4 downto 0); --Signal between register destination write mux and jump and link mux
signal s_RegReadData1		: std_logic_vector(31 downto 0); --signal out of register file for read data 1
signal s_RegReadData2		: std_logic_vector(31 downto 0); --signal out of register file for read data 2s
signal s_OutALUsrc		: std_logic_vector(31 downto 0); --signa between ALURSC mux and ALU
signal s_MtRUI			: std_logic_vector(31 downto 0); --signal between MemtoReg mux and upper immediate mux
signal s_UItSLT			: std_logic_vector(31 downto 0); --signal between upper immediate to set on less than
signal s_ALUzero		: std_logic; --signal of alu from zero output
signal s_BCtJC			: std_logic_vector(31 downto 0); --signal from branch control mux to jump control mux
signal s_JCtJRC			: std_logic_vector(31 downto 0); --signal from jump control mux to jump register control mux
signal s_backToPC		: std_logic_vector(31 downto 0); --currently not actually connected, test then add in
signal s_ALUout			: std_logic_vector(31 downto 0);
signal s_trueBranch		: std_logic;
signal s_ExtendShift		: std_logic_vector(31 downto 0);
signal s_shiftedBranch		: std_logic_vector(31 downto 0);

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
	o_Log			: out std_logic;
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

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
s_Halt <='1' when (s_Inst = "01010000000000000000000000000000");
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

--Control Unit
 controller : control
port MAP(op_code	        => s_Inst(N-1 downto N-6),
	fun      		=> s_Inst(5 downto 0),
	reg_dst	       		=> s_Reg_Dst,
	jump	       		=> s_Jump,
	jump_link      		=> s_jump_link,
	jump_reg       		=> s_jump_reg,
	upper	      		=> s_upper,
	branch        		=> s_Branch,
	mem_read         	=> s_MemRead,
	mem_to_reg         	=> s_MemToReg,
	mem_write         	=> s_DMemWr,
	alu_src         	=> s_ALUsrc,
	reg_write         	=> s_RegWr,
	o_overflow_enabled 	=> s_overflowEnable,
	o_Log 			=> s_Log,
	o_Left 			=> s_Left,
	o_Signed 		=> s_Signed,
	o_SLT			=> s_SLT,
        alu_control    		=> s_ALUcontrol);	---alu control combination

--Register Destination Write Mux
RegDestWrite: mux2t1_5
  port MAP(i_S      => s_Reg_Dst,
       i_D0         => s_Inst(20 downto 16),
       i_D1         => s_Inst(15 downto 11),
       o_O          => s_RegDstWrite);

--Jump and Link Mux [READ]
   JumpAndLink: mux2t1_5
	port MAP(i_S    => s_jump,
       		i_D0   	=> s_RegDstWrite,
       		i_D1 	=> "11111", --31 in binary
       		o_O	=> s_RegWrAddr); 

--Jump and Link Mux [Write]
  JumpAndLinkDataWriter: mux32_N
	port MAP(i_S    => s_jump,
       		i_D0   	=> s_SLTtJALC,
       		i_D1 	=> s_jumpTop, 
       		o_O	=> s_RegWrData);


--Register File
register1: registerBoi
  port MAP(	i_CLK	    	=> iCLK,
		i_WriteEnable	=> s_RegWr,
		i_RST		=> iRST,
		i_ReadReg1	=> s_Inst(25 downto 21),
		i_ReadReg2	=> s_Inst(20 downto 16),
		i_WriteReg	=> s_RegWrAddr,
		i_WriteData	=> s_RegWrData,
		o_ReadData1	=> s_RegReadData1,
		o_ReadData2	=> s_RegReadData2);

--reassign 2nd reg output to DMem
s_DMemData <= s_RegReadData2;

--Extender
  Extender: extend
  port MAP(i_A	=> s_Inst(15 downto 0),
	i_Sign	=> s_Signed,
	o_F	=> s_Extended);

--ALUSsrc control Mux
  ALUsrc: mux32_N
	port MAP(i_S    => s_ALUsrc,
       		i_D0   	=> s_RegReadData2,
       		i_D1 	=> s_extended,  
       		o_O	=> s_OutALUsrc);

--ALU
TheALU: ALU 
  port MAP(i_read1      	=> s_RegReadData1,
        i_read2      		=> s_OutALUsrc,		
        i_control    		=> s_ALUcontrol,
	i_overflow_enabled 	=> s_overflowEnable,
	i_ShiftBits		=> S_Inst(10 downto 6),
        o_result     		=> s_ALUout,
        o_zero      		=> s_ALUzero,
	o_overflow   		=> s_Ovfl);

oALUOut <= s_ALUout;
s_DMemAddr <= s_ALUout;

--Memory to Register control mux
  MemtoReg: mux32_N
	port MAP(i_S    => s_MemToReg,
       		i_D0   	=> s_ALUout,
       		i_D1 	=> s_DMemOut,
       		o_O	=> s_MtRUI); 

upperImmShifter: barShifter
  port MAP(i_A 	=> s_Extended,
	i_LorR	=> '0',
	i_Log	=> '0',
	i_Ss 	=> "10000",
	o_F 	=> s_ExtendShift);

--Upper immediate control mux
  UpperImmediate: mux32_N
	port MAP(i_S    => s_upper,
       		i_D0   	=> s_MtRUI,
       		i_D1 	=> s_ExtendShift,
       		o_O	=> s_UItSLT);

--SLTU mux
  SLTUmux: mux32_N
	port MAP(i_S    => s_SLT,
       		i_D0   	=> s_UItSLT,
       		i_D1 	=> s_ALUout, 
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
s_ShiftAdd(25 downto 0) <= s_Inst(25 downto 0);


--Control the signal for branching
WITH s_Inst(N-1 downto N-6) select
	s_TestMe <= "01" when "000100",
		"10" when "000101",
		"00" when others;

testBranch: branchChecker
  port MAP(i_ALUzero	=> s_ALUzero,
        i_Control   	=> s_TestMe,
        o_Branch    	=> s_trueBranch);

branchShift: barShifter
  port MAP(i_A 	=> s_Extended,
	i_LorR	=> '0',
	i_Log	=> '0',
	i_Ss 	=> "00010",
	o_F 	=> s_shiftedBranch);

branchAdder: add_sub
  port MAP(i_A	=> s_jumpTop,
    	 i_B 	=> s_shiftedBranch,
     	S	=> '0',
     	o_Sum	=> s_branchAdd,
     	o_Cout	=> open);

--Branch control Mux
  BranchControl: mux32_N
	port MAP(i_S    => s_trueBranch, 
       		i_D0   	=> s_jumpTop,
       		i_D1 	=> s_branchAdd,
       		o_O	=> s_BCtJC);

jumpShifter: barShifter
  port MAP(i_A 	=> s_ShiftAdd,
	i_LorR	=> '0',
	i_Log	=> '0',
	i_Ss 	=> "00010",
	o_F 	=> s_jumpBot);

s_JumpAddr(31 downto 28) <= s_jumpTop(31 downto 28);

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


---------------Pipelining Implementation----------------------
--NOTES: Each Reg needs equal number of lines going out as coming in.
-- 	 Each also needs a clock and a reset.
--	 Need to create a pipeline component that will be called for each of the Registers/pipelines


--IF/ID Register (Instruction Fetch/ Instruction Decode)
--lines coming in: s_Inst ; IncreasePC (line 390)
IF_ID_REG: pipeline_IF_ID
port MAP(
	i_CLK	=> iCLK;
	i_RST	=> '0';
	-- pipeline fills on rising-edge, so we need to reset it on the falling-edge

	i_pipeline0	=> s_Inst;	--instruction line
	o_pipeline0	=> s_InstIFID;

	i_pipeline1	=> s_jumpTop;	--name for PC+4
	o_pipeline1	=> s_jumpTopPipe;
	);


--ID/EX Register  (Instruction Decode/ Execution)
--
ID_EX_REG: pipeline_ID_EX
port MAP(
	i_CLK	=> iCLK,
	i_RST	=> iRST,

	i_pipeline0	=> --Control WB
	o_pipeline0	=> 

	i_pipeline1	=> --Control Mem (called "M" on sheet)
	o_pipeline1	=> 

	i_pipeline2	=> --Control EX
	o_pipeline2	=> 

	i_pipeline3	=> s_InstIFID --Instruction line out of prev. pipeline
	o_pipeline3	=> s_InstIDEX

	i_pipeline4	=> --Reg read data 1
	o_pipeline4	=> 

	i_pipeline5	=> --Reg read data 2
	o_pipeline5	=> 

	i_pipeline6	=> --Inst[15-0] after sign-extend (s_ExtendShift???)
	o_pipeline6	=> 

	i_pipeline7	=> --Inst[20-16]
	o_pipeline7	=> 

	i_pipeline8	=> --Inst[15-11]
	o_pipeline8	=> 

	i_pipeline9	=> --unknown, diagram shows 10 lines total
	o_pipeline9	=> 
	);

--EX/MEM Register   (Execution/ Memory Access)
EX_MEM_REG: ________
port MAP(
	i_CLK	=> iCLK,
	i_RST	=> iRST,

	
	);

--MEM/WB Register   (Memory Access/ Write Back)
MEM_WB_REG: ________
port MAP(
	i_CLK	=> iCLK,
	i_RST	=> iRST,

	
	);












end structure;

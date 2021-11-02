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

signal s_Extended		: std_logic_vector(31 downto 0);
signal s_RDWJL			: std_logic_vector(31 downto 0); --Signal between register destination write mux and jump and link mux
signal s_RegReadData1		: std_logic_vector(31 downto 0); --signal out of register file for read data 1
signal s_ALURead1		: std_logic_vector(31 downto 0); --signa between shift mux and ALU
signal s_ALURead2		: std_logic_vector(31 downto 0); --signa between ALURSC mux and ALU
signal s_MtRUI			: std_logic_vector(31 downto 0); --signal between MemtoReg mux and upper immediate mux
signal s_UItSLT			: std_logic_vector(31 downto 0); --signal between upper immediate to set on less than
signal s_SLTtJALC		: std_logic_vector(31 downto 0); --signal between set on less than to jump and link control
signal s_ALUzero		: std_logic; --signal of alu from zero output
signal s_Andcontrol		: std_logic; --signal from AND controlling branch
signal s_InstShift		: std_logic_vector(31 downto 0); --signal out of I.Mem barrel shifter
signal s_RegShift		: std_logic_vector(31 downto 0); --signal out of the register barrel shifter
signal s_AdderFromPC		: std_logic_vector(31 downto 0); --signal from the adder coming from PC output
signal s_AdderFromShifter	: std_logic_vector(31 downto 0); --signal from the second adder output
signal s_BCtJC			: std_logic_vector(31 downto 0); --signal from branch control mux to jump control mux
signal s_JCtJRC			: std_logic_vector(31 downto 0); --signal from jump control mux to jump register control mux
signal s_MemToReg		: std_logic; --signal between Memory-to-register mux
signal s_Reg_Dst		: std_logic; 
signal s_Jump			: std_logic; 
signal s_Branch			: std_logic; 
signal s_MemRead		: std_logic; 
signal s_MemWrite		: std_logic; 
signal s_RegWrite		: std_logic; 
signal s_ALUsrc			: std_logic;
signal s_overflowEnable		: std_logic;  
signal s_ALUcontrol		: std_logic_vector(3 downto 0);
signal s_Cout			: std_logic;
signal s_CoutTrash		: std_logic;

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
  port (op_code	     		: in std_logic_vector(5 downto 0);
	fun       		: in std_logic_vector(5 downto 0);
	reg_dst	     		: out std_logic;
	jump	      		: out std_logic;
	branch        		: out std_logic;
	mem_read        	: out std_logic;
	mem_to_reg      	: out std_logic;
	mem_write      		: out std_logic;
	alu_src         	: out std_logic;
	reg_write         	: out std_logic;
	o_overflow_enabled	: out std_logic;
        alu_control    		: out std_logic_vector(3 downto 0));
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
	i_S		: in std_logic;
	o_F		: out std_logic_vector(31 downto 0));
end component;

component instructCount is
  port (iCLK		: in std_logic;
	iRST		: in std_logic;
	iInstAddr 	: in std_logic_vector(N-1 downto 0);
	o_F		: out std_logic_vector(N-1 downto 0));
end component;

component barShifter is
  port (i_A 	: in std_logic_vector(N-1 downto 0);
	i_LorR	: in std_logic;
	i_Ss 	: in std_logic_vector(4 downto 0);
	o_F 	: out std_logic_vector(N-1 downto 0));
end component;

component UpperImmediates is
port(largeVar	: in  std_logic_vector(31 downto 0); 
     lowerbits	: out std_logic_vector(15 downto 0); 
     upperbits	: out std_logic_vector(15 downto 0)); 
end component;

component ALU is
  port (i_read1      		: in std_logic_vector(N-1 downto 0);
        i_read2      		: in std_logic_vector(N-1 downto 0);
        i_control    		: in std_logic_vector(4-1 downto 0);
	i_overflow_enabled	: in std_logic;
        o_result      		: out std_logic_vector(N-1 downto 0);
        o_zero        		: out std_logic;
	o_overflow    		: out std_logic);
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
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

--Adder from PC
adderFromPC: add_sub
port MAP(i_A	=> "00000000000000000000000000000100",
     i_B 	=> iInstExt,
     S		=> '0', --CHANGE IF THIS IS SUBTRACTING CAUSE WE DONT KNOW FOR SURE
     o_Sum	=> s_AdderFromPC,
     o_Cout	=> s_Cout);

--Control Unit
 controller : control
  port MAP(	op_code	     		=> s_Inst(5 downto 0),
		fun       		=> s_Inst(N-1 downto N-7),
		reg_dst	     		=> s_Reg_Dst,
		jump	      		=> s_Jump,
		branch        		=> s_Branch,
		mem_read        	=> s_MemRead,
		mem_to_reg      	=> s_MemToReg,
		mem_write      		=> s_MemWrite,
		alu_src         	=> s_ALUsrc,
		reg_write         	=> s_RegWrite,
		o_overflow_enabled	=> s_overflowEnable,
        	alu_control    		=> s_ALUcontrol); 

--The first Barrel Shifter
ShiftFromInstMem: barShifter
  port MAP(i_A 	=> s_Inst(15 downto 11), --TODO: I'm suppoed to be the register to shift, but i may be too small
	i_LorR	=> '0', --TODO: I need to know which direction to go
	i_Ss 	=> s_Inst(20 downto 16),
	o_F 	=> s_InstShift);

--Register Destination Write Mux
  RegDestWrite: mux32_N
	port MAP(i_S    => s_Reg_Dst, 
       		i_D0   	=> s_Inst(20 downto 16),
       		i_D1 	=> s_Inst(15 downto 11),
       		o_O	=> s_RDWJL);

--Jump and Link Mux
--TODO: More work here
   JumpAndLink: mux32_N
	port MAP(i_S    => '0',--TODO:
       		i_D0   	=> s_RDWJL,
       		i_D1 	=> "00000000000000000000000000000000",--TODO: 
       		o_O	=> s_RegWrAddr); 

--Register File
register1: registerBoi
  port MAP(	i_CLK	    	=> iCLK,
		i_WriteEnable	=> s_RegWrite,
		i_RST		=> iRST,
		i_ReadReg1	=> s_Inst(25 downto 21),
		i_ReadReg2	=> s_Inst(20 downto 16),
		i_WriteReg	=> s_RegWrAddr,
		i_WriteData	=> s_RegWrData,
		o_ReadData1	=> s_RegReadData1,
		o_ReadData2	=> s_RegWrData);


--Extender
  Extender: extend
  port MAP(i_A	=> s_Inst(15 downto 0),
	i_S	=> '1',
	o_F	=> s_Extended);

--Shift from Reg File (technically its a shift from the extender but its already named so...)
ShiftFromRegFile: barShifter
  port MAP(i_A 	=> s_Extended,
	i_LorR	=> '0', --TODO: I need to know which direction to go
	i_Ss 	=> "00000", --TODO: I nede to know how far to shift the numbers
	o_F 	=> s_RegShift);

--Adder from the shifters
adderFromShifter: add_sub
port MAP(i_A	=> s_AdderFromPC,
     i_B 	=> s_RegShift,
     S		=> '0', --CHANGE IF THIS IS SUBTRACTING CAUSE WE DONT KNOW FOR SURE
     o_Sum	=> s_AdderFromShifter,
     o_Cout	=> s_CoutTrash); --Todo: figure out if Im actually needed

--Shift control Mux
  ShiftControl: mux32_N
	port MAP(i_S    => '0',--TODO: 
       		i_D0   	=> s_RegReadData1,
       		i_D1 	=> s_Inst,
       		o_O	=> s_ALURead1); 

--ALUSsrc control Mux
  ALUsrc: mux32_N
	port MAP(i_S    => s_ALUsrc,
       		i_D0   	=> s_RegWrData,
       		i_D1 	=> s_Extended, 
       		o_O	=> s_ALURead2);

--ALU
TheALU: ALU 
  port MAP(i_read1      	=> s_ALURead1,
        i_read2      		=> s_ALURead2,
        i_control    		=> s_ALUcontrol,
	i_overflow_enabled 	=> '0', --TODO: CHECK ME
        o_result     		=> s_DMemAddr,
        o_zero      		=> s_ALUzero,
	o_overflow   		=> s_Ovfl);

--And signal that controls one of the muxes
andControl: andg2
  port MAP(i_A        => s_ALUzero,
       i_B            => o_zero,
       o_F            => s_Andcontrol);

--Branch control Mux
  BranchControl: mux32_N
	port MAP(i_S    => s_Andcontrol, 
       		i_D0   	=> s_AdderFromPC,
       		i_D1 	=> s_AdderFromShifter,
       		o_O	=> s_BCtJC);

--Jump control mux
  JumpControl: mux32_N
	port MAP(i_S    => s_Jump, 
       		i_D0   	=> s_RegShift,
       		i_D1 	=> s_BCtJC, 
       		o_O	=> s_JCtJRC);

--Jump and Regisrer Control
  JumpReg: mux32_N
	port MAP(i_S    => '0',--TODO: 
       		i_D0   	=> s_JCtJRC,
       		i_D1 	=> s_RegReadData1, 
       		o_O	=> );--TODO: i SHould go back to the PC

--Memory to Register control mux
  MemtoReg: mux32_N
	port MAP(i_S    => s_MemToReg,
       		i_D0   	=> s_DMemOut,
       		i_D1 	=> s_DMemAddr,
       		o_O	=> s_MtRUI);

--Upper Immediate module
UpperImms: UpperImmediates
port MAP(largeVar	=> s_Extended,
     lowerbits	=> , 
     upperbits	=> );

--Upper immediate control mux
  UpperImmediate: mux32_N
	port MAP(i_S    => '0',--TODO: 
       		i_D0   	=> s_Extended,
       		i_D1 	=> s_MtRUI,
       		o_O	=> s_UItSLT);--TODO:

--Set on less than control mux
  SetOnLess: mux32_N
	port MAP(i_S    => '0',--TODO: 
       		i_D0   	=> "00000000000000000000000000000000",--TODO:
       		i_D1 	=> s_UItSLT, 
       		o_O	=> s_SLTtJALC);


--Jump and Link control mux
  JumpAndLinkDataWriter: mux32_N
	port MAP(i_S    => '0',--TODO: 
       		i_D0   	=> "00000000000000000000000000000000",--TODO:
       		i_D1 	=> s_SLTtJALC, 
       		o_O	=> s_RegWrData);

--Needed modules: PC+4, SLTU (will be added by Wednesday night, 11:59PM)
end structure;


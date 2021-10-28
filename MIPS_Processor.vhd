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

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment
 component overflowDetect
	port(	i_RS		: in std_logic; --NOTE: these are the MSB of RS, RT, and the adder output
		i_RT		: in std_logic;
		i_ADDresult	: in std_logic;
		o_Overflow	: out std_logic);
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
generic(N : integer := 32);
  port (i_read1      : in std_logic_vector(N-1 downto 0);
        i_read2      : in std_logic_vector(N-1 downto 0);
        i_control    : in std_logic_vector(4-1 downto 0);
        o_result      : out std_logic_vector(N-1 downto 0);
        o_zero        : out std_logic;
	o_overflow    : out std_logic);
end component;

component mux32_N is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
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

  -- TODO: Implement the rest of your processor below this comment! 

  MemtoReg: mux32_N
	port MAP(i_S    => --TODO: Connect this to the MemToReg from controller
       		i_D0   	=> s_DMemOut,
       		i_D1 	=> --TODO: connect this from the ALU output
       		o_O	=> );--TODO: connect this to the upper immediate control mux

  SetOnLess: mux32_N
	port MAP(i_S    => ,--TODO: 
       		i_D0   	=> ,--TODO:
       		i_D1 	=> ,--TODO: 
       		o_O	=> );--TODO: 

  JumpAndLinkDataWriter: mux32_N
	port MAP(i_S    => ,--TODO: 
       		i_D0   	=> ,--TODO:
       		i_D1 	=> ,--TODO: 
       		o_O	=> );--TODO: 

  RegDestWrite: mux32_N
	port MAP(i_S    => ,--TODO: 
       		i_D0   	=> ,--TODO:
       		i_D1 	=> ,--TODO: 
       		o_O	=> );--TODO: 

  JumpAndLink: mux32_N
	port MAP(i_S    => ,--TODO: 
       		i_D0   	=> ,--TODO:
       		i_D1 	=> ,--TODO: 
       		o_O	=> );--TODO: 

  ShiftControl: mux32_N
	port MAP(i_S    => ,--TODO: 
       		i_D0   	=> ,--TODO:
       		i_D1 	=> ,--TODO: 
       		o_O	=> );--TODO: 

  ALUsrc: mux32_N
	port MAP(i_S    => ,--TODO: 
       		i_D0   	=> ,--TODO:
       		i_D1 	=> ,--TODO: 
       		o_O	=> );--TODO: 

  JumpControl: mux32_N
	port MAP(i_S    => ,--TODO: 
       		i_D0   	=> ,--TODO:
       		i_D1 	=> ,--TODO: 
       		o_O	=> );--TODO: 

  JumpReg: mux32_N
	port MAP(i_S    => ,--TODO: 
       		i_D0   	=> ,--TODO:
       		i_D1 	=> ,--TODO: 
       		o_O	=> );--TODO: 

ShiftFromInstMem: barShifter
  port MAP(i_A 	=> , --TODO
	i_LorR	=> , --TODO
	i_Ss 	=> , --TODO
	o_F 	=> );--TODO

ShiftFromRegFile: barShifter
  port MAP(i_A 	=> , --TODO
	i_LorR	=> , --TODO
	i_Ss 	=> , --TODO
	o_F 	=> );--TODO

UpperImms: UpperImmediates
port MAP(largeVar	=> ,
     lowerbits	=> , 
     upperbits	=> );
end component;

end structure;


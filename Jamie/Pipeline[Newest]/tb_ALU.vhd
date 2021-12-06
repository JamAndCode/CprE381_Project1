library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_ALU is
generic(N : integer := 32);
  port(o_result : out std_logic_vector(N-1 downto 0);
       o_zero   : out std_logic);
end entity;


architecture structure of tb_ALU is
  component ALU is
    port (i_read1      : in std_logic_vector(N-1 downto 0);
        i_read2      : in std_logic_vector(N-1 downto 0);
        i_control    : in std_logic_vector(4-1 downto 0);
        o_result      : out std_logic_vector(N-1 downto 0);
        o_zero        : out std_logic;
	o_overflow    : out std_logic);
  end component;

  signal t_data1, t_data2 : std_logic_vector(N-1 downto 0);
  signal t_alu_code : std_logic_vector(4-1 downto 0);


 begin
    ALU_tb : ALU
      port map(i_read1	   => t_data1,
               i_read2   => t_data2,
               i_control => t_alu_code,
               o_result   => o_result,
               o_zero     => o_zero);

 process
    begin
      --Set the signals
      t_data1 <= x"FF006300";
      t_data2 <= x"F0011000";
      
      --AND
      t_alu_code <= "0000";
      wait for 10 ns;
      
      --OR
      t_alu_code <= "0001";
      wait for 10 ns;
      
     

      --Add
      t_alu_code <= "0010";
      wait for 10 ns;

      --Subtract
      t_alu_code <= "0110";
      wait for 10 ns;

 t_alu_code <= "0100";
      wait for 10 ns;


      
      
    end process;
end structure;
entity forward_unit is
port(
	Ex_Mem	:in std_logic_vector(4 downto 0);	//execution stage of data you want to write back
	Mem_Wb	:in std_logic_vector(4 downto 0);	//wb stage of data you want to write back
	Ex_Mem_Wr	:in std_logic;
	Mem_Wb_Wr		:in std_logic;
	ID_EX_r1		:in std_logic_vector(4 downto 0);
	ID_EX_r2		:in std_logic_vector(4 downto 0);
	foward_mux1		:out std_logic_vector(1 downto 0);
	foward_mux2		:out std_logic_vector(1 downto 0);

);

architecture structure of forward_unit is
	signal check	:std_logic;
	begin
		process(Ex_Mem_Wr,Mem_Wb_Wr,ID_EX_r1,Ex_Mem,Mem_Wb)
		begin
		elif(Ex_Mem_Wr='1' and ID_EX_r1=Ex_Mem) then
			foward_mux1="01";
		elif(Mem_Wb_Wr='1' and ID_EX_r1=Mem_Wb) then
			foward_mux1="10";
		else
		
		end process;
		
		process(Mem_Wb_Wr,Mem_Wb_Wr)
		begin
		elif(Ex_Mem_Wr='1' and ID_EX_r2=Ex_Mem) then
			foward_mux2="01";
		elif(Mem_Wb_Wr='1' and ID_EX_r2=Mem_Wb) then
			foward_mux2="10";
		else
		
		end process;

end structure;

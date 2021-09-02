-- Some portions of this code are based on code from the book "Digital Design and Computer Architecture" by Harris and Harris.
-- For educational purposes in TU Dortmund only.

library ieee;
use ieee.std_logic_1164.all;

entity mips_mem is
  port(
    clk: in std_logic;
    reset: in std_logic;
	instr_out: out std_logic_vector(31 downto 0)
  );
end;

architecture structure of mips_mem is
  component mips
  port(
    clk: in std_logic;
    reset: in std_logic;
    pc: buffer std_logic_vector(31 downto 0);
    instr: in std_logic_vector(31 downto 0);
    readdata: in std_logic_vector(31 downto 0);
    aluout: buffer std_logic_vector(31 downto 0);
    writedata: buffer std_logic_vector(31 downto 0);
    memwrite: out std_logic
  );
  end component;

  component instr_mem
    port (
		pc: in std_logic_vector(31 downto 0);
		instr: out std_logic_vector(31 downto 0)
	);
  end component;
  
  component data_memory
    generic (size : Integer := 63);
    port (
		clk : in std_logic;
		addr: in std_logic_vector(31 downto 0);
		data_in: in std_logic_vector(31 downto 0);
		memwrite : in std_logic;
		data_out: out std_logic_vector(31 downto 0)
	);
  end component;
  
  component dmem is
  port(
    clk, we: in std_logic;
    a, wd: in std_logic_vector (31 downto 0);
    rd: out std_logic_vector (31 downto 0)
  );
  end component;

  signal pc, instr, aluout, readdata, writedata: std_logic_vector(31 downto 0);
  signal memwrite : std_logic;
  
begin
  mips1 : mips port map(clk => clk, reset => reset, pc => pc, instr => instr, readdata => readdata, aluout => aluout, writedata => writedata, memwrite => memwrite);
  
  mem_instr : instr_mem port map(pc => pc, instr => instr);
  
  mem_data : data_memory generic map(size => 8192)
	port map(clk => clk, addr => aluout, data_in => writedata, memwrite => memwrite, data_out => readdata);
  
  instr_out <= instr;
  
  --data : dmem port map (clk => clk, we => memwrite, a => aluout, wd => writedata, rd => readdata);
end;






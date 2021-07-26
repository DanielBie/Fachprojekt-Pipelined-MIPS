-- Some portions of this code are based on code from the book "Digital Design and Computer Architecture" by Harris and Harris.
-- For educational purposes in TU Dortmund only.

library ieee;
use ieee.std_logic_1164.all;

entity mips_instr_mem is
  port(
    clk: in std_logic;
    reset: in std_logic;
    readdata: in std_logic_vector(31 downto 0);
    aluout: buffer std_logic_vector(31 downto 0);
    writedata: buffer std_logic_vector(31 downto 0);
    memwrite: out std_logic
  );
end;

architecture structure of mips_instr_mem is
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

  signal pc, instr: std_logic_vector(31 downto 0);
  
begin
  mips1 : mips port map(clk => clk, reset => reset, pc => pc, instr => instr, readdata => readdata, aluout => aluout, writedata => writedata, memwrite => memwrite);
  
  mem_instr : instr_mem port map(pc => pc, instr => instr);
end;

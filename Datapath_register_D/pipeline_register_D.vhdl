-- Some portions of this code are based on code from the book "Digital Design and Computer Architecture" by Harris and Harris.
-- For educational purposes in TU Dortmund only.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline_register_D is
  port (
    clk: in std_logic;
    instr: in std_logic_vector(31 downto 0);
	PCPlus4: in std_logic_vector(31 downto 0);
    instrD: out std_logic_vector(31 downto 0);
    PCPlus4D: out std_logic_vector(31 downto 0)
  );
end;

architecture behavior of pipeline_register_D is
  type ramtype is array (1 downto 0) of std_logic_vector(31 downto 0);
  signal mem: ramtype;
begin
  process(clk) begin
    if rising_edge(clk) then
      mem(0) <= instr;   --speichere instr an index 0
	  mem(1) <= PCPlus4; --speichere PCPlus4 an index 0
    end if;
  end process;

  instrD <= mem(0);  
  PCPlus4D <= mem(1);
  
end;

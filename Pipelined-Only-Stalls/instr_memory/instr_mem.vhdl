-- Some portions of this code are based on code from the book "Digital Design and Computer Architecture" by Harris and Harris.
-- For educational purposes in TU Dortmund only.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_mem is
    port (
        pc: in std_logic_vector(31 downto 0);
        instr: out std_logic_vector(31 downto 0)
    );
end;

architecture behavior of instr_mem is
    type ramtype is array (255 downto 0) of std_logic_vector(31 downto 0);
    signal mem: ramtype;
begin

    process(pc) begin
        instr <= mem(to_integer(unsigned(pc(31 downto 2))));
        
    end process;
end;

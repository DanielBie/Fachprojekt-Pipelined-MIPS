-- Some portions of this code are based on code from the book "Digital Design and Computer Architecture" by Harris and Harris.
-- For educational purposes in TU Dortmund only.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is
  generic (size : Integer := 63);
  port (
    clk : in std_logic;
    addr: in std_logic_vector(31 downto 0);
	data_in: in std_logic_vector(31 downto 0);
	memwrite : in std_logic;
	data_out: out std_logic_vector(31 downto 0)
  );
end;

architecture behavior of data_memory is
  -- type ramtype is array (size downto 0) of std_logic_vector(7 downto 0);
  -- signal mem: ramtype;
  type ramtype is array (size downto 0) of std_logic_vector(31 downto 0);
  signal mem: ramtype;
begin
	
	-- process(clk,addr) begin
      -- if rising_edge(clk) then
        -- if memwrite = '1' then
			-- mem(to_integer(unsigned(addr))+3) <= data_in(31 downto 24);
			-- mem(to_integer(unsigned(addr))+2) <= data_in(23 downto 16);
			-- mem(to_integer(unsigned(addr))+1) <= data_in(15 downto 8);
			-- mem(to_integer(unsigned(addr))) <= data_in(7 downto 0);
        -- end if;
      -- end if;
    -- end process;

    -- process(addr) begin
	  -- if to_integer(unsigned(addr)) < size then
	  -- data_out <= mem(to_integer(unsigned(addr))+3) &
			 -- mem(to_integer(unsigned(addr))+2) &
			 -- mem(to_integer(unsigned(addr))+1) &
			 -- mem(to_integer(unsigned(addr)));
	  -- else
	    -- data_out <= x"00000000";
	  -- end if;
	  
	  process(clk,addr) begin
      if rising_edge(clk) then
        if memwrite = '1' then
			mem(to_integer(unsigned(addr(31 downto 2)))) <= data_in;
        end if;
      end if;
    end process;

    process(clk,addr) begin
	  if to_integer(unsigned(addr(31 downto 2))) < size then
	  data_out <= mem(to_integer(unsigned(addr(31 downto 2))));
	  else
	    data_out <= x"00000000";
	  end if;
	
  end process;
end;



library ieee;
use ieee.std_logic_1164.all;

entity Hazard_Unit is
  port(
    RsE: in std_logic_vector(4 downto 0);
    RtE: in std_logic_vector(4 downto 0);
    RegWriteM: in std_logic;
    RegWriteW: in std_logic;
    WriteRegM: in std_logic_vector(4 downto 0);
    WriteRegW: in std_logic_vector(4 downto 0);
	ForwardAE: out std_logic_vector(1 downto 0);
	ForwardBE: out std_logic_vector(1 downto 0)
  );
end;

architecture behavior of Hazard_Unit is
  --signal ...
begin
  process (RsE, RtE, RegWriteM, RegWriteW, WriteRegM, WriteRegW) begin
	  if ((RsE /= "00000") and (RsE = WriteRegM) and (RegWriteM = '1')) then 
		ForwardAE <= "10";
	  elsif((RsE /= "00000") and (RsE = WriteRegW) and (RegWriteW = '1')) then 
		ForwardAE <= "01";
	  else ForwardAE <= "00";
	  end if;
	  
	  if ((RtE /= "00000") and (RtE = WriteRegM) and (RegWriteM = '1')) then 
		ForwardBE <= "10";
	  elsif((RtE /= "00000") and (RtE = WriteRegW) and (RegWriteW = '1')) then 
		ForwardBE <= "01";
	  else ForwardBE <= "00";
	  end if;
  end process;
end;
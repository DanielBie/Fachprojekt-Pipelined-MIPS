library ieee;
use ieee.std_logic_1164.all;

entity Hazard_Unit is
    port (
        RsE       : in std_logic_vector(4 downto 0);
        RtE       : in std_logic_vector(4 downto 0);
        RsD       : in std_logic_vector(4 downto 0);
        RtD       : in std_logic_vector(4 downto 0);
		RegWriteE : in std_logic;
        RegWriteM : in std_logic;
        RegWriteW : in std_logic;
        MemtoRegE : in std_logic;
		MemtoRegM : in std_logic;
		WriteRegE : in std_logic_vector(4 downto 0);
        WriteRegM : in std_logic_vector(4 downto 0);
        WriteRegW : in std_logic_vector(4 downto 0);
		BranchD   : in std_logic;
        ForwardAE : out std_logic_vector(1 downto 0);
        ForwardBE : out std_logic_vector(1 downto 0);
		ForwardAD : out std_logic;
        ForwardBD : out std_logic;
        StallF    : out std_logic;
        StallD    : out std_logic;
        FlushE    : out std_logic
    );
end;

architecture behavior of Hazard_Unit is
    signal lwstall, branchstall : std_logic;
begin
	
	--Forwarding D
	process (RsD, RtD, WriteRegM, RegWriteM, BranchD, RegWriteE, WriteRegE, MemtoRegM)begin
		if ( (RsD /= "00000") AND (RsD = WriteRegM) AND (RegWriteM = '1') ) then
			ForwardAD <= '1';
		else
			ForwardAD <= '0';
		end if;
		
		if ( (RtD /= "00000") AND (RtD = WriteRegM) AND (RegWriteM = '1') ) then
			ForwardBD <= '1';
		else
			ForwardBD <= '0';
		end if;
		
		if ( (BranchD = '1' AND RegWriteE = '1' AND (WriteRegE = RsD OR WriteRegE = RtD) ) OR ( BranchD = '1' AND MemtoRegM = '1' AND (WriteRegM = RsD OR WriteRegM = RtD) ) ) then
			branchstall <= '1';
		else
			branchstall <= '0';
		end if;
		
	end process;

    --Forwarding E
    process (RsE, RtE, RegWriteM, RegWriteW, WriteRegM, WriteRegW) begin
        if ((RsE /= "00000") and (RsE = WriteRegM) and (RegWriteM = '1')) then
            ForwardAE <= "10";
        elsif ((RsE /= "00000") and (RsE = WriteRegW) and (RegWriteW = '1')) then
            ForwardAE      <= "01";
        else ForwardAE <= "00";
        end if;
		
		if ((RtE /= "00000") and (RtE = WriteRegM) and (RegWriteM = '1')) then
            ForwardBE <= "10";
        elsif ((RtE /= "00000") and (RtE = WriteRegW) and (RegWriteW = '1')) then
            ForwardBE      <= "01";
        else ForwardBE <= "00";
        end if;
    end process;

	--Stalling
  	process (RsD, RtE, RtD, MemToRegE) begin
		if (((RsD = RtE) or (RtD = RtE)) and (MemToRegE = '1')) then
			lwstall <= '1';
		else 
			lwstall <= '0';
		end if;
		-- lwstall <= (((RsD = RtE) or (RtD = RtE)) and (MemToRegE = '1'));
	end process;

    StallF <= lwstall OR branchstall;
    StallD <= lwstall OR branchstall;
    FlushE <= lwstall OR branchstall;
end;
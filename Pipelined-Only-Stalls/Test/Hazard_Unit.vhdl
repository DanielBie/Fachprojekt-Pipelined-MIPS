library ieee;
use ieee.std_logic_1164.all;

entity Hazard_Unit is
    port (
        clk       : in std_logic;
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
    signal lwstall, branchstall, rawstall, stallbita, stallbitb, branchstallA, branchstallB, branchstallC : std_logic;
begin
	
	--Forwarding D
	process (RsD, RtD, WriteRegM, RegWriteM, BranchD, RegWriteE, WriteRegE, MemtoRegM)begin
		-- if ( (RsD /= "00000") AND (RsD = WriteRegM) AND (RegWriteM = '1') ) then
			-- branchstallA <= '1';
		-- else
			-- branchstallA <= '0';
		-- end if;
		
		-- if ( (RtD /= "00000") AND (RtD = WriteRegM) AND (RegWriteM = '1') ) then
			-- branchstallB <= '1';
		-- else
			-- branchstallB <= '0';
		-- end if;
		
		if ( (BranchD = '1' AND RegWriteE = '1' AND (WriteRegE = RsD OR WriteRegE = RtD) ) OR ( BranchD = '1' AND MemtoRegM = '1' AND (WriteRegM = RsD OR WriteRegM = RtD) ) ) then
			branchstall <= '1';
		else
			branchstall <= '0';
		end if;
		-- branchstall <= branchstallA OR branchstallB OR branchstallC;
		
	end process;

    --Forwarding E
    process (clk, RsD, RtD, RegWriteE, RegWriteM, WriteRegE, WriteRegM) begin
		if ((RsD /= "00000") and (RsD = WriteRegE) and (RegWriteE = '1')) then
			stallbita <= '1';
		elsif ((RsD /= "00000") and (RsD = WriteRegM) and (RegWriteM = '1')) then
			stallbita <= '1';
		else 
			stallbita <= '0';
		end if;
		
		if ((RtD /= "00000") and (RtD = WriteRegE) and (RegWriteE = '1')) then
			stallbitb <= '1';
		elsif ((RtD /= "00000") and (RtD = WriteRegM) and (RegWriteM = '1')) then
			stallbitb <= '1';
		else 
			stallbitb <= '0';
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

    ForwardAE <= "00";
    ForwardBE <= "00";
	ForwardAD <= '0';
    ForwardBD <= '0';
	
	rawstall <= stallbita OR stallbitb;

    StallF <= lwstall OR branchstall OR rawstall;
    StallD <= lwstall OR branchstall OR rawstall;
    FlushE <= lwstall OR branchstall OR rawstall;
end;
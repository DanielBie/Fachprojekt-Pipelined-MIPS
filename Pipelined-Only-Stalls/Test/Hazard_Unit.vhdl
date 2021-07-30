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
    signal lwstall, branchstall, rawstall, stallbita, stallbitb, stallbit : std_logic;
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
    process (clk, RsD, RtD, RegWriteE, RegWriteM, WriteRegE, WriteRegM) begin
        if(stallbit = '1') then
            if (rising_edge(clk)) then
                stallbit <= '0';
                rawstall <= '1';
                stallbita <= '0';
                stallbitb <= '0';
            end if;
        else
            rawstall <= '0';
            if ((RsD /= "00000") and (RsD = WriteRegE) and (RegWriteE = '1')) then
                rawstall <= '1';
                stallbita <= '1';
            elsif ((RsD /= "00000") and (RsD = WriteRegM) and (RegWriteM = '1')) then
                rawstall <= '1';
                stallbita <= '0';
            else 
                rawstall <= '0';
                stallbita <= '0';
            end if;
            
            if ((RtD /= "00000") and (RtD = WriteRegE) and (RegWriteE = '1')) then
                rawstall <= '1';
                stallbitb <= '1';
            elsif ((RtD /= "00000") and (RtD = WriteRegM) and (RegWriteM = '1')) then
                rawstall <= '1';
                stallbitb <= '0';
            else 
                rawstall <= '0';
                stallbitb <= '0';
            end if;
        end if;
        stallbit <= stallbita OR stallbitb;
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

    -- process (clk) begin
    --     if (rising_edge(clk)) then
    --         if(stallbit = '1') then
	--             assert false report "In here Stuff";
    --             stallbit <= '0';
    --             -- rawstall <= '1';
    --         end if;
    --     end if;
    -- end process;


    ForwardAE <= "00";
    ForwardBE <= "00";

    StallF <= lwstall OR branchstall OR rawstall;
    StallD <= lwstall OR branchstall OR rawstall;
    FlushE <= lwstall OR branchstall OR rawstall;
end;
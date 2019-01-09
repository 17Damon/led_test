library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity pre_jitter is
port (
	clk_50MHz : in std_logic;
	k1_in  : in std_logic;
	k1_out : out std_logic;
	k1_posedge : out std_logic;
	k1_negedge : out std_logic
);
end entity pre_jitter;
architecture prevent_jitter of pre_jitter is
signal k1_sig : std_logic := '1';
signal k1_posedge_sig : std_logic;
signal k1_negedge_sig : std_logic;

begin
	k1_out <= k1_sig;
	k1_posedge <= k1_posedge_sig;
	k1_negedge <= k1_negedge_sig;
	process(clk_50MHz, k1_in)
		variable count : natural range 0 to 1000000 := 0;
		variable pressed : std_logic := '0'; -- 1 is pressed
		variable jitter : std_logic := '0'; -- 1 is jitter
		begin
			if rising_edge(clk_50MHz) then
				if(jitter = '1') then
					if (pressed = '1') then
						if (count < 1000000) then
							count := count + 1;
							k1_sig <= '1';
							k1_negedge_sig <= '0';
							k1_posedge_sig <= '0';
						else
							k1_negedge_sig <= '1';
							k1_sig <= '0';
							jitter := '0';
						end if;
					else -- pressed is '0' 
						if (count < 1000000) then
							count := count + 1;
							k1_negedge_sig <= '0';
							k1_posedge_sig <= '0';
							k1_sig <= '0';
						else
							k1_posedge_sig <= '1';
							k1_sig <= '1';
							jitter := '0';
						end if;
					end if;
				else -- jitter is '0'
					if (pressed = '0') then
						k1_sig <= '1';
						k1_negedge_sig <= '0';
						k1_posedge_sig <= '0';
						if (k1_in = '0') then
							pressed := '1';
							count := 0;
							jitter := '1';
						end if;
					else -- pressed is '1'
						k1_sig <= '0';
						k1_negedge_sig <= '0';
						k1_posedge_sig <= '0';
						if(k1_in = '1') then
							pressed := '0';
							count := 0;
							jitter := '1';
						end if;
					end if;
				end if;
			end if;
		end process;	
end prevent_jitter;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity led_tube is
port (
	clk_50MHz : in std_logic;
	k1_negedge : in std_logic;
	led : out std_logic_vector(3 downto 0);
	tube : out std_logic_vector(7 downto 0);
	tube_0 : out std_logic
);
end entity led_tube;
architecture beh of led_tube is
signal led_sig : std_logic_vector(3 downto 0);
signal led_r_sig : std_logic_vector(3 downto 0);
signal tube_sig : std_logic_vector(7 downto 0);
signal tube_r_sig : std_logic_vector(7 downto 0);

begin
	tube_0 <= '0';
	led <= led_r_sig;
	tube <= tube_r_sig;
	process(clk_50MHz, k1_negedge)
	variable code_var : natural range 0 to 100000 := 0;
		begin
			if (k1_negedge = '1') then
				if rising_edge(clk_50MHz) then
					code_var := code_var + 1;
					if (code_var > 3) then
						code_var := 0;
					end if;
				end if;
			else
				code_var := code_var;
			end if;
			
			case (code_var) is
					when 0 =>  tube_sig <= "11000000"; led_sig <= "0000";
					when 1 =>  tube_sig <= "11111001"; led_sig <= "0001";
					when 2 =>  tube_sig <= "10100100"; led_sig <= "0011";
					when 3 =>  tube_sig <= "10110000"; led_sig <= "0111";
					when others =>  tube_sig <= "10011001"; led_sig <= "1111";
			end case;
		end process;
		
	process(clk_50MHz)
		begin
			led_r_sig <= led_sig;
			tube_r_sig <= tube_sig;
		end process;
end beh;
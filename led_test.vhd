library WORK;
library IEEE;
use IEEE.std_logic_1164.all;
entity led_test is
port (
	k1 : in std_logic;
	rst : in std_logic;
	clk_50MHz : in std_logic;
	led : out std_logic_vector(3 downto 0);
	tube : out std_logic_vector(7 downto 0);
	tube_0 : out std_logic;
	beep : out std_logic
);
end entity led_test;
architecture beh of led_test is
signal k1_sig : std_logic;
signal k1_posedge_sig : std_logic;
signal k1_negedge_sig : std_logic;

component pre_jitter
port (
	clk_50MHz : in std_logic;
	k1_in : in std_logic;
	k1_out : out std_logic;
	k1_posedge : out std_logic;
	k1_negedge : out std_logic
);
end component;

component led_tube
port (
	clk_50MHz : in std_logic;
	k1_negedge : in std_logic;
	led : out std_logic_vector(3 downto 0);
	tube : out std_logic_vector(7 downto 0);
	tube_0 : out std_logic
);
end component;

component speaker is
port (
	clk_50MHz : in std_logic;
	k1_negedge : in std_logic;
	beep : out std_logic
);
end component;

begin
	U1:pre_jitter port map(clk_50MHz, k1, k1_sig, k1_posedge_sig, k1_negedge_sig);
	U2:led_tube port map(clk_50MHz, k1_negedge_sig, led, tube, tube_0);
	U3:speaker port map(clk_50MHz, k1_negedge_sig, beep);
end beh;

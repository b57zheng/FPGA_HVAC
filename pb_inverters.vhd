library ieee;
use ieee.std_logic_1164.all;

entity pb_inverters is 
port (
	pb_n 					: in std_logic_vector(3 downto 0);
	vacation_mode		: out std_logic;
	MC_test_mode		: out std_logic;
	window_open			: out std_logic;
	door_open			: out std_logic
	);
	
	end pb_inverters;
	
	architecture gates of pb_inverters is
	
	begin

	vacation_mode <= not(pb_n(3));
	MC_test_mode  <= not(pb_n(2));	
	window_open	  <= not(pb_n(1));	
	door_open     <= not(pb_n(0));
	
	end gates;
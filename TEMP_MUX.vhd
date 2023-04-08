library ieee;
use ieee.std_logic_1164.all;

entity TEMP_MUX is port 
(
	desired_temp	: in std_logic_vector (3 downto 0);
	vacation_temp	: in std_logic_vector (3 downto 0);
	vacation_mode	: in std_logic;
	mux_temp			: out std_logic_vector (3 downto 0)
	);
	end TEMP_MUX;

	ARCHITECTURE selection of TEMP_MUX is 
	
	begin 
	
	with vacation_mode select
		
		mux_temp <= desired_temp when '0',
						vacation_temp when '1';
	end selection;
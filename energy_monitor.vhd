library ieee;
use ieee.std_logic_1164.all;

entity energy_monitor is port 
(
	AGTB						: in std_logic;
	AEQB						: in std_logic;
	ALTB						: in std_logic;
	vacation_mode			: in std_logic;
	MC_test_mode			: in std_logic;
	window_open				: in std_logic;
	door_open				: in std_logic;
	furnace					: out std_logic;
	at_temp					: out std_logic;
	AC							: out std_logic;
	blower					: out std_logic;
	window					: out std_logic;
	door						: out std_logic;
	vacation					: out std_logic;
	run						: out std_logic;
	increase					: out std_logic;
	decrease					: out std_logic
	);
	end energy_monitor;
	
	
	
	ARCHITECTURE control OF energy_monitor IS 
		begin
--		
--		process (AGTB)
--		begin 
--		
--			if (AGTB = '1') then
--			-- if A is greater than B, run is ON and we increase the counter
--				run <= '1';
--				increase <= '1';
--				decrease <= '0';
--			-- A greater than B the led for furnace should be ON
--				furnace <= '1';
--			-- blower is on whenever A is different from B
--				blower <= '1';
--			end if;
--
--		end process;
--
--		process (AEQB)
--		begin
--		-- if A is equal to B, run is OFF and the counter does not change
--			if (AEQB = '1') then 
--				run <= '0';
--				increase <='0';
--				decrease <= '0';
--		-- A equal to B, led for at_temp should be on and blower should be off
--				at_temp <= '1';
--				blower <= '0';
--			end if;
--		end process;
--		
--		
--		process (ALTB)
--		begin 
--		-- if A less than B, run is OFF and we decrease the counter
--			if (ALTB = '1') then
--				run <= '1';
--				increase <= '0';
--				decrease <= '1';
--		-- A is less than B, led for AC should be ON
--				AC <= '1';
--		-- blower is on whenever A is different from B
--				blower <= '1';
--			end if;
--		end process;
--		
--		
--		-- if the door or window is open we don't run the HVAC
--		process (window_open)
--		begin 
--			if (window_open = '1') then
--				run <= '0';
--			-- turn on window led
--				window <= '1';
--			-- blower is OFF when window is open
--				blower <= '0';
--			end if; 
--		end process;
--		
--	
--		process (door_open)
--		begin
--			if (door_open ='1') then 
--				run <= '0';
--			-- turn on door led
--				door <= '1';
--			-- blower is oFF when door is open
--				blower <= '0';
--			end if;
--		end process;
--		
--		
--		--to test the comparator
--		process (MC_test_Mode)
--		begin
--			if (MC_test_mode = '1') then
--		-- stop running
--				run <= '0';
--			-- blower OFF when MC_test_mode is ON
--			blower <= '0';
--			end if;
--		end process;
--			
--		process (vacation_mode)
--		begin
--			if (vacation_mode = '1') then
--			-- led for vacation is ON when vacation_mode is ON
--				vacation <= '1';
--			end if;
--		end process;
--		
		process (AGTB, AEQB, ALTB, window_open, door_open, vacation_mode, MC_test_mode)
		begin 
		-- Default values
			run <= '0';

			if (AGTB = '1') then
			increase <= '1';
			decrease <= '0';
			furnace <= '1';
			else 
			increase <= '0';
			furnace <= '0';
			end if;
			
			if (ALTB = '1') then
		  increase <= '0';
		  decrease <= '1';
		  AC <= '1';
		
		  else 
		  decrease <= '0';
			AC<= '0';
			
			end if;

			if (AEQB = '1' OR MC_test_mode = '1' OR window_open = '1' OR door_open = '1') then 
			run <= '0';
			else 
			run <= '1';
			end if;

			if (AEQB = '1') then 
			blower <= '0';
			at_temp <= '1';
			else 
			blower <= '1';
			at_temp <= '0';
			end if ;
			
			if (AEQB = '0' AND NOT (MC_test_mode = '1' OR window_open = '1' OR door_open = '1')) then 
			blower <= '1';
			else 
			blower <= '0';
			end if;
			
			if (door_open ='1') then 
			door <= '1';
			else
			door <= '0';
			end if;
			
			if (window_open = '1') then 
			window <= '1';
			else 
			window <= '0';
			end if;
			
			if (vacation_mode = '1') then 
			vacation <='1';
			else 
			vacation <='0';
			end if;
			
			
			
		end process;

		
end control;
	
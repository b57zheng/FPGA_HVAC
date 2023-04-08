library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hvac_unit is port 
(
	HVAC_SIM 		:in boolean;
	clk				:in std_logic;
	run				:in std_logic;
	increase			:in std_logic;
	decrease			:in std_logic;
	temp				:out std_logic_vector(3 downto 0)
	); 
	
	end hvac_unit;
	
	ARCHITECTURE rtl OF hvac_unit IS 
	
	signal clk_2hz				: std_logic;
	signal HVAC_clock			: std_logic;
	signal digital_counter 	: std_logic_vector(23 downto 0);
	
	begin
	
	-- clk divider process generates a 2Hz Clck from the 50 Mhz clk
	
	clk_divider: process (clk)
		variable counter			: unsigned(23 downto 0);
		
		begin
		
	-- Synchronously update counter
	
			if (rising_edge(clk)) then 
						counter := counter +1;
			end if;
			
			digital_counter <= std_logic_vector(counter);
			
		end process;
		
	clk_2hz <= digital_counter(23);
	
	clk_mux: process(HVAC_SIM)
			begin
				if (HVAC_SIM) then 
						HVAC_clock <= clk;
				else 
						HVAC_clock <= clk_2hz;
				end if;
				
			end process;
			
	counter: process (HVAC_clock)
			variable cnt		: unsigned(3 downto 0) := "0111";
			
			begin
			
			-- Synchronously update counter
			-- add HVAC counter for temp
			if (cnt < "1111")	then
				if 	(cnt > "0000") then 
					if (run = '1') then
			
						if (increase = '1') then
				
						cnt := cnt+1;
				
						elsif (decrease = '1') then 
						
							cnt := cnt -1;
					
						end if;
				
					end if;
				
				end if;
				
			end if;
	

			-- Output the current count
				temp <= std_logic_vector(cnt);
			end process;
			
		end rtl;
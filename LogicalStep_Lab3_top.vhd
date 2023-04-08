library ieee;
use ieee.std_logic_1164.all;


entity LogicalStep_Lab3_top is port (
	clkin_50		: in 	std_logic;
	pb_n			: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 	
	
	----------------------------------------------------
--	HVAC_temp : out std_logic_vector(3 downto 0); -- used for simulations only. Comment out for FPGA download compiles.
	----------------------------------------------------
	
   leds			: out std_logic_vector(7 downto 0);
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  : out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is
--
-- Provided Project Components Used
------------------------------------------------------------------- 

component SevenSegment  port (
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end component SevenSegment;

component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
        );
end component segment7_mux;

component compx4 port(
	A : in std_logic_vector(3 downto 0);
	B : in std_logic_vector(3 downto 0);
	AGTB_out : out std_logic;
	AEQB_out : out std_logic;
	ALTB_out : out std_logic
	);
	end component compx4;
	
	
component Bidir_shift_reg is port
(
	CLK				: in std_logic := '0';
	RESET				: in std_logic := '0';
	CLK_EN			: in std_logic := '0';
	LEFT0_RIGHT1	: in std_logic := '0';
	REG_BITS			: out std_logic_vector(7 downto 0)
	);
	end component Bidir_shift_reg;
	
component U_D_Bin_Counter8bit is port 
(

	CLK				: in std_logic;
	RESET				: in std_logic;
	CLK_EN			: in std_logic;
	UP1_DOWN0		: in std_logic;
	COUNTER_BITS	: out std_logic_vector(7 downto 0)
	);
	
	end component;
	
component pb_inverters is port 
(
	pb_n 					: in std_logic_vector(3 downto 0);
	vacation_mode		: out std_logic;
	MC_test_mode		: out std_logic;
	window_open			: out std_logic;
	door_open			: out std_logic
	);
	end component;

component TEMP_MUX is port 
(
	desired_temp	: in std_logic_vector (3 downto 0);
	vacation_temp	: in std_logic_vector (3 downto 0);
	vacation_mode	: in std_logic;
	mux_temp			: out std_logic_vector (3 downto 0)
	);
	end component;

component energy_monitor is port 
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
	end component;

component Tester port (
 	MC_TESTMODE				: in  std_logic;
   I1EQI2,I1GTI2,I1LTI2	: in	std_logic;
	input1					: in  std_logic_vector(3 downto 0);
	input2					: in  std_logic_vector(3 downto 0);
	TEST_PASS  				: out	std_logic							 
	); 
end component;

component HVAC port (
	HVAC_SIM					: in boolean;
	clk						: in std_logic; 
	run		   			: in std_logic;
	increase, decrease	: in std_logic;
	temp						: out std_logic_vector (3 downto 0)
	);
end component;
------------------------------------------------------------------
-- Add any Other Components here
------------------------------------------------------------------

------------------------------------------------------------------	
-- Create any additional internal signals to be used
------------------------------------------------------------------
signal current_temp 	: std_logic_vector(3 downto 0);
signal mux_temp		: std_logic_vector(3 downto 0);
signal vacation_temp	: std_logic_vector(3 downto 0);
signal vacation_mode	: std_logic;
signal MC_test_mode	: std_logic;
signal window_open	: std_logic;
signal door_open		: std_logic;
signal decrease		: std_logic;
signal increase		: std_logic;
signal run				: std_logic;
signal AGTB				: std_logic;
signal AEQB				: std_logic;
signal ALTB				: std_logic;
signal mt_7seg			: std_logic_vector(6 downto 0);
signal ct_7seg			: std_logic_vector(6 downto 0);


constant HVAC_SIM : boolean := FALSE; -- set to FALSE when compiling for FPGA download to LogicalStep board 
                                      -- or TRUE for doing simulations with the HVAC Component
------------------------------------------------------------------	

-- global clock
signal clk_in					: std_logic;
signal hex_A, hex_B 			: std_logic_vector(3 downto 0);
signal hexA_7seg, hexB_7seg: std_logic_vector(6 downto 0);
------------------------------------------------------------------- 
begin -- Here the circuit begins

clk_in <= clkin_50;	--hook up the clock input

-- temp inputs hook-up to internal busses.
hex_A <= sw(3 downto 0);
hex_B <= sw(7 downto 4);

inst1:  sevensegment 		port map (mux_temp, mt_7seg);
inst2:  sevensegment 		port map (current_temp, ct_7seg);
inst3:  segment7_mux 		port map (clk_in, mt_7seg, ct_7seg, seg7_data, seg7_char2, seg7_char1);
inst4:  compx4	  				port map (mux_temp, current_temp, AGTB, AEQB, ALTB);
--inst5: Bidir_shift_reg 		port map (clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0)); --NOT inverts pb signal
--inst6: U_D_Bin_Counter8bit port map (clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0)); -- when UP1_DOWN0 is 1 count up, when 0 count down
inst7:  HVAC 					port map (HVAC_SIM, clkin_50, run, increase, decrease, current_temp);
inst8:  pb_inverters			port map (pb_n, vacation_mode, MC_test_mode, window_open, door_open);
inst9:  TEMP_MUX 			   port map (hex_A, hex_B, vacation_mode, mux_temp);
inst10: energy_monitor 		port map	(AGTB, AEQB, ALTB, vacation_mode, MC_test_mode, window_open, door_open, leds(0), leds(1), leds(2), leds(3), leds(4), leds(5), leds(7), run, increase, decrease);
inst11: Tester 				port map (MC_test_mode, AEQB, AGTB, ALTB, hex_A, current_temp, leds(6));

end design;


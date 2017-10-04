-- **************************************************************************
-- Name: 			Shawn Cramp
-- Student ID: 	111007290
-- Name:				Edward Huang
-- Student ID:		100949380
-- Name:				Bruno Salapic
-- Student ID:		100574460
-- Version: 		2014-11-23
-- Description:	Main State Machine VHD File for Traffic Lights
-- **************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Entity_Traffic is
	port ( 	
				-- Reset and Clock Pulse
				Reset				: in std_logic;
				Clock_1Hz		: in std_logic;
				
				-- Day/Night cycle trigger
				Day_Night		: in std_logic; 
				Night_Flash		: in std_logic; -- Flashing Red and Yellow
				
				-- Triggers for cars turning left at lights
				Left_Queue_NS	: in std_logic_vector(1 downto 0);
				Left_Queue_EW	: in std_logic_vector(1 downto 0);
				
				-- Counter for timing state changes
				Counter			: in std_logic_vector(4 downto 0);
				
				-- Used to send current state to other chips
				Current_State	: buffer std_logic_vector(4 downto 0);
				Current_State_Test	: out std_logic_vector(4 downto 0);
				
				-- Resets counter upon state change
				Counter_Reset 	: out std_logic
			);
end entity Entity_Traffic;

architecture arch_TrafficLights of Entity_Traffic is
-- **************************************************************************
	-- A0: Advance from South turning West, A1: Advance from West turning North, A2: Advance from North Turning East
	-- A3: Advance from East turning South, A4: Advance from North and South, A5: Advance from West and East
	
	-- N0 -> N5: Standard Night Cycle with no Cross Walk
	-- N6: Flashing Yellow and Red Night State
	
-- **************************************************************************
	
	-- States for Main StateMachine
	type State_Type is (S0, S1, S2, S3, S4, S5, A0, A1, A2, A3, A4, A5, N0, N1, N2, N3, N4, N5, N6);
	signal State 			: State_Type;
	
	signal Counter_Reset_I 	: std_logic; -- Counter Reset value holder
	
	-- All Switch Constants (All zero now with reversal of clock counting down instead of up)
	-- To shorten cycles change reset values in Counter.VHD
	constant Advance_Switch			: std_logic_vector(4 downto 0)	:= "00000"; -- 4 Seconds of Advance Green
	constant Green_Switch			: std_logic_vector(4 downto 0)	:= "00000"; -- 2 Seconds of Red Light before Green Switch
	constant Yellow_Switch_NS 		: std_logic_vector(4 downto 0) 	:= "00000"; -- 25 Seconds of Green Light before Yellow Switch
	constant Yellow_Switch_EW 		: std_logic_vector(4 downto 0) 	:= "00000"; -- 20 Seconds of Green Light before Yellow Switch
	constant Red_Switch 				: std_logic_vector(4 downto 0) 	:= "00000"; -- 5 Seconds of Yellow Light before Red Switch
	
	constant Yellow_Switch_NS_Night 		: std_logic_vector(4 downto 0) 	:= "00000"; -- 32 Seconds of Green Light for NS before Yellow
	constant Yellow_Switch_EW_Night 		: std_logic_vector(4 downto 0) 	:= "00000"; -- 10 Seconds of Green Light for EW before Yellow
	
	
begin

process (Counter, Reset, State)
begin
	-- Reset State for Restarting State Machine
	if Reset = '1' then
		State <= S0;
	elsif ((rising_edge(Clock_1hz)) and Counter_Reset_I = '1') then
	-- Change reset back to 0 to initiate the clock count down
		Counter_Reset_I <= '0';
	elsif (rising_edge(Clock_1hz)) then
		case State is
			
			-- Day Light States
			when S0 =>
				-- State S0 Case Green N/S, Red E/W
				if Counter > Yellow_Switch_NS then
					State <= S0;
				else
					State <= S1;
					Counter_Reset_I <= '1';
				end if;
			when S1 =>
				-- State S1 Case Yellow N/S, Red E/W
				if Counter > Red_Switch then
					State <= S1;
				else
					State <= S2;
					Counter_Reset_I <= '1';
				end if;
			when S2 =>
				-- State S2 Case Red N/S, Red E/W
				if Counter > Green_Switch then
					State <= S2;
				else
					if Left_Queue_EW = "01" then -- From West Left Car Queue
						State <= A1;
						Counter_Reset_I <= '1';
					elsif Left_Queue_EW = "10" then -- From East Left Car Queue
						State <= A3;
						Counter_Reset_I <= '1';
					elsif Left_Queue_EW = "11" then -- From East and West Left Car Queue
						State <= A5;
						Counter_Reset_I <= '1';
					else									-- No Left Car Queue
						State <= S3;
						Counter_Reset_I <= '1';
					end if;
				end if;
				
			-- Advanced Turn States
			-- Advance State Descriptions above in Signal Declarations
			when A1 =>
				if Counter > Advance_Switch then
					State <= A1;
				else
					State <= S3;
					Counter_Reset_I <= '1';
				end if;
			when A3 =>
				if Counter > Advance_Switch then
					State <= A3;
				else
					State <= S3;
					Counter_Reset_I <= '1';
				end if;
			when A5 =>
				if Counter > Advance_Switch then
					State <= A5;
				else
					State <= S3;
					Counter_Reset_I <= '1';
				end if;
				
			-- Day Light States
			when S3 =>
				-- State S3 Case Red N/S, Green E/W
				if Counter > Yellow_Switch_EW then
					State <= S3;
				else
					State <= S4;
					Counter_Reset_I <= '1';
				end if;
			when S4 =>
				-- State S4 Case Red N/S, Yellow E/W
				if Counter > Red_Switch then
					State <= S4;
				else
					State <= S5;
					Counter_Reset_I <= '1';
				end if;
			when S5 =>
				-- State S5 Case Red N/S, Red E/W
				if Counter > Green_Switch then
					State <= S5;
				else
					if Left_Queue_NS = "01" then -- From South Left Car Queue
						State <= A0;
						Counter_Reset_I <= '1';
					elsif Left_Queue_NS = "10" then -- From North Left Car Queue
						State <= A2;
						Counter_Reset_I <= '1';
					elsif Left_Queue_NS = "11" then -- From South and North Left Car Queue
						State <= A4;
						Counter_Reset_I <= '1';
					elsif Day_Night = '1' and Counter = "00000" then
						State <= N0;
						Counter_Reset_I <= '1';
					else									-- No Left Car Queue
						State <= S0;
						Counter_Reset_I <= '1';
					end if;
				end if;
				
			-- Advanced Turn States
			-- Advance State Descriptions above in Signal Declaration
			when A0 =>
				if Counter > Advance_Switch then
					State <= A0;
				elsif Day_Night = '1' and Counter = "00000"  then
					State <= N0;
					Counter_Reset_I <= '1';
				else
					State <= S0;
					Counter_Reset_I <= '1';
				end if;
			when A2 =>
				if Counter > Advance_Switch then
					State <= A2;
				elsif Day_Night = '1' and Counter = "00000"  then
					State <= N0;
					Counter_Reset_I <= '1';
				else
					State <= S0;
					Counter_Reset_I <= '1';
				end if;
			when A4 =>
				if Counter > Advance_Switch then
					State <= A4;
				elsif Day_Night = '1' and Counter = "00000"  then
					State <= N0;
					Counter_Reset_I <= '1';
				else
					State <= S0;
					Counter_Reset_I <= '1';
				end if;
			
			-- Night States States
			when N0 =>
				-- State N0 Case Green N/S, Red E/W
				if Counter > Yellow_Switch_NS_Night then
					State <= N0;
				else
					State <= N1;
					Counter_Reset_I <= '1';
				end if;
			when N1 =>
				-- State N1 Case Yellow N/S, Red E/W
				if Counter > Red_Switch then
					State <= N1;
				else
					State <= N2;
					Counter_Reset_I <= '1';
				end if;
			when N2 =>
				-- State N2 Case Red N/S, Red E/W
				if Counter > Green_Switch then
					State <= N2;
				else
					State <= N3;
					Counter_Reset_I <= '1';
				end if;
			when N3 =>
				-- State N3 Case Red N/S, Green E/W
				if Counter > Yellow_Switch_EW_Night then
					State <= N3;
				else
					State <= N4;
					Counter_Reset_I <= '1';
				end if;
			when N4 =>
				-- State N4 Case Red N/S, Yellow E/W
				if Counter > Red_Switch then
					State <= N4;
				else
					State <= N5;
					Counter_Reset_I <= '1';
				end if;
			when N5 =>
				-- State N5 Case Red N/S, Red E/W
				if Counter > Green_Switch then
					State <= N5;
				elsif (Day_Night = '1' and Counter = "00000" and Night_Flash = '1') then
					State <= N6;
					Counter_Reset_I <= '1';
				elsif (Day_Night = '1' and Counter = "00000" and Night_Flash = '0') then
					State <= N0;
					Counter_Reset_I <= '1';
				else
					State <= S0;
					Counter_Reset_I <= '1';
				end if;
			when N6 =>
				-- State N6 for Flashing Red and Yellow States
				if Counter > Red_Switch then
					State <= N6;
				elsif (Day_Night = '1' and Counter = "00000" and Night_Flash = '0') then
					State <= N0;
					Counter_Reset_I <= '1';	
				elsif (Day_Night = '1' and Counter = "00000" and Night_Flash = '1') then
					State <= N6;
					Counter_Reset_I <= '1';
				else
					State <= S0;
					Counter_Reset_I <= '1';
				end if;
			when others =>
				null;
		end case;
	end if;
end process;
Counter_Reset <= Counter_Reset_I;
Current_State_Test <= Current_State;

State_Send : process(State, Current_State)
-- Process used to send Current_State across chips for CrossWalk and Light Declarations
begin
case State is
	 when S0 => Current_State <= "00000";
	 when S1 => Current_State <= "00001";
	 when S2 => Current_State <= "00010";
	 when S3 => Current_State <= "00011";
	 when S4 => Current_State <= "00100";
	 when S5 => Current_State <= "00101";
	 when A0 => Current_State <= "00110";
	 when A1 => Current_State <= "00111";
	 when A2 => Current_State <= "01000";
	 when A3 => Current_State <= "01001";
	 when A4 => Current_State <= "01010";
	 when A5 => Current_State <= "01011";
	 when N0 => Current_State <= "01100";
	 when N1 => Current_State <= "01101";
	 when N2 => Current_State <= "01110";
	 when N3 => Current_State <= "01111";
	 when N4 => Current_State <= "10000";
	 when N5 => Current_State <= "10001";
	 when N6 => Current_State <= "10010";
	 when others => Current_State <= "11111"; -- Null Case
end case;
end process State_Send;
end architecture arch_TrafficLights;
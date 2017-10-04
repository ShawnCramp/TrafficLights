-- **************************************************************************
-- Name: 			Shawn Cramp
-- Student ID: 	111007290
-- Name:				Edward Huang
-- Student ID:		100949380
-- Name:				Bruno Salapic
-- Student ID:		100574460
-- Version: 		2014-11-23
-- Description:	Counter for State Machine
-- **************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Counter is
	port ( 	
				Reset 			: in std_logic;
				Clock_1hz		: in std_logic;
				
				Counter_Reset	: in std_logic;
				
				Cross_Walk		: in std_logic;
				
				Current_State	: in std_logic_vector(4 downto 0);
				
				Counter			: out std_logic_vector(4 downto 0)
			);
end entity Counter;

architecture arch_Counter of Counter is
	signal Count_Temp : unsigned(4 downto 0) := "11001";
begin
Clock : process (Clock_1Hz, Reset, Current_State, Counter_Reset)
begin
	if Reset = '1' then
		Count_Temp <= "11001";
	elsif Counter_Reset = '1' then
			case Current_State is
				-- Change Count_Temp vector depending on state to shorten or lengthen states
				 when "00000" => Count_Temp <= "11001"; -- S0
				 when "00001" => Count_Temp <= "00101"; -- S1
				 when "00010" => Count_Temp <= "00010"; -- S2
				 when "00011" => Count_Temp <= "10100"; -- S3
				 when "00100" => Count_Temp <= "00101"; -- S4
				 when "00101" => Count_Temp <= "00010"; -- S5
				 
				 when "00110" => Count_Temp <= "00101"; -- A0
				 when "00111" => Count_Temp <= "00101"; -- A1
				 when "01000" => Count_Temp <= "00101"; -- A2
				 when "01001" => Count_Temp <= "00101"; -- A3
				 when "01010" => Count_Temp <= "00101"; -- A4
				 when "01011" => Count_Temp <= "00101"; -- A5
				 
				 when "01100" => Count_Temp <= "11100"; -- N0
				 when "01101" => Count_Temp <= "00101"; -- N1
				 when "01110" => Count_Temp <= "00011"; -- N2
				 when "01111" => Count_Temp <= "01111"; -- N3
				 when "10000" => Count_Temp <= "00101"; -- N4
				 when "10001" => Count_Temp <= "00011"; -- N5
				 when "10010" => Count_Temp <= "11001"; -- N6
				 
				 when others => Count_Temp <= "11111";
			end case;
	elsif Cross_Walk = '1' and Count_Temp > "01100" then
		Count_Temp <= "01100";
	elsif (rising_edge(Clock_1hz)) then
		Count_Temp <= Count_Temp - 1;
	end if;
end process Clock;
Counter <= std_logic_vector(Count_Temp);
end architecture arch_Counter;
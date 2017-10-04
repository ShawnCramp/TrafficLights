-- **************************************************************************
-- Name: 			Shawn Cramp
-- Student ID: 	111007290
-- Name:				Edward Huang
-- Student ID:		100949380
-- Name:				Bruno Salapic
-- Student ID:		100574460
-- Version: 		2014-11-23
-- Description:	Main VHD File for CP319 Traffic Lights Project
-- **************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Counter_Inverter is
	port ( 		
				Counter			: in std_logic_vector(4 downto 0);
				
				Counter_Invert : out std_logic_vector(4 downto 0)
			);
end entity Counter_Inverter;

architecture arch_Inverter of Counter_Inverter is
	signal Count_Temp : std_logic_vector(4 downto 0);
begin
Invert : process(Counter)
begin
	if Counter = "00001" then
		Count_Temp <= "10111";
		
	elsif Counter = "00010" then
		Count_Temp <= "10110";
		
	elsif Counter = "00011" then
		Count_Temp <= "10101";
		
	elsif Counter = "00100" then
		Count_Temp <= "10100";
		
	elsif Counter = "00101" then
		Count_Temp <= "10011";
		
	elsif Counter = "00111" then
		Count_Temp <= "10010";
		
	elsif Counter = "01000" then
		Count_Temp <= "10001";
		
	elsif Counter = "01001" then
		Count_Temp <= "10000";
		
	elsif Counter = "01010" then
		Count_Temp <= "01111";
		
	elsif Counter = "01011" then
		Count_Temp <= "01110";
		
	elsif Counter = "01100" then
		Count_Temp <= "01101";
		
	elsif Counter = "01101" then
		Count_Temp <= "01100";
		
	elsif Counter = "01110" then
		Count_Temp <= "01011";
		
	elsif Counter = "01111" then
		Count_Temp <= "01010";
		
	elsif Counter = "10000" then
		Count_Temp <= "01001";
		
	elsif Counter = "10001" then
		Count_Temp <= "01000";
		
	elsif Counter = "10010" then
		Count_Temp <= "00111";
		
	elsif Counter = "10011" then
		Count_Temp <= "00110";
		
	elsif Counter = "10100" then
		Count_Temp <= "00101";
		
	elsif Counter = "10101" then
		Count_Temp <= "00100";
		
	elsif Counter = "10110" then
		Count_Temp <= "00011";
		
	elsif Counter = "10111" then
		Count_Temp <= "00010";
		
	elsif Counter = "11000" then
		Count_Temp <= "00001";
		
	elsif Counter = "11001" then
		Count_Temp <= "00000";
		
	end if;
end process Invert;
Counter_Invert <= Count_Temp;
end architecture arch_Inverter;
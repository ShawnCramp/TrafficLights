-- **************************************************************************
-- Name: 			Shawn Cramp
-- Student ID: 	111007290
-- Name:				Edward Huang
-- Student ID:		*********
-- Version: 		2014-11-23
-- Description:	Main VHD File for CP319 Traffic Lights Project
-- **************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clock is
	port ( 	
				State 			: in std_logic;
				Clock_50Mhz		: in std_logic;
				Clock_1Hz		: out std_logic
			);
end entity Clock;

architecture arch_Clock of Clock is

begin
C2: process(State)
begin
	case State is
	 when S0 => Lights <= "11010"&"01101"&"11010"&"01101";
	 when S1 => Lights <= "10110"&"01101"&"10110"&"01101";
	 when S2 => Lights <= "01101"&"01101"&"01101"&"01101";
	 when S3 => Lights <= "01101"&"11010"&"01101"&"11010";
	 when S4 => Lights <= "01101"&"10110"&"01101"&"10110";
	 when S5 => Lights <= "01101"&"01101"&"01101"&"01101";
	 when others => Lights <= "11111"&"11111"&"11111"&"11111";
	end case;
end process C2;
Clock_1Hz <= Clock_1Hz_I;
end architecture arch_Clock;
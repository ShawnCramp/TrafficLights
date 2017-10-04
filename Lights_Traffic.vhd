-- **************************************************************************
-- Name: 			Shawn Cramp
-- Student ID: 	111007290
-- Name:				Edward Huang
-- Student ID:		100949380
-- Name:				Bruno Salapic
-- Student ID:		100574460
-- Version: 		2014-11-23
-- Description:	Sets state of traffic lights depending on position in state machine
-- **************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lights_Traffic is
	port ( 	
				-- Current State input from Entity Traffic
				Current_State : in std_logic_vector(4 downto 0);
				
				-- Counter input for flashing lights
				Counter 			: in std_logic_vector(4 downto 0);
				
				-- Lights output depending on Current State
				Lights		  : buffer std_logic_vector(15 downto 0)
			);
end entity Lights_Traffic;

architecture arch_Lights of Lights_Traffic is
begin

C2: process(Current_State, Lights, Counter)
begin
	case Current_State is
	 when "00000" => Lights <= "0010"&"1000"&"0010"&"1000";
	 when "00001" => Lights <= "0100"&"1000"&"0100"&"1000";
	 when "00010" => Lights <= "1000"&"1000"&"1000"&"1000";
	 when "00011" => Lights <= "1000"&"0010"&"1000"&"0010";
	 when "00100" => Lights <= "1000"&"0100"&"1000"&"0100";
	 when "00101" => Lights <= "1000"&"1000"&"1000"&"1000";
	 
	 when "00110" => Lights <= "1000"&"1000"&"0011"&"1000"; -- From South turning West
	 when "00111" => Lights <= "1000"&"1000"&"1000"&"0011"; -- From West turning North
	 when "01000" => Lights <= "0011"&"1000"&"1000"&"1000"; -- From North turning East
	 when "01001" => Lights <= "1000"&"0011"&"1000"&"1000"; -- From East turning South
	 when "01010" => Lights <= "1001"&"1000"&"1001"&"1000"; -- From North and South
	 when "01011" => Lights <= "1000"&"1001"&"1000"&"1001"; -- From East and West
	 
	 when "01100" => Lights <= "0010"&"1000"&"0010"&"1000"; -- Night State N/S Walk
	 when "01101" => Lights <= "0100"&"1000"&"0100"&"1000"; -- Night State N/S Dont Walk
	 when "01110" => Lights <= "1000"&"1000"&"1000"&"1000"; -- Night State E/W Walk
	 when "01111" => Lights <= "1000"&"0010"&"1000"&"0010"; -- Night State E/W Dont Walk
	 when "10000" => Lights <= "1000"&"0100"&"1000"&"0100";
	 when "10001" => Lights <= "1000"&"1000"&"1000"&"1000";
	 when "10010" => -- Flashing Yellow and Red Lights
		if ((to_integer(unsigned(Counter))) mod 2 = 0) then
			Lights <= "0100"&"0000"&"0100"&"0000";
		else
			Lights <= "0000"&"1000"&"0000"&"1000";
		end if;
	 when others => Lights <= "1111"&"1111"&"1111"&"1111";
	end case;
end process C2;
end architecture arch_Lights;
-- **************************************************************************
-- Name: 			Shawn Cramp
-- Student ID: 	111007290
-- Name:				Edward Huang
-- Student ID:		100949380
-- Name:				Bruno Salapic
-- Student ID:		100574460
-- Version: 		2014-11-23
-- Description:	Cross Walk trigger holder (Currently unused)
-- **************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CrossWalk_Trigger is
	port ( 	
				CW_Button 			: in std_logic;
				
				Current_State		: in std_logic_vector(4 downto 0);
				Counter_Reset		: in std_logic;
				
				CrossWalk_Trigger	: buffer std_logic
			);
end entity CrossWalk_Trigger;

architecture arch_Trigger of CrossWalk_Trigger is
begin
process
begin
	if (Current_State = "00000" and Counter_Reset = '1') then
		CrossWalk_Trigger <= '0';
	end if;
	if CW_Button = '1' then
		CrossWalk_Trigger <= '1';
	end if;
end process;
end architecture arch_Trigger;
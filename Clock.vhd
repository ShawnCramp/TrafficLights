-- **************************************************************************
-- Name: 			Shawn Cramp
-- Student ID: 	111007290
-- Name:				Edward Huang
-- Student ID:		100949380
-- Name:				Bruno Salapic
-- Student ID:		100574460
-- Version: 		2014-11-23
-- Description:	Clock Divider
-- **************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clock is
	port ( 	
				Reset 			: in std_logic;
				Clock_50Mhz		: in std_logic;
				
				Clock_Speed		: in std_logic;
				
				Clock_1Hz		: out std_logic
			);
end entity Clock;

architecture arch_Clock of Clock is
	signal Clock_1Hz_I	: std_logic;
	signal Prescaler	 	: unsigned(24 downto 0);
	--signal Prescaler 		: unsigned(23 downto 0);
begin

process (Clock_50Mhz, Reset)
begin
	if Reset = '1' then
		Clock_1Hz_I <= '0';
		Prescaler <= (others => '0');
	elsif (rising_edge(Clock_50Mhz)) then
		if Clock_Speed = '0' then
			if Prescaler = X"1851960" then
				Prescaler <= (others => '0');
				Clock_1Hz_I <= not Clock_1Hz_I;
			else
				Prescaler <= Prescaler + "1";
			end if;
		elsif Clock_Speed = '1' then
			if Prescaler = X"4C4B40" then
				Prescaler <= (others => '0');
				Clock_1Hz_I <= not Clock_1Hz_I;
			else
				Prescaler <= Prescaler + "1";
			end if;
		end if;	
	end if;
end process;
Clock_1Hz <= Clock_1Hz_I;
end architecture arch_Clock;
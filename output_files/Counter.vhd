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

entity Counter is
	port ( 	Reset 			: in std_logic;
				Clock_1Mhz		: in std_logic;
				Counter			: out std_logic_vector(5 downto 0));
end entity Counter;

architecture arch_Counter of Counter is
begin
process (Clock_1Mhz, Counter)
begin
	if Reset = '1' then
		Counter <= "000000";
	elsif Clock_1MHz = '1' then
		Counter <= Counter + 1;
	end if;
end process;
end architecture arch_Counter;
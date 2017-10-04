-- **************************************************************************
-- Name: 			Shawn Cramp
-- Student ID: 	111007290
-- Name:				Edward Huang
-- Student ID:		100949380
-- Name:				Bruno Salapic
-- Student ID:		100574460
-- Version: 		2014-11-23
-- Description:	Sets state of cross walk lights depending on position in crosswalk entity
-- **************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lights_CrossWalk is
	port ( 	
				B0, B1, B2, B3 : in std_logic_vector(1 downto 0);
				B4, B5, B6, B7 : in std_logic_vector(1 downto 0);
				
				Cross_Lights	: buffer std_logic_vector(15 downto 0)
			);
end entity Lights_CrossWalk;

architecture arch_Lights of Lights_CrossWalk is
	signal L0 : std_logic_vector(1 downto 0) := B0;
	signal L1 : std_logic_vector(1 downto 0) := B1;
	signal L2 : std_logic_vector(1 downto 0) := B2;
	signal L3 : std_logic_vector(1 downto 0) := B3;
	signal L4 : std_logic_vector(1 downto 0) := B4;
	signal L5 : std_logic_vector(1 downto 0) := B5;
	signal L6 : std_logic_vector(1 downto 0) := B6;
	signal L7 : std_logic_vector(1 downto 0) := B7;
begin
Cross_Lights <= L0 & L1 & L2 & L3 & L4 & L5 & L6 & L7;
end architecture arch_Lights;
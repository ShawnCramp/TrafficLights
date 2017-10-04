-- **************************************************************************
-- Name: 			Shawn Cramp
-- Student ID: 	111007290
-- Name:				Edward Huang
-- Student ID:		100949380
-- Name:				Bruno Salapic
-- Student ID:		100574460
-- Version: 		2014-11-23
-- Description:	Calculated double digit counter from logic vector for monitor display
-- **************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Counter_Splitter is
	port ( 	
				Counter 					: in std_logic_vector(4 downto 0);
				
				char_num					: out std_logic_vector(4 downto 0);
				char_num2				: out std_logic_vector(4 downto 0);
				
				char_num3				: out std_logic_vector(4 downto 0);
				char_num4				: out std_logic_vector(4 downto 0);
				
				char_num5				: out std_logic_vector(4 downto 0);
				char_num6				: out std_logic_vector(4 downto 0);
				
				char_num7				: out std_logic_vector(4 downto 0);
				char_num8				: out std_logic_vector(4 downto 0)
			);
end entity Counter_Splitter;

architecture arch_Splitter of Counter_Splitter is
	Signal countdown10   : unsigned(4 downto 0);
	Signal countdown1 	: unsigned(4 downto 0);
	Signal varC			: unsigned(4 downto 0);
begin
Convert : process (varC, Counter)
begin
	if unsigned(Counter) >= 0 and unsigned(Counter) <= 9 then
		countdown10 <= "00000";
		countdown1 <= unsigned(Counter)(4 downto 0);
	elsif unsigned(Counter) >= 10 and unsigned(Counter) <= 19 then 
		countdown10 <= "00001";
		varC <= unsigned(Counter) - "01010";
		countdown1 <= varC(4 downto 0);
	elsif unsigned(Counter) >= 20 and unsigned(Counter) <= 29 then 
		countdown10 <= "00010";
		varC <= unsigned(Counter) - "10100";
		countdown1 <= varC(4 downto 0);
	end if;	
end process Convert;
char_num <= std_logic_vector(countdown10);
char_num2 <= std_logic_vector(countdown1);

char_num3 <= std_logic_vector(countdown10);
char_num4 <= std_logic_vector(countdown1);

char_num5 <= std_logic_vector(countdown10);
char_num6 <= std_logic_vector(countdown1);

char_num7 <= std_logic_vector(countdown10);
char_num8 <= std_logic_vector(countdown1);
end architecture arch_Splitter;
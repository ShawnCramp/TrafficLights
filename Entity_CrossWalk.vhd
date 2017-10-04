-- **************************************************************************
-- Name: 			Shawn Cramp
-- Student ID: 	111007290
-- Name:				Edward Huang
-- Student ID:		100949380
-- Name:				Bruno Salapic
-- Student ID:		100574460
-- Version: 		2014-11-23
-- Description:	Cross Walk Entity for setting cross walk lights
-- **************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;

entity Entity_CrossWalk is
	port ( 	
				Reset				: in std_logic;
				Clock_1Hz		: in std_logic;
				
				B0, B1, B2, B3 : buffer std_logic_vector(1 downto 0);
				B4, B5, B6, B7 : buffer std_logic_vector(1 downto 0);
				
				Counter			: in std_logic_vector(4 downto 0);
				
				CrossWalk_Press: in std_logic;
				
				CrossWalk_Test	: out std_logic;
				
				Current_State	: in std_logic_vector(4 downto 0)
			);
end entity Entity_CrossWalk;

architecture arch_CrossWalk of Entity_CrossWalk is
-- **************************************************************************
-- 
-- **************************************************************************

	type State_Type is (W0, W1, W2, W3, W4, W5, W6, W7, W8, W9, W10);
	signal Walk_State 		: State_Type;
	signal Final_State		: State_Type;
	
	signal CrossWalk_I		: std_logic;
	
	
begin
State : process(Current_State)
-- Process used to send Current_State across chips for CrossWalk and Light Declarations
begin
case Current_State is
	 when "00000" => Walk_State <= W0;
	 when "00001" => Walk_State <= W2;
	 when "00010" => Walk_State <= W2;
	 when "00011" => Walk_State <= W3;
	 when "00100" => Walk_State <= W2;
	 when "00101" => Walk_State <= W2;
	 
	 when "00110" => Walk_State <= W5;
	 when "00111" => Walk_State <= W6;
	 when "01000" => Walk_State <= W7;
	 when "01001" => Walk_State <= W8;
	 when "01010" => Walk_State <= W2;
	 when "01011" => Walk_State <= W2;
	 
	 when "01100" => Walk_State <= W2;
	 when "01101" => Walk_State <= W2;
	 when "01110" => Walk_State <= W2;
	 when "01111" => Walk_State <= W2;
	 when "10000" => Walk_State <= W2;
	 when "10001" => Walk_State <= W2;
	 
	 when others =>  Walk_State <= W2; -- Null Case
	end case;
end process State;

CrossWalk : process (Counter, Reset, Walk_State)
begin
	if Reset = '1' then
		Final_State <= W0;
	elsif CrossWalk_Press = '1' then
			CrossWalk_I <= '1';
	else
		case Walk_State is
			-- Cross Walk States
			when W0 =>
				if counter > "01010" then
					Final_State <= W0;
				else
					Final_State <= W1;
				end if;
			when W1 =>
				Final_State <= Walk_State;
			when W2 =>
				if CrossWalk_I = '1' then
					Final_State <= W0;
					CrossWalk_I <= '0';
				else
					Final_State <= Walk_State;
				end if;
			when W3 =>
				if counter > "01010" then
					Final_State <= W3;
				else
					Final_State <= W4;
				end if;
			when W4 =>
				Final_State <= Walk_State;
			when W5 =>
				Final_State <= Walk_State;
			when W6 =>
				Final_State <= Walk_State;
			when W7 =>
				Final_State <= Walk_State;
			when W8 =>
				Final_State <= Walk_State;
			when W9 =>
				if counter > "01010" then
					Final_State <= W9;
				else
					Final_State <= W10;
				end if;
			when W10 =>
				Final_State <= Walk_State;
			when others =>
				null;
		end case;
	end if;
end process CrossWalk;
CrossWalk_Test <= CrossWalk_I;


C2: process(Final_State, B0, B1, B2, B3, B4, B5, B6, B7)
begin
case Final_State is
	 when W0  => 
		B0 <= "01";
		B1 <= "01";
		B4 <= "01";
		B5 <= "01";
		
		B2 <= "10";
		B3 <= "10";
		B6 <= "10";
		B7 <= "10";
	 when W1  => -- Flashing Don't Walk Hand
		if ((to_integer(unsigned(Counter))) mod 2 = 0) then
			B0 <= "10";
			B1 <= "10";
			B4 <= "10";
			B5 <= "10";
			
			B2 <= "10";
			B3 <= "10";
			B6 <= "10";
			B7 <= "10";
		else
			B0 <= "00";
			B1 <= "00";
			B4 <= "00";
			B5 <= "00";
			
			B2 <= "10";
			B3 <= "10";
			B6 <= "10";
			B7 <= "10";
		end if;
		
	 when W2  =>  -- Don't Walk All Directions State
		B0 <= "10";
		B1 <= "10";
		B4 <= "10";
		B5 <= "10";
		
		B2 <= "10";
		B3 <= "10";
		B6 <= "10";
		B7 <= "10";
	 when W3  => 
		B0 <= "10";
		B1 <= "10";
		B4 <= "10";
		B5 <= "10";
		
		B2 <= "01";
		B3 <= "01";
		B6 <= "01";
		B7 <= "01";
	 when W4  => -- Flashing Don't Walk Hand
		if ((to_integer(unsigned(Counter))) mod 2 = 0) then
			B0 <= "10";
			B1 <= "10";
			B4 <= "10";
			B5 <= "10";
			
			B2 <= "10";
			B3 <= "10";
			B6 <= "10";
			B7 <= "10";
		else
			B0 <= "10";
			B1 <= "10";
			B4 <= "10";
			B5 <= "10";
			
			B2 <= "00";
			B3 <= "00";
			B6 <= "00";
			B7 <= "00";
		end if;
	 when W5  => -- Advance Green South Turning West
		B0 <= "01";
		B1 <= "01";
		
		B2 <= "10";
		B3 <= "10";
		B4 <= "10";
		B5 <= "10";
		B6 <= "10";
		B7 <= "10";
	 when W6  => -- Advance Green West Turning North
		B2 <= "01";
		B3 <= "01";
		
		B0 <= "10";
		B1 <= "10";
		B4 <= "10";
		B5 <= "10";
		B6 <= "10";
		B7 <= "10";
	 when W7  => -- Advance Green North Turning East
		B4 <= "01";
		B5 <= "01";
		
		B0 <= "10";
		B1 <= "10";
		B2 <= "10";
		B3 <= "10";
		B6 <= "10";
		B7 <= "10";
	 when W8  => -- Advance Green East Turning South
		B6 <= "01";
		B7 <= "01";
		
		B0 <= "10";
		B1 <= "10";
		B2 <= "10";
		B3 <= "10";
		B4 <= "10";
		B5 <= "10";
	 when W9  => -- Walk All Directions State
		B0 <= "01";
		B1 <= "01";
		B2 <= "01";
		B3 <= "01";
		
		B4 <= "01";
		B5 <= "01";
		B6 <= "01";
		B7 <= "01";
	 when W10 => -- Flashing Don't Walk All Directions State
		B0 <= "10";
		B1 <= "10";
		B2 <= "10";
		B3 <= "10";
		
		B4 <= "10";
		B5 <= "10";
		B6 <= "10";
		B7 <= "10";
	 when others => -- Error State, All Lights on to Indicate Error
		B0 <= "11";
		B1 <= "11";
		B2 <= "11";
		B3 <= "11";
		
		B4 <= "11";
		B5 <= "11";
		B6 <= "11";
		B7 <= "11";
	end case;
end process C2;
end architecture arch_CrossWalk;
-- **************************************************************************
-- Name: 			Shawn Cramp
-- Student ID: 	111007290
-- Name:				Edward Huang
-- Student ID:		100949380
-- Name:				Bruno Salapic
-- Student ID:		100574460
-- Version: 		2014-11-23
-- Description:	Main VHD File for outputing display to the monitor
-- **************************************************************************

-- This program uses the vga_sync package to output a 640x480 image of 8 striped colors. 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
--USE IEEE.STD_LOGIC_ARITH.all;
--USE IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;
use work.vga_sync_p.all;

entity Memory is
	port(	clock_27Mhz 							: in std_logic;
			chr_num 									: in std_logic_vector(4 downto 0);--the 8 digit slots from here to chr_num8
			chr_num2 								: in std_logic_vector(4 downto 0);
			chr_num3									: in std_logic_vector(4 downto 0);
			chr_num4 								: in std_logic_vector(4 downto 0);
			chr_num5 								: in std_logic_vector(4 downto 0);
			chr_num6 								: in std_logic_vector(4 downto 0);
			chr_num7									: in std_logic_vector(4 downto 0);
			chr_num8 								: in std_logic_vector(4 downto 0);
			
			chr_numtopleftrightman 								: in std_logic;--tfor all the hands and mans on display
			chr_numtopleftrighthand 							: in std_logic;
			chr_numtopleftbotman									: in std_logic;
			chr_numtopleftbothand 								: in std_logic;
			chr_numtoprightleftman 								: in std_logic;
			chr_numtoprightlefthand 							: in std_logic;
			chr_numtoprightbotman								: in std_logic;
			chr_numtoprightbothand 								: in std_logic;
			chr_numbotleftrightman								: in std_logic;--tfor all the hands and mans on display
			chr_numbotleftrighthand 							: in std_logic;
			chr_numbotlefttopman									: in std_logic;
			chr_numbotlefttophand 								: in std_logic;
			chr_numbotrightleftman 								: in std_logic;
			chr_numbotrightlefthand 							: in std_logic;
			chr_numbotrighttopman								: in std_logic;
			chr_numbotrighttophand 								: in std_logic;
			
			----------------------------
			chr_numtoparrow								 		: in std_logic;--arrows
			chr_numleftarrow 										: in std_logic;
			chr_numrightarrow										: in std_logic;
			chr_numbotarrow 										: in std_logic;
			
			-------------------------
			chr_numtopred											: in std_logic;
			chr_numtopyellow 										: in std_logic;--- top lights
			chr_numtopgreen										: in std_logic;
			-------------------------
			chr_numleftred 										: in std_logic;
			chr_numleftyellow 									: in std_logic;--- left lights
			chr_numleftgreen										: in std_logic;
			-------------------------
			chr_numrightred 										: in std_logic;
			chr_numrightyellow 									: in std_logic;--- right lights
			chr_numrightgreen										: in std_logic;
			-------------------------
			chr_numbotred 											: in std_logic;
			chr_numbotyellow 										: in std_logic;--- bot lights
			chr_numbotgreen										: in std_logic;
			
			
			clock_27Mhz_out 										: out std_logic;
			--ImageLocationRow					: in std_logic_vector(9 downto 0);
			--ImageLocationColumn				: in std_logic_vector(9 downto 0);
			R, G, B 													: out std_logic_vector(9 downto 0);
			h_sync_out, v_sync_out 								: out std_logic;
			vga_blank_out, vga_sync_out 						: out std_logic);
end entity Memory;

architecture arch_Memory of Memory is
	-- Used for VGA monitor display
	signal video_on 					: std_logic;
	signal pixel_row, pixel_col 	: std_logic_vector(15 downto 0);
	
	--type State_Type is (S0, S1, S2, S3, S4, S5, A0, A1, A2, A3, A4, A5, N0, N1, N2, N3);
	--signal State 			: State_Type;
	
	-- Used with mif file to determine row vector for number being displayed
	signal chr_addresstopleftleftnum 				: std_logic_vector(11 downto 0);
	signal chr_addresstoplight 				: std_logic_vector(11 downto 0);
	signal chr_addressbotlight 				: std_logic_vector(11 downto 0);
	signal chr_addressleftlight 				: std_logic_vector(11 downto 0);
	signal chr_addressrightlight 				: std_logic_vector(11 downto 0);
	signal chr_addressbotrighttopman 				: std_logic_vector(11 downto 0);
	signal chr_addressbotlefttophand 				: std_logic_vector(11 downto 0);
	signal chr_addressbotrighttophand 				: std_logic_vector(11 downto 0);
	signal chr_addressbotlefttopman 				: std_logic_vector(11 downto 0);
	signal chr_addresstopleftbotman			: std_logic_vector(11 downto 0);
	signal chr_addresstopleftbothand 				: std_logic_vector(11 downto 0);
	signal chr_addresstoprightbotman 				: std_logic_vector(11 downto 0);
	signal chr_addresstoprightbothand 				: std_logic_vector(11 downto 0);
	signal chr_addresstopleftlefthand				: std_logic_vector(11 downto 0);
	signal chr_addresstopleftleftman				: std_logic_vector(11 downto 0);
	signal chr_addresstoprightleftman				: std_logic_vector(11 downto 0);
	signal chr_addresstoprightlefthand 				: std_logic_vector(11 downto 0);
	signal chr_addressbotleftrightman 				: std_logic_vector(11 downto 0);
	signal chr_addressbotleftrighthand 				: std_logic_vector(11 downto 0);
	signal chr_addressbotrightleftman 				: std_logic_vector(11 downto 0);
	signal chr_addressbotrightlefthand			: std_logic_vector(11 downto 0);
	signal chr_addresstopleftrightnum 				: std_logic_vector(11 downto 0);
	signal chr_addresstoprightleftnum				: std_logic_vector(11 downto 0);
	signal chr_addresstoprightrightnum 				: std_logic_vector(11 downto 0);
	signal chr_addressbotleftleftnum				: std_logic_vector(11 downto 0);
	signal chr_addressbotleftrightnum 				: std_logic_vector(11 downto 0);
	signal chr_addressbotrightleftnum 				: std_logic_vector(11 downto 0);
	signal chr_addressbotrightrightnum 			: std_logic_vector(11 downto 0);
	signal chr_addresstoparrow			: std_logic_vector(11 downto 0);
	signal chr_addressbotarrow				: std_logic_vector(11 downto 0);
	signal chr_addressleftarrow				: std_logic_vector(11 downto 0);
	signal chr_addressrightarrow 			: std_logic_vector(11 downto 0);
	
	
	signal chr_rowtopleftleftnum 					: std_logic_vector(15 downto 0);
	signal chr_rowtoplight 					: std_logic_vector(15 downto 0);
	signal chr_rowbotlight 					: std_logic_vector(15 downto 0);
	signal chr_rowleftlight 					: std_logic_vector(15 downto 0);
	signal chr_rowrightlight 					: std_logic_vector(15 downto 0);
	signal chr_rowbotrighttopman 					: std_logic_vector(15 downto 0);
	signal chr_rowbotlefttophand 					: std_logic_vector(15 downto 0);
	signal chr_rowbotrighttophand 					: std_logic_vector(15 downto 0);
	signal chr_rowbotlefttopman 					: std_logic_vector(15 downto 0);
	signal chr_rowtopleftbotman 					: std_logic_vector(15 downto 0);
	signal chr_rowtopleftbothand 					: std_logic_vector(15 downto 0);
	signal chr_rowtoprightbotman 					: std_logic_vector(15 downto 0);
	signal chr_rowtoprightbothand 					: std_logic_vector(15 downto 0);
	signal chr_rowtopleftlefthand 					: std_logic_vector(15 downto 0);
	signal chr_rowtopleftleftman 					: std_logic_vector(15 downto 0);
	signal chr_rowtoprightleftman					: std_logic_vector(15 downto 0);
	signal chr_rowtoprightlefthand 					: std_logic_vector(15 downto 0);
	signal chr_rowbotleftrightman 					: std_logic_vector(15 downto 0);
	signal chr_rowbotleftrighthand 					: std_logic_vector(15 downto 0);
	signal chr_rowbotrightleftman 					: std_logic_vector(15 downto 0);
	signal chr_rowbotrightlefthand					: std_logic_vector(15 downto 0);
	signal chr_rowtopleftrightnum 					: std_logic_vector(15 downto 0);
	signal chr_rowtoprightleftnum					: std_logic_vector(15 downto 0);
	signal chr_rowtoprightrightnum 					: std_logic_vector(15 downto 0);
	signal chr_rowbotleftleftnum 					: std_logic_vector(15 downto 0);
	signal chr_rowbotleftrightnum					: std_logic_vector(15 downto 0);
	signal chr_rowbotrightleftnum 					: std_logic_vector(15 downto 0);
	signal chr_rowbotrightrightnum 					: std_logic_vector(15 downto 0);
	signal chr_rowtoparrow 					: std_logic_vector(15 downto 0);
	signal chr_rowbotarrow				: std_logic_vector(15 downto 0);
	signal chr_rowleftarrow					: std_logic_vector(15 downto 0);
	signal chr_rowrightarrow 					: std_logic_vector(15 downto 0);
	
	
	-- Used to store row and number data for memory use
	signal data							: std_logic_vector(15 downto 0);
	signal wren							: std_logic;
	
	
	-- Component used with Character_Memory.vhd to generate values on monitor
	component character_memory IS
		PORT
		(
			address		: IN std_logic_vector(11 DOWNTO 0);
			clock			: IN STD_LOGIC  := '1';
			data			: IN STD_LOGIC_VECTOR(15 downto 0);
			wren			: IN STD_LOGIC;
			q				: OUT std_logic_vector (15 DOWNTO 0)
		);
	end component character_memory;
begin
	-- Calls vga_sync for displaying on monitor
	vga		: vga_sync port map(clock_27Mhz, h_sync_out, v_sync_out, video_on, pixel_row, pixel_col);
	
	-- Calls character_memory for storing vectors in memory to display them on the monitor
	char 		: character_memory port map(chr_addresstopleftleftnum, clock_27Mhz, data, wren, chr_rowtopleftleftnum);
	char2 	: character_memory port map(chr_addresstoplight, clock_27Mhz, data, wren, chr_rowtoplight);
	char3 	: character_memory port map(chr_addressbotlight, clock_27Mhz, data, wren, chr_rowbotlight);
	char4 	: character_memory port map(chr_addressleftlight, clock_27Mhz, data, wren, chr_rowleftlight);
	char5 	: character_memory port map(chr_addressrightlight, clock_27Mhz, data, wren, chr_rowrightlight);
	char6 	: character_memory port map(chr_addressbotrighttopman, clock_27Mhz, data, wren, chr_rowbotrighttopman);
	char7 	: character_memory port map(chr_addressbotlefttophand, clock_27Mhz, data, wren, chr_rowbotlefttophand);
	char8 	: character_memory port map(chr_addressbotrighttophand, clock_27Mhz, data, wren, chr_rowbotrighttophand);
	char9 	: character_memory port map(chr_addressbotlefttopman, clock_27Mhz, data, wren, chr_rowbotlefttopman);
	char10 	: character_memory port map(chr_addresstopleftbotman, clock_27Mhz, data, wren, chr_rowtopleftbotman);
	char11 	: character_memory port map(chr_addresstopleftbothand, clock_27Mhz, data, wren, chr_rowtopleftbothand);
	char12 	: character_memory port map(chr_addresstoprightbotman, clock_27Mhz, data, wren, chr_rowtoprightbotman);
	char13 	: character_memory port map(chr_addresstoprightbothand, clock_27Mhz, data, wren, chr_rowtoprightbothand);
	char14 	: character_memory port map(chr_addresstopleftlefthand, clock_27Mhz, data, wren, chr_rowtopleftlefthand);
	char15 	: character_memory port map(chr_addresstopleftleftman, clock_27Mhz, data, wren, chr_rowtopleftleftman);
	char16 	: character_memory port map(chr_addresstoprightleftman, clock_27Mhz, data, wren, chr_rowtoprightleftman);
	char17 	: character_memory port map(chr_addresstoprightlefthand, clock_27Mhz, data, wren, chr_rowtoprightlefthand);
	char18 	: character_memory port map(chr_addressbotleftrightman, clock_27Mhz, data, wren, chr_rowbotleftrightman);
	char19 	: character_memory port map(chr_addressbotleftrighthand, clock_27Mhz, data, wren, chr_rowbotleftrighthand);
	char20 	: character_memory port map(chr_addressbotrightleftman, clock_27Mhz, data, wren, chr_rowbotrightleftman);
	char21 	: character_memory port map(chr_addressbotrightlefthand, clock_27Mhz, data, wren, chr_rowbotrightlefthand);
	char22 	: character_memory port map(chr_addresstopleftrightnum, clock_27Mhz, data, wren, chr_rowtopleftrightnum);
	char23 	: character_memory port map(chr_addresstoprightleftnum, clock_27Mhz, data, wren, chr_rowtoprightleftnum);
	char24 	: character_memory port map(chr_addresstoprightrightnum, clock_27Mhz, data, wren, chr_rowtoprightrightnum);
	char25 	: character_memory port map(chr_addressbotleftleftnum, clock_27Mhz, data, wren, chr_rowbotleftleftnum);
	char26 	: character_memory port map(chr_addressbotleftrightnum, clock_27Mhz, data, wren, chr_rowbotleftrightnum);
	char27 	: character_memory port map(chr_addressbotrightleftnum, clock_27Mhz, data, wren, chr_rowbotrightleftnum);
	char28 	: character_memory port map(chr_addressbotrightrightnum, clock_27Mhz, data, wren, chr_rowbotrightrightnum);
	char29 	: character_memory port map(chr_addresstoparrow, clock_27Mhz, data, wren, chr_rowtoparrow);
	char30 	: character_memory port map(chr_addressbotarrow, clock_27Mhz, data, wren, chr_rowbotarrow);
	char31 	: character_memory port map(chr_addressleftarrow, clock_27Mhz, data, wren, chr_rowleftarrow);
	char32 	: character_memory port map(chr_addressrightarrow, clock_27Mhz, data, wren, chr_rowrightarrow);
	
	rgb_generate: process(video_on, pixel_row, pixel_col, chr_addresstopleftleftnum, chr_rowtopleftleftnum, chr_addresstoplight, chr_rowtoplight
	, chr_addressbotlight, chr_rowbotlight
	, chr_addressleftlight, chr_rowleftlight
	, chr_addressrightlight, chr_rowrightlight
	, chr_addressbotrighttopman, chr_rowbotrighttopman
	, chr_addressbotlefttophand, chr_rowbotlefttophand
	, chr_addressbotrighttophand, chr_rowbotrighttophand
	, chr_addressbotlefttopman, chr_rowbotlefttopman
	, chr_addresstopleftbotman, chr_rowtopleftbotman
	, chr_addresstopleftbothand, chr_rowtopleftbothand
	, chr_addresstoprightbotman, chr_rowtoprightbotman
	, chr_addresstoprightbothand, chr_rowtoprightbothand
	, chr_addresstopleftlefthand, chr_rowtopleftlefthand
	, chr_addresstopleftleftman, chr_rowtopleftleftman
	, chr_addresstoprightleftman, chr_rowtopleftrightnum
	, chr_addresstoprightlefthand, chr_rowtoprightlefthand
	, chr_addressbotleftrightman, chr_rowbotleftrightman
	, chr_addressbotleftrighthand, chr_rowbotleftrighthand
	, chr_addressbotrightleftman, chr_rowbotrightleftman
	, chr_addressbotrightlefthand, chr_rowbotrightlefthand
	, chr_addresstopleftrightnum, chr_rowtopleftrightnum
	, chr_addresstoprightleftnum, chr_rowtoprightleftnum
	, chr_addresstoprightrightnum, chr_rowtoprightrightnum
	, chr_addressbotleftleftnum, chr_rowbotleftleftnum
	, chr_addressbotleftrightnum, chr_rowbotleftrightnum
	, chr_addressbotrightleftnum, chr_rowbotrightleftnum
	, chr_addressbotrightrightnum, chr_rowbotrightrightnum
	, chr_addresstoparrow, chr_rowtoparrow
	, chr_addressbotarrow, chr_rowbotarrow
	, chr_addressleftarrow, chr_rowleftarrow
	, chr_addressrightarrow, chr_rowrightarrow)
	begin	
	
		if video_on = '1' then -- if the vga package indicates that it is currently drawing to the screen.
		
		R <= "0000000000";
		G <= "0000000000";
		B <= "0000000000";
---------------------------------------------------------
			if unsigned(chr_num) <= 10 then
				
				-- If pixel_row is greater then 236 and less then 243 resize vector for memory address
				-- then draw the 8 pixels white depending on values in the 8bit vector
				if unsigned(pixel_row) >= 1 and unsigned(pixel_row) <= 15  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addresstopleftleftnum <= std_logic_vector(resize("1100000" + unsigned(chr_num),8)) & std_logic_vector(resize(unsigned(pixel_row) - 1,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 1 and unsigned(pixel_col) <= 15 then
						if chr_rowtopleftleftnum(to_integer(15 - unsigned(pixel_col))) = '1'  then
							R <= "1111111111";
							G <= "1111111111";
							B <= "1111111111";
						
						end if;

					end if;
					end if;
					if unsigned(pixel_row) >= 1 and unsigned(pixel_row) <= 15  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addresstopleftleftman <= "01101011" & std_logic_vector(resize(unsigned(pixel_row) - 1,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 34 and unsigned(pixel_col) <= 49 then
						if chr_rowtopleftleftman(to_integer(49 - unsigned(pixel_col))) = '1'  then
							if chr_numtopleftrightman = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						end if;

					end if;
					end if;
					if unsigned(pixel_row) >= 1 and unsigned(pixel_row) <= 15  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addresstopleftlefthand <= "01101010" & std_logic_vector(resize(unsigned(pixel_row) - 1,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 51 and unsigned(pixel_col) <= 66 then
						if chr_rowtopleftlefthand(to_integer(66 - unsigned(pixel_col))) = '1'  then
							if chr_numtopleftrighthand = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;
					if unsigned(pixel_row) >= 1 and unsigned(pixel_row) <= 15  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addresstopleftrightnum <= std_logic_vector(resize("1100000" + unsigned(chr_num2),8)) & std_logic_vector(resize(unsigned(pixel_row) - 1,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 17 and unsigned(pixel_col) <= 32 then
						if chr_rowtopleftrightnum(to_integer(32 - unsigned(pixel_col))) = '1' then                                                                                                
							R <= "1111111111";
							G <= "1111111111";
							B <= "1111111111";
						
						end if;

					end if;
					
					end if;
					if unsigned(pixel_row) >= 1 and unsigned(pixel_row) <= 15  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addresstoprightleftman <="01101011" & std_logic_vector(resize(unsigned(pixel_row) - 1,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 590 and unsigned(pixel_col) <= 605 then
						if chr_rowtoprightleftman(to_integer(590 - unsigned(pixel_col))) = '1' then
							if chr_numtoprightleftman = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;
					if unsigned(pixel_row) >= 1 and unsigned(pixel_row) <= 15  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addresstoprightlefthand <="01101010" & std_logic_vector(resize(unsigned(pixel_row) - 1,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 573 and unsigned(pixel_col) <= 588 then
						if chr_rowtoprightlefthand(to_integer(588 - unsigned(pixel_col))) = '1' then
							if chr_numtoprightlefthand = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;
					if unsigned(pixel_row) >= 1 and unsigned(pixel_row) <= 16  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addresstoprightleftnum <= std_logic_vector(resize("1100000" + unsigned(chr_num3),8)) & std_logic_vector(resize(unsigned(pixel_row) - 1,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 607 and unsigned(pixel_col) <= 622 then
						if chr_rowtoprightleftnum(to_integer(622 - unsigned(pixel_col))) = '1' then
							R <= "1111111111";
							G <= "1111111111";
							B <= "1111111111";
						
						end if;

					end if;
					end if;
					if unsigned(pixel_row) >= 1 and unsigned(pixel_row) <= 16  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addresstoprightrightnum <= std_logic_vector(resize("1100000" + unsigned(chr_num4),8)) & std_logic_vector(resize(unsigned(pixel_row) - 1,4));
					if  unsigned(pixel_col) >= 624 and unsigned(pixel_col) <= 639 then
						if  chr_rowtoprightrightnum(to_integer(639 - unsigned(pixel_col))) = '1' then
							R <= "1111111111";
							G <= "1111111111";
							B <= "1111111111";
						
						end if;

					end if;
					end if;
					
					
					
					if unsigned(pixel_row) >= 464 and unsigned(pixel_row) <= 479  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressbotleftleftnum <= std_logic_vector(resize("1100000" + unsigned(chr_num5),8)) & std_logic_vector(resize(unsigned(pixel_row) - 1,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 1 and unsigned(pixel_col) <= 15 then
						if chr_rowbotleftleftnum(to_integer(15 - unsigned(pixel_col))) = '1'  then
							R <= "1111111111";
							G <= "1111111111";
							B <= "1111111111";
						
						end if;

					end if;
					end if;
					if unsigned(pixel_row) >= 464 and unsigned(pixel_row) <= 479  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressbotleftrightnum <= std_logic_vector(resize("1100000" + unsigned(chr_num6),8)) & std_logic_vector(resize(unsigned(pixel_row) - 1,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 17 and unsigned(pixel_col) <= 32 then
						if chr_rowbotleftrightnum(to_integer(32 - unsigned(pixel_col))) = '1' then
							R <= "1111111111";
							G <= "1111111111";
							B <= "1111111111";
						
						end if;

					end if;
					end if;
					if unsigned(pixel_row) >= 464 and unsigned(pixel_row) <= 479  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressbotleftrightman <= "01101011" & std_logic_vector(resize(unsigned(pixel_row) - 464,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 34 and unsigned(pixel_col) <= 49 then
						if chr_rowbotleftrightman(to_integer(49 - unsigned(pixel_col))) = '1' then
							if chr_numbotleftrightman = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;
					if unsigned(pixel_row) >= 464 and unsigned(pixel_row) <= 479  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressbotleftrighthand <= "01101010" & std_logic_vector(resize(unsigned(pixel_row) - 479,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 51 and unsigned(pixel_col) <= 66 then
						if chr_rowbotleftrighthand(to_integer(66 - unsigned(pixel_col))) = '1' then
							if chr_numbotleftrighthand = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;
					
				
				-------------------------------------------------------------------------------------------
			
		
	
	
				if unsigned(pixel_row) >= 17 and unsigned(pixel_row) <= 32  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addresstopleftbotman <= "01101011" & std_logic_vector(resize(unsigned(pixel_row) - 17,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 1 and unsigned(pixel_col) <= 15 then
						if chr_rowtopleftbotman(to_integer(15 - unsigned(pixel_col))) = '1'   then
							if chr_numtopleftbotman = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						end if;

					end if;
					end if;	
			if unsigned(pixel_row) >= 34 and unsigned(pixel_row) <= 49  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addresstopleftbothand <= "01101010" & std_logic_vector(resize(unsigned(pixel_row) - 34,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 1 and unsigned(pixel_col) <= 15 then
						if chr_rowtopleftbothand(to_integer(15 - unsigned(pixel_col))) = '1'  then
							if chr_numtopleftbothand = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;	
				
				if unsigned(pixel_row) >= 17 and unsigned(pixel_row) <= 32  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addresstoprightbotman <= "01101011" & std_logic_vector(resize(unsigned(pixel_row) - 17,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 624 and unsigned(pixel_col) <= 639 then
						if chr_rowtoprightbotman(to_integer(639 - unsigned(pixel_col))) = '1'  then
							if chr_numtoprightbotman = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;	
			if unsigned(pixel_row) >= 34 and unsigned(pixel_row) <= 49  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addresstoprightbothand <= "01101010" & std_logic_vector(resize(unsigned(pixel_row) - 34,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 624 and unsigned(pixel_col) <= 639 then
						if chr_rowtoprightbothand(to_integer(639 - unsigned(pixel_col))) = '1'  then
							if chr_numtoprightbothand = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;
					
				if unsigned(pixel_row) >= 464 and unsigned(pixel_row) <= 479  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressbotrightleftman	 <=  "01101011" & std_logic_vector(resize(unsigned(pixel_row) - 464,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 590 and unsigned(pixel_col) <= 605 then
						if chr_rowbotrightleftman(to_integer(605 - unsigned(pixel_col))) = '1' then
							if chr_numbotrightleftman = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;	
				if unsigned(pixel_row) >= 464 and unsigned(pixel_row) <= 479  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressbotrightlefthand <=  "01101010" & std_logic_vector(resize(unsigned(pixel_row) - 464,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 573 and unsigned(pixel_col) <= 588 then
						if chr_rowbotrightlefthand(to_integer(588 - unsigned(pixel_col))) = '1' then
							if chr_numbotrightlefthand = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;
				if unsigned(pixel_row) >= 464 and unsigned(pixel_row) <= 479  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressbotrightleftnum <= std_logic_vector(resize("1100000" + unsigned(chr_num7),8)) & std_logic_vector(resize(unsigned(pixel_row) - 464,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 607 and unsigned(pixel_col) <= 622 then
						if chr_rowbotrightleftnum(to_integer(622 - unsigned(pixel_col))) = '1' then
							R <= "1111111111";
							G <= "1111111111";
							B <= "1111111111";
						
						end if;

					end if;
					end if;
					if unsigned(pixel_row) >= 464 and unsigned(pixel_row) <= 479  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressbotrightrightnum <= std_logic_vector(resize("1100000" + unsigned(chr_num8),8)) & std_logic_vector(resize(unsigned(pixel_row) - 464,4));
					if  unsigned(pixel_col) >= 624 and unsigned(pixel_col) <= 639 then
						if  chr_rowbotrightrightnum(to_integer(639 - unsigned(pixel_col))) = '1' then
							R <= "1111111111";
							G <= "1111111111";
							B <= "1111111111";
						
						end if;

					end if;
					end if;	
			------------------------------------------------------------
			
			
				if unsigned(pixel_row) >= 447 and unsigned(pixel_row) <= 462  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressbotlefttopman <= "01101011"  & std_logic_vector(resize(unsigned(pixel_row) - 447,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 1 and unsigned(pixel_col) <= 15 then
						if chr_rowbotlefttopman(to_integer(15 - unsigned(pixel_col))) = '1'  then
							if chr_numbotlefttopman = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;	
			if unsigned(pixel_row) >= 430 and unsigned(pixel_row) <= 445  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressbotlefttophand <= "01101010"  & std_logic_vector(resize(unsigned(pixel_row) - 430,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 1 and unsigned(pixel_col) <= 15 then
						if chr_rowbotlefttophand(to_integer(15 - unsigned(pixel_col))) = '1'  then
							if chr_numbotlefttophand = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;	
				
				if unsigned(pixel_row) >= 447 and unsigned(pixel_row) <= 462  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressbotrighttopman <= "01101011" & std_logic_vector(resize(unsigned(pixel_row) - 447,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 624 and unsigned(pixel_col) <= 639 then
						if chr_rowbotrighttopman(to_integer(639 - unsigned(pixel_col))) = '1'  then
							if chr_numbotrighttopman = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;	
			if unsigned(pixel_row) >= 430 and unsigned(pixel_row) <= 445  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressbotrighttophand <= "01101010"  & std_logic_vector(resize(unsigned(pixel_row) - 430,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 624 and unsigned(pixel_col) <= 639 then
						if chr_rowbotrighttophand(to_integer(639 - unsigned(pixel_col))) = '1'  then
							if chr_numbotrighttophand = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "1111111111";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;	
			
			
			
			
	
-----------------------------------------------------------------------
	
				if unsigned(pixel_row) >= 1 and unsigned(pixel_row) <= 16 then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
					chr_addresstoplight <= "01101100" & std_logic_vector(resize(unsigned(pixel_row) - 1,4));
						
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if unsigned(pixel_col) >= 315 and unsigned(pixel_col) <= 330 then
						if chr_rowtoplight(to_integer(330 - unsigned(pixel_col))) = '1'  then
							--if unsigned(chr_num) = 11 then
							if chr_numtopred = '1' then 
								R <= "1111111111";
								G <= "0000000000";
								B <= "0000000000";
							elsif chr_numtopgreen = '1' then 
								R <= "0000000000";
								G <= "1111111111";
								B <= "0000000000";
							elsif chr_numtopyellow = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "0000000000";
							end if;

						end if;
						
					end if;
				end if;
			
				
				--------
			
				
				
				if unsigned(pixel_row) >= 447 and unsigned(pixel_row) <= 462 then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressbotlight <= "01101100" & std_logic_vector(resize(unsigned(pixel_row) - 464,4));
						--std_logic_vector(resize("1101100",8))
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if unsigned(pixel_col) >= 315 and unsigned(pixel_col) <= 330 then
						if chr_rowbotlight(to_integer(330 - unsigned(pixel_col))) = '1' then
							if chr_numbotred = '1' then 
								R <= "1111111111";
								G <= "0000000000";
								B <= "0000000000";
							elsif chr_numbotgreen = '1' then 
								R <= "0000000000";
								G <= "1111111111";
								B <= "0000000000";
							elsif chr_numbotyellow = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "0000000000";
							end if;
						
						end if;							

					end if;
				end if;

				
				if unsigned(pixel_row) >= 235 and unsigned(pixel_row) <= 250 then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressleftlight <= "01101100" & std_logic_vector(resize(unsigned(pixel_row) - 235,4));
						
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if unsigned(pixel_col) >= 1 and unsigned(pixel_col) <= 15 then
						if chr_rowleftlight(to_integer(15 - unsigned(pixel_col))) = '1'  then
							--if unsigned(chr_num) = 11 then
							if chr_numleftred = '1' then 
								R <= "1111111111";
								G <= "0000000000";
								B <= "0000000000";
							elsif chr_numleftgreen = '1' then 
								R <= "0000000000";
								G <= "1111111111";
								B <= "0000000000";
							elsif chr_numleftyellow = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "0000000000";
							end if;
						
						
						end if;							
	
					end if;
					
				end if;
				if unsigned(pixel_row) >= 235 and unsigned(pixel_row) <= 250 then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressrightlight <= "01101100" & std_logic_vector(resize(unsigned(pixel_row) - 235,4));
						
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if unsigned(pixel_col) >= 624 and unsigned(pixel_col) <= 639 then
						if chr_rowrightlight(to_integer(639 - unsigned(pixel_col))) = '1'   then
							--if unsigned(chr_num) = 11 then
							if chr_numrightred = '1' then 
								R <= "1111111111";
								G <= "0000000000";
								B <= "0000000000";
							elsif chr_numrightgreen = '1' then 
								R <= "0000000000";
								G <= "1111111111";
								B <= "0000000000";
							elsif chr_numrightyellow = '1' then 
								R <= "1111111111";
								G <= "1111111111";
								B <= "0000000000";
							end if;
						
						
						end if;							
	
					end if;
					
				end if;
				if unsigned(pixel_row) >= 17 and unsigned(pixel_row) <= 32  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addresstoparrow <= "01101111" & std_logic_vector(resize(unsigned(pixel_row) - 17,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 315 and unsigned(pixel_col) <= 330 then
						if chr_rowtoparrow(to_integer(330 - unsigned(pixel_col))) = '1'   then
							if chr_numtoparrow = '1' then 
								R <= "0000000000";
								G <= "1111111111";
								B <= "0000000000";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;
				if unsigned(pixel_row) >= 252 and unsigned(pixel_row) <= 267  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressleftarrow <= "01101111" & std_logic_vector(resize(unsigned(pixel_row) - 235,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 1 and unsigned(pixel_col) <= 16 then
						if chr_rowleftarrow(to_integer(15 - unsigned(pixel_col))) = '1'   then
							if chr_numleftarrow = '1' then 
								R <= "0000000000";
								G <= "1111111111";
								B <= "0000000000";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;
			if unsigned(pixel_row) >= 252 and unsigned(pixel_row) <= 267  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
				chr_addressrightarrow <= "01101111" & std_logic_vector(resize(unsigned(pixel_row) - 252,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
				if  unsigned(pixel_col) >= 624 and unsigned(pixel_col) <= 639 then
					if chr_rowrightarrow(to_integer(639 - unsigned(pixel_col))) = '1'   then
							if chr_numrightarrow = '1' then 
								R <= "0000000000";
								G <= "1111111111";
								B <= "0000000000";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;	
					end if;

				end if;
			end if;
				
				
				if unsigned(pixel_row) >= 464 and unsigned(pixel_row) <= 479  then
				
						-- Truncate the standard logic vector from 10bits to 8 bits and concatenate 3bits for address row
						-- for identifying which row in the mif file to use.  The address used in the mif files is 11bits
						chr_addressbotarrow <= "01101111" & std_logic_vector(resize(unsigned(pixel_row) - 464,4));
			
					-- This if statement is used to determine where in the pixel column spread the 8 bits are drawn	
					if  unsigned(pixel_col) >= 315 and unsigned(pixel_col) <= 330 then
						if chr_rowbotarrow(to_integer(330 - unsigned(pixel_col))) = '1'   then

							if chr_numbotarrow = '1' then 
								R <= "0000000000";
								G <= "1111111111";
								B <= "0000000000";
							else 
								R <= "0000000000";
								G <= "0000000000";
								B <= "0000000000";
								end if;
						
						end if;

					end if;
					end if;
	-----------------------			
			end if;
		end if;
	end process rgb_generate;
	-- Set constant signals blank, sync, clock
	vga_blank_out <= '1';
	vga_sync_out <= '0';
	clock_27Mhz_out <= clock_27Mhz;
end architecture arch_Memory;
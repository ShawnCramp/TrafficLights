LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;


-- VGA Video Sync generation

ENTITY vga_sync IS

	PORT(	clock_27Mhz, red, green, blue 		: IN	STD_LOGIC;
			video_on										: buffer std_logic;
			red_out, green_out, blue_out, 
			horiz_sync_out, vert_sync_out 		: OUT	STD_LOGIC;
			pixel_row, pixel_column					: OUT std_logic_vector(15 DOWNTO 0));
END vga_sync;

ARCHITECTURE rtl OF vga_sync IS
	SIGNAL horiz_sync, vert_sync 			: STD_LOGIC;
	SIGNAL video_on_v, video_on_h 		: STD_LOGIC;
	SIGNAL h_count, v_count 				: std_logic_vector(15 DOWNTO 0);

BEGIN

-- video_on is high only when RGB data is being displayed
 video_on <= video_on_H AND video_on_V;

--Generate Horizontal and Vertical Timing Signals for Video Signal

 PROCESS
 BEGIN
	WAIT UNTIL(clock_27Mhz'EVENT) AND (clock_27Mhz='1');

	-- H_count counts pixels (640 + extra time for sync signals)
	-- 
	--  Horiz_sync  ------------------------------------__________--------
	--  H_count       0                640             659       755    799
	--
	IF (h_count = 799) THEN
   		h_count 			<= "0000000000000000";
	ELSE
   		h_count 			<= h_count + 1;
	END IF;

	--Generate Horizontal Sync Signal using H_count
	IF (h_count <= 755) AND (h_count >= 659) THEN
 	  	horiz_sync 			<= '0';
	ELSE
 	  	horiz_sync 			<= '1';
	END IF;


	--V_count counts rows of pixels (480 + extra time for sync signals)
	--  
	--  Vert_sync      ----------------------------------_______------------
	--  V_count         0                         480    493-494          524
	--
	IF (v_count >= 524) AND (h_count >= 799) THEN
   		v_count 			<= "0000000000000000";
	ELSIF (h_count = 799) THEN
   		v_count 			<= v_count + 1;
	END IF;

		-- Generate Vertical Sync Signal using V_count
	IF (v_count <= 494) AND (v_count >= 493) THEN
   		vert_sync 		<= '0';
	ELSE
  		vert_sync 			<= '1';
	END IF;

		-- Generate Video on Screen Signals for Pixel Data
	IF (h_count <= 639) THEN
   		video_on_h 		<= '1';
   		pixel_column 	<= h_count;
	ELSE
	   	video_on_h 		<= '0';
	END IF;

	IF (v_count <= 479) THEN
   		video_on_v 		<= '1';
   		pixel_row 		<= v_count;
	ELSE
   		video_on_v 		<= '0';
	END IF;

				-- Put all video signals through DFFs to elminate 
				-- any logic delays that can cause a blurry image
		red_out 				<= red AND video_on;
		green_out 			<= green AND video_on;
		blue_out 			<= blue AND video_on;
		horiz_sync_out 	<= horiz_sync;
		vert_sync_out 		<= vert_sync;

 END PROCESS;

END rtl;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
--USE IEEE.STD_LOGIC_ARITH.all;
--USE IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

PACKAGE vga_sync_p IS 
	COMPONENT vga_sync IS 
		PORT(	clock_27Mhz							: IN	STD_LOGIC;
				horiz_sync_out, vert_sync_out	: OUT	STD_LOGIC;
				video_on								: OUT STD_LOGIC;
				pixel_row, pixel_column			: OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT vga_sync; 
END PACKAGE vga_sync_p; 
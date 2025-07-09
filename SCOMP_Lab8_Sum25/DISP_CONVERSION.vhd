library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--  disp_conversion.vhd
--  Simple port‑stub that will eventually translate two packed numeric values
--  (one 4‑digit and one 2‑digit) into the 42‑bit 7‑segment pattern required
--  for six displays.  No internal logic yet – just declarations so the file
--  can be added to a Quartus project without errors.

entity DISP_CONVERSION is
    port (
        GRP0_VALUE : in  std_logic_vector(12 downto 0); -- digits 0 .. 3
        GRP1_VALUE : in  std_logic_vector(12 downto 0); -- digits 4 .. 5
		  MODE		 : in  std_logic_vector(1 downto 0); -- mode

        -- Output to 7‑segment driver (6 digits x 7 segments = 42 bits)
        SEGMENTS_42 : out std_logic_vector(41 downto 0)
    );
end entity DISP_CONVERSION;

architecture stub of DISP_CONVERSION is
begin
    SEGMENTS_42 <= (others => '0');
end architecture stub;

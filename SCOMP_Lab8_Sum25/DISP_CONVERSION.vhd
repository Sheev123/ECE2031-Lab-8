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
	MODE	   : in  std_logic_vector(1 downto 0);  -- mode
	UPDATE     : in  std_logic;                     -- '1' = latch new data
        -- Output to 7‑segment driver (6 digits x 7 segments = 42 bits)
        SEGMENTS_42 : out std_logic_vector(41 downto 0)
    );
end entity DISP_CONVERSION;

architecture rtl of DISP_CONVERSION is
	function nibble_to_7seg(n : unsigned(3 downto 0)) return std_logic_vector is
	        variable seg : std_logic_vector(6 downto 0);
	    begin
	        case n is
	            when "0000" => seg := "1000000"; -- 0
	            when "0001" => seg := "1111001"; -- 1
	            when "0010" => seg := "0100100"; -- 2
	            when "0011" => seg := "0110000"; -- 3
	            when "0100" => seg := "0011001"; -- 4
	            when "0101" => seg := "0010010"; -- 5
	            when "0110" => seg := "0000010"; -- 6
	            when "0111" => seg := "1111000"; -- 7
	            when "1000" => seg := "0000000"; -- 8
	            when "1001" => seg := "0010000"; -- 9
	            when "1010" => seg := "0001000"; -- A
	            when "1011" => seg := "0000011"; -- b
	            when "1100" => seg := "1000110"; -- C
	            when "1101" => seg := "0100001"; -- d
	            when "1110" => seg := "0000110"; -- E
	            when "1111" => seg := "0001110"; -- F
	            when others => seg := "0111111"; -- Blank / dash
	        end case;
	        return seg;
	    end function;
	
	function dec_to_7seg(d : integer) return std_logic_vector is
	    begin
	        return nibble_to_7seg(to_unsigned(d, 4));
	    end function;
	
	signal latched_segments : std_logic_vector(41 downto 0) := (others => '1'); -- All segments off by default

begin
	process(GRP0_VALUE, GRP1_VALUE, MODE, UPDATE)
        variable tmp : std_logic_vector(41 downto 0) := (others => '1');
        variable nib : unsigned(3 downto 0);
        variable val : integer;
        variable dig : integer;
    begin
        -- Generate new 7-segment data based on mode
        if MODE = "00" then -- HEX
            for i in 0 to 3 loop
                if (i*4+3) <= 12 then
                    nib := unsigned(GRP0_VALUE(i*4+3 downto i*4));
                else
                    nib := (others => '0');
                end if;
                tmp(i*7+6 downto i*7) := nibble_to_7seg(nib);
            end loop;

            for i in 0 to 1 loop
                if (i*4+3) <= 12 then
                    nib := unsigned(GRP1_VALUE(i*4+3 downto i*4));
                else
                    nib := (others => '0');
                end if;
                tmp((i+4)*7+6 downto (i+4)*7) := nibble_to_7seg(nib);
            end loop;

        elsif MODE = "01" then -- DECIMAL
            val := to_integer(unsigned(GRP0_VALUE));
            for i in 0 to 3 loop
                dig := val mod 10;
                val := val / 10;
                tmp(i*7+6 downto i*7) := dec_to_7seg(dig);
            end loop;

            val := to_integer(unsigned(GRP1_VALUE));
            for i in 0 to 1 loop
                dig := val mod 10;
                val := val / 10;
                tmp((i+4)*7+6 downto (i+4)*7) := dec_to_7seg(dig);
            end loop;

        elsif MODE = "10" then -- BINARY
            for i in 0 to 3 loop
                dig := to_integer(unsigned(GRP0_VALUE(i downto i)));
                tmp(i*7+6 downto i*7) := dec_to_7seg(dig);
            end loop;

            for i in 0 to 1 loop
                dig := to_integer(unsigned(GRP1_VALUE(i downto i)));
                tmp((i+4)*7+6 downto (i+4)*7) := dec_to_7seg(dig);
            end loop;
        else
            tmp := (others => '1'); -- blank
        end if;

        -- Update the latched value only when UPDATE is '1'
        if UPDATE = '1' then
            latched_segments <= tmp;
        end if;
    end process;

    -- Drive output from latched value
    SEGMENTS_42 <= latched_segments (others => '0');
end architecture rtl;

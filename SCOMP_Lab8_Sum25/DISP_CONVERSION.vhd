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
		  GRP0_ENABLE : in std_logic;
		  GRP1_ENABLE : in std_logic;
	MODE	   : in  std_logic_vector(1 downto 0);  -- mode
        -- Output to 7‑segment driver (6 digits x 7 segments = 42 bits)
        SEGMENTS_42 : out std_logic_vector(41 downto 0)
    );
end entity DISP_CONVERSION;

architecture rtl of DISP_CONVERSION is
    signal latched_segments : std_logic_vector(41 downto 0) := (others => '1'); -- all OFF

begin
    process(GRP0_VALUE, GRP1_VALUE, MODE, GRP0_ENABLE, GRP1_ENABLE)
        variable tmp : std_logic_vector(41 downto 0) := latched_segments;
        variable val : integer;
        variable dig : integer;
        variable seg : std_logic_vector(6 downto 0);
    begin

-- GRP0_ENABLE == 1
        if GRP0_ENABLE = '1' then
            if MODE = "00" then  -- Hexadecimal
                for i in 0 to 3 loop
                    if (i*4+3) <= 12 then
                        case GRP0_VALUE(i*4+3 downto i*4) is
                            when "0000" => seg := "1000000";
                            when "0001" => seg := "1111001";
                            when "0010" => seg := "0100100";
                            when "0011" => seg := "0110000";
                            when "0100" => seg := "0011001";
                            when "0101" => seg := "0010010";
                            when "0110" => seg := "0000010";
                            when "0111" => seg := "1111000";
                            when "1000" => seg := "0000000";
                            when "1001" => seg := "0010000";
                            when "1010" => seg := "0001000";
                            when "1011" => seg := "0000011";
                            when "1100" => seg := "1000110";
                            when "1101" => seg := "0100001";
                            when "1110" => seg := "0000110";
                            when "1111" => seg := "0001110";
                            when others => seg := "0111111";
                        end case;
                    else
                        seg := "0111111"; -- blank
                    end if;
                    tmp(i*7+6 downto i*7) := seg;
                end loop;

            elsif MODE = "01" then  -- Decimal
                val := to_integer(unsigned(GRP0_VALUE));
                for i in 0 to 3 loop
                    dig := val mod 10;
                    val := val / 10;
                    case dig is
                        when 0 => seg := "1000000";
                        when 1 => seg := "1111001";
                        when 2 => seg := "0100100";
                        when 3 => seg := "0110000";
                        when 4 => seg := "0011001";
                        when 5 => seg := "0010010";
                        when 6 => seg := "0000010";
                        when 7 => seg := "1111000";
                        when 8 => seg := "0000000";
                        when 9 => seg := "0010000";
                        when others => seg := "0111111";
                    end case;
                    tmp(i*7+6 downto i*7) := seg;
                end loop;

            elsif MODE = "10" then  -- Binay
                for i in 0 to 3 loop
                    if GRP0_VALUE(i) = '1' then dig := 1; else dig := 0; end if;
                    case dig is
                        when 0 => seg := "1000000"; -- 0
                        when 1 => seg := "1111001"; -- 1
                        when others => seg := "0111111";
                    end case;
                    tmp(i*7+6 downto i*7) := seg;
                end loop;
            end if;
        end if;

-- GRP1_ENABLE == 1
        if GRP1_ENABLE = '1' then
            if MODE = "00" then  -- Hexadecimal
                for i in 0 to 1 loop
                    if (i*4+3) <= 12 then
                        case GRP1_VALUE(i*4+3 downto i*4) is
                            when "0000" => seg := "1000000";
                            when "0001" => seg := "1111001";
                            when "0010" => seg := "0100100";
                            when "0011" => seg := "0110000";
                            when "0100" => seg := "0011001";
                            when "0101" => seg := "0010010";
                            when "0110" => seg := "0000010";
                            when "0111" => seg := "1111000";
                            when "1000" => seg := "0000000";
                            when "1001" => seg := "0010000";
                            when "1010" => seg := "0001000";
                            when "1011" => seg := "0000011";
                            when "1100" => seg := "1000110";
                            when "1101" => seg := "0100001";
                            when "1110" => seg := "0000110";
                            when "1111" => seg := "0001110";
                            when others => seg := "0111111";
                        end case;
                    else
                        seg := "0111111";
                    end if;
                    tmp((i+4)*7+6 downto (i+4)*7) := seg;
                end loop;

            elsif MODE = "01" then  -- Decimal
                val := to_integer(unsigned(GRP1_VALUE));
                for i in 0 to 1 loop
                    dig := val mod 10;
                    val := val / 10;
                    case dig is
                        when 0 => seg := "1000000";
                        when 1 => seg := "1111001";
                        when 2 => seg := "0100100";
                        when 3 => seg := "0110000";
                        when 4 => seg := "0011001";
                        when 5 => seg := "0010010";
                        when 6 => seg := "0000010";
                        when 7 => seg := "1111000";
                        when 8 => seg := "0000000";
                        when 9 => seg := "0010000";
                        when others => seg := "0111111";
                    end case;
                    tmp((i+4)*7+6 downto (i+4)*7) := seg;
                end loop;

            elsif MODE = "10" then  -- Binary
                for i in 0 to 1 loop
                    if GRP1_VALUE(i) = '1' then dig := 1; else dig := 0; end if;
                    case dig is
                        when 0 => seg := "1000000"; -- 0
                        when 1 => seg := "1111001"; -- 1
                        when others => seg := "0111111";
                    end case;
                    tmp((i+4)*7+6 downto (i+4)*7) := seg;
                end loop;
            end if;
        end if;

	latched_segments <= tmp; -- Latched output
		    
    end process;
    SEGMENTS_42 <= latched_segments;
end architecture;

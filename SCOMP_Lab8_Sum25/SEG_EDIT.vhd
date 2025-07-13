library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SEG_EDIT is
    port (
        MODE            : in std_logic_vector(1 downto 0); -- must be "11"
        DLT             : in std_logic;                    -- turn edit mode to delete
        EDIT_DISP       : in std_logic_vector(2 downto 0); -- which digit (0‑5)
        EDIT_SEG        : in std_logic_vector(2 downto 0); -- which segment

        segments_in     : in std_logic_vector(41 downto 0); -- the current value on all HEX displays

        segments_out    : out std_logic_vector(41 downto 0) -- the newly edited vector of HEXes

    );
end entity SEG_EDIT;

architecture a of SEG_EDIT is
    -- Individual HEX signals
    signal HEX0               : std_logic_vector(6 downto 0);
    signal HEX1               : std_logic_vector(6 downto 0);
    signal HEX2               : std_logic_vector(6 downto 0);
    signal HEX3               : std_logic_vector(6 downto 0);
    signal HEX4               : std_logic_vector(6 downto 0);
    signal HEX5               : std_logic_vector(6 downto 0);

    -- HEX mask to edit individual segment
    signal mask               : std_logic_vector(6 downto 0);

    -- RESET and SET bit vectors
    constant RESET            : std_logic_vector(41 downto 0) := (others => '0');
    constant SET              : std_logic_vector(41 downto 0) := (others => '1');

begin
    -- chop up the signal segments_in into their respective HEXes
    HEX0    <= segments_in(6 downto 0);
    HEX1    <= segments_in(13 downto 7);
    HEX2    <= segments_in(20 downto 14);
    HEX3    <= segments_in(27 downto 21);
    HEX4    <= segments_in(34 downto 28);
    HEX5    <= segments_in(41 downto 35);

    process(MODE, segments_in, DLT, EDIT_DISP, EDIT_SEG)
        variable idx : integer;
    begin
        
        if MODE /= "11" then    -- if EDIT is not on, simply pass the display as it is
            segments_out <= segments_in;
        else
            -- Create bitmask to edit segment
            idx := to_integer(unsigned(EDIT_SEG));

            for i in 0 to 6 loop
                if i = idx then 
                    mask(i) <= '0';
                else
                    mask(i) <= '1';
                end if;
            end loop;

            case EDIT_DISP is
                when "000" =>   -- Edit a segment in HEX0
                    if DLT = '1' then -- LEDs are active-low
                        mask <= not mask;
                        HEX0 <= HEX0 or mask;
                    else
                        HEX0 <= HEX0 and mask;
                    end if;

                    segments_out <= HEX5 + HEX4 + HEX3 + HEX2 + HEX1 + HEX0;
                when "001" =>   -- Edit a segment in HEX1
                    if DLT = '1' then -- LEDs are active-low
                        mask <= not mask;
                        HEX1 <= HEX1 or mask;
                    else
                        HEX1 <= HEX1 and mask;
                    end if;

                    segments_out <= HEX5 + HEX4 + HEX3 + HEX2 + HEX1 + HEX0;

                when "010" =>   -- Edit a segment in HEX2
                    if DLT = '1' then -- LEDs are active-low
                        mask <= not mask;
                        HEX2 <= HEX2 or mask;
                    else
                        HEX2 <= HEX2 and mask;
                    end if;

                    segments_out <= HEX5 + HEX4 + HEX3 + HEX2 + HEX1 + HEX0;

                when "011" =>   -- Edit a segment in HEX3
                    if DLT = '1' then -- LEDs are active-low
                        mask <= not mask;
                        HEX3 <= HEX3 or mask;
                    else
                        HEX3 <= HEX3 and mask;
                    end if;

                    segments_out <= HEX5 + HEX4 + HEX3 + HEX2 + HEX1 + HEX0;

                when "100" =>   -- Edit a segment in HEX4
                    if DLT = '1' then -- LEDs are active-low
                        mask <= not mask;
                        HEX4 <= HEX4 or mask;
                    else
                        HEX4 <= HEX4 and mask;
                    end if;

                    segments_out <= HEX5 + HEX4 + HEX3 + HEX2 + HEX1 + HEX0;

                when "101" =>   -- Edit a segment in HEX5
                    if DLT = '1' then -- LEDs are active-low
                        mask <= not mask;
                        HEX5 <= HEX5 or mask;
                    else
                        HEX5 <= HEX5 and mask;
                    end if;

                    segments_out <= HEX5 + HEX4 + HEX3 + HEX2 + HEX1 + HEX0;

                when "110" =>   -- Turn OFF all segments - LEDs are active-low
                    segments_out <= SET;
                when "111" =>   -- Turn ON all segments - LEDs are active-low
                    segments_out <= RESET;
            end case;
        end if;
    end process;
end architecture a;

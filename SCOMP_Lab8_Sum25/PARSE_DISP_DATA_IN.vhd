library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PARSE_DISP_DATA_IN is
    port (
        IO_WRITE : in  std_logic;
        IO_ADDR  : in  std_logic_vector(10 downto 0);-- address (11‑bit)
        IO_DATA  : in  std_logic_vector(15 downto 0);-- data bus

        MODE      : out std_logic_vector(1 downto 0); -- 00=h,01=b,10=d,11=fc
        FC_ENABLE : out std_logic;                    -- full‑control master enable
        FC_DISP   : out std_logic_vector(2 downto 0); -- which digit (0‑5)
        FC_SEG    : out std_logic_vector(2 downto 0); -- which segment
		  
        GRP0_VALUE : out std_logic_vector(12 downto 0); -- 4‑digit value
        GRP0_WRITE : out std_logic;                      -- write pulse for grp0

        GRP1_VALUE : out std_logic_vector(12 downto 0); -- 2‑digit value
        GRP1_WRITE : out std_logic                       -- write pulse for grp1
    );
end entity PARSE_DISP_DATA_IN;

architecture comb of PARSE_DISP_DATA_IN is
    constant MODE_FC : std_logic_vector(1 downto 0) := "11";

    signal mode_s               : std_logic_vector(1 downto 0); -- 15‑14
    signal full_disp_override_s : std_logic;                     -- 13
    signal fc_enable_s          : std_logic;                     -- 12
    signal fc_disp_s            : std_logic_vector(2 downto 0); -- 11‑9
    signal fc_seg_s             : std_logic_vector(2 downto 0); --  8‑6
    signal value_s              : std_logic_vector(12 downto 0);-- 12‑0

    -- Write enables
    signal grp0_we_s, grp1_we_s : std_logic;

begin
    -- Split the incoming data word once
    mode_s               <= IO_DATA(15 downto 14);
    full_disp_override_s <= IO_DATA(13);
    fc_enable_s          <= IO_DATA(12);
    fc_disp_s            <= IO_DATA(11 downto 9);
    fc_seg_s             <= IO_DATA(8  downto 6);
    value_s              <= IO_DATA(12 downto 0);

    -- Shared outputs (identical for both display banks)
    MODE      <= mode_s;
    FC_ENABLE <= fc_enable_s when mode_s = MODE_FC else '0';
    FC_DISP   <= fc_disp_s   when mode_s = MODE_FC else (others => '0');
    FC_SEG    <= fc_seg_s    when mode_s = MODE_FC else (others => '0');

    -- Write‑enable generation
    -- addr 4: four‑digit group (grp0)
    -- addr 5: two‑digit group (grp1)
    -- full_disp_override extends addr 4 write to grp1 as well
    grp0_we_s <= IO_WRITE when IO_ADDR = "00000000100" else '0'; -- 4

    grp1_we_s <= IO_WRITE when (IO_ADDR = "00000000101") or      -- 5
                               (IO_ADDR = "00000000100" and full_disp_override_s = '1')
                 else '0';

    GRP0_WRITE <= grp0_we_s;
    GRP1_WRITE <= grp1_we_s;

    GRP0_VALUE <= value_s when grp0_we_s = '1' else (others => '0');
    GRP1_VALUE <= value_s when grp1_we_s = '1' else (others => '0');
	 -- grp1 will not output a value when in full 6-display mode, grp0 will have the value
	 -- otherwise, both values are determined by their write-enable flag which is determined
	 -- by the device we out to, just like in Lab 8.
	 
	 -- Note for full control: Even though we're outputing 13 bits, the first few are reserved
	 -- for additional flags as fc_*

end architecture comb;

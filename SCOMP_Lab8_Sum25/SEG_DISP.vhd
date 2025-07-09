LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

-- 7 Segment Decoder for LED Display
--  1) when free held low, displays latched data
--  2) when free held high, constantly displays input (free-run)
--  3) data is latched on rising edge of CS

ENTITY SEG_DISP IS
  PORT( seg_val  : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        cs       : IN STD_LOGIC := '0';
        free     : IN STD_LOGIC := '0';
        resetn   : IN STD_LOGIC := '1';
        segments : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END SEG_DISP;

ARCHITECTURE a OF SEG_DISP IS
  SIGNAL latched_seg : STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL seg_d       : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

  PROCESS (resetn, cs)
  BEGIN
    IF (resetn = '0') THEN
      latched_seg <= "0000000";
    ELSIF ( RISING_EDGE(cs) ) THEN
      latched_seg <= seg_val;
    END IF;
  END PROCESS;
  
  WITH free SELECT
    seg_d  <= latched_seg WHEN '0',
              seg_val     WHEN '1';
  segments <= seg_d;
END a;


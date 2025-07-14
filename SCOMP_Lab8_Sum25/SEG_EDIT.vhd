library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SEG_EDIT is
    port (
        EDIT_DISP       : in std_logic_vector(2 downto 0); -- which digit (0‑5)
        EDIT_SEG        : in std_logic_vector(2 downto 0); -- which segment



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

    process(MODE, segments_in, DLT, EDIT_DISP, EDIT_SEG)
        variable idx : integer;
    begin
        

		-- Create bitmask to edit segment
		idx := to_integer(unsigned(EDIT_SEG));

		for i in 0 to 6 loop
			 if i = idx then 
				  mask(i) <= '0';
			 else
				  mask(i) <= '1';
			 end if;
		end loop;


 end process;
end architecture a;

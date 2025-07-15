library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SEG_EDIT is
    port (
        FC_DISP         : in std_logic_vector(2 downto 0); -- which HEX (0‑5)
        FC_VALUE        : in std_logic_vector(6 downto 0); -- what value
        segments        : out std_logic_vector(41 downto 0) -- output
    );
end entity SEG_EDIT;

architecture a of SEG_EDIT is
    begin
    process(FC_DISP, FC_VALUE)
    begin
        case FC_DISP is
            when "000" =>
                segments <= "11111111111111111111111111111111111" & FC_VALUE;
            when "001" =>
                segments <= "1111111111111111111111111111" & FC_VALUE & "1111111";
            when "010" =>
                segments <= "111111111111111111111" & FC_VALUE & "11111111111111";
            when "100" =>
                segments <= "11111111111111" & FC_VALUE & "111111111111111111111";
            when "101" =>
                segments <= "1111111" & FC_VALUE & "1111111111111111111111111111";
            when "110" =>
                segments <= FC_VALUE & "11111111111111111111111111111111111";
            when others =>
                segments <= "000000000000000000000000000000000000000000";
        end case;

    end process;
end architecture a;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2022 03:16:01 PM
-- Design Name: 
-- Module Name: display - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display is
    Port ( 
        enable: in STD_LOGIC;
        sw_in: in STD_LOGIC_VECTOR(7 downto 0);
        clk: in STD_LOGIC;
        seg: out STD_LOGIC_VECTOR(6 downto 0);
        an: out STD_LOGIC_VECTOR(3 downto 0)
    );
end display;

architecture Behavioral of display is

signal s: STD_LOGIC_VECTOR(3 downto 0);
signal clk_counter : natural range 0 to 100000 := 0;
signal counter : natural range 0 to 1 := 0;

begin


    process(clk) is
    begin
        if rising_edge(clk) then
            
            -- switch anode to display, based on counter, counter switches according to perception vision range
            if clk_counter = 100000 then
                clk_counter <= 0;
                if counter = 1 then
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;
            else
                clk_counter <= clk_counter + 1;
            end if;
            
        end if;
    end process;
    
    -- select 4 bits from the 16 bit data to show in display at corresponding anode
    process(counter, enable) is
    begin
        case counter is
            when 0 => s <= sw_in(3 downto 0);
            when 1 => s <= sw_in(7 downto 4);
            when others => s <= "1111";
        end case;
    end process;
    
    -- switch anode according to counter so that it appears that both anodes are on simulataneously
    process(counter, enable) is
    begin
        if enable = '1' then
            case counter is
                when 0 => an <= "1110";
                when 1 => an <= "1101";
                when others => an <= "1111";
            end case;
        else
            an <= "1111";
        end if;
    end process;
    
    -- convert 4 bits to segments
    process(s) is
    begin
        seg(0) <= not ((s(3) and not s(2) and not s(1)) or (not s(3) and s(2) and s(0)) or (s(3) and not s(0)) or (not s(3) and s(1)) or (s(2) and s(1)) or (not s(2) and not s(0)));
        seg(1) <= not ((not s(3) and not s(1) and not s(0)) or (not s(3) and s(1) and s(0)) or (s(3) and not s(1) and s(0)) or (not s(2) and not s(1)) or (not s(2) and not s(0))); 
        seg(2) <= not ((not s(3) and not s(1)) or (not s(3) and s(0)) or (not s(1) and s(0)) or (not s(3) and s(2)) or (s(3) and not s(2)));
        seg(3) <= not ((not s(3) and not s(2) and not s(0)) or (not s(2) and s(1) and s(0)) or (s(2) and not s(1) and s(0)) or (s(2) and s(1) and not s(0)) or (s(3) and not s(1)));
        seg(4) <= not ((not s(2) and not s(0)) or (s(1) and not s(0)) or (s(3) and s(1)) or (s(3) and s(2)));
        seg(5) <= not ((not s(3) and s(2) and not s(1)) or (not s(1) and not s(0)) or (s(2) and not s(0)) or (s(3) and not s(2)) or (s(3) and s(1)));
        seg(6) <= not ((not s(3) and s(2) and not s(1)) or (not s(2) and s(1)) or (s(1) and not s(0)) or (s(3) and not s(2)) or (s(3) and s(0)));
    end process;



end Behavioral;

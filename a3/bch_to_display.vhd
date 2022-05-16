----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2022 07:03:48 AM
-- Design Name: 
-- Module Name: bch_to_display - Behavioral
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

entity bch_to_display is
    Port (
           clk : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR(15 downto 0);
           seg : out STD_LOGIC_VECTOR(6 downto 0); 
           an : out STD_LOGIC_VECTOR(3 downto 0));
end bch_to_display;

architecture Behavioral of bch_to_display is

signal s : STD_LOGIC_VECTOR(3 downto 0);
signal clk_counter : natural range 0 to 10000 := 0;
signal counter : natural range 0 to 3 := 0;
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            if clk_counter = 10000 then
                clk_counter <= 0;
                if counter = 3 then
                    counter <= 0;
                else
                    counter <= counter+1;
                end if;
            else
                clk_counter <= clk_counter+1;
            end if;
        end if;
    end process;
    
    process(counter) is
    begin
        case counter is
            when 0 => s <= sw(3 downto 0);
            when 1 => s <= sw(7 downto 4);
            when 2 => s <= sw(11 downto 8);
            when 3 => s <= sw(15 downto 12);
        end case;
    end process;
    
    process(counter) is
        begin
            case counter is
                when 0 => an <= "1110";
                when 1 => an <= "1101";
                when 2 => an <= "1011";
                when 3 => an <= "0111";
            end case;
        end process;
    
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

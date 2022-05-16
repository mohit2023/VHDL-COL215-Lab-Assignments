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
           an : out STD_LOGIC_VECTOR(3 downto 0) := "1111";
           btnL : in STD_LOGIC;
           btnR : in STD_LOGIC
           );
end bch_to_display;

architecture Behavioral of bch_to_display is

signal s : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal sws : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal swstore : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal clk_counter : natural range 0 to 400000 := 0;
signal counter : natural range 0 to 4 := 0;
signal rotate_counter : natural range 0 to 240000000 := 0;
signal rotate : natural range 0 to 3 := 0;
signal d1 : natural range 0 to 100000 := 25000;
signal d2 : natural range 0 to 100000 := 25000;
signal d3 : natural range 0 to 100000 := 25000;
signal d4 : natural range 0 to 100000 := 25000;
signal d1s : natural range 0 to 100000 := 25000;
signal d2s : natural range 0 to 100000 := 25000;
signal d3s : natural range 0 to 100000 := 25000;
signal d4s : natural range 0 to 100000 := 25000;
signal enable : STD_LOGIC := '0';
begin
    
    process(clk) is
    begin
        if rising_edge(clk) then
            if enable = '1' then
                if rotate_counter = 240000000 then
                    rotate_counter <= 0;
                    if rotate = 3 then
                        rotate <= 0;
                    else
                        rotate <= rotate+1;
                    end if;
                    swstore <= sws;
                    d1s <= d1;
                    d2s <= d2;
                    d3s <= d3;
                    d4s <= d4;
                else
                    rotate_counter <= rotate_counter+1;
                end if;
                
                if clk_counter = 400000 then
                    clk_counter <= 0;
                    counter <= 0;
                else
                    if clk_counter = d1s+d2s+d3s+d4s then
                        counter <= 4;
                    elsif clk_counter = d1s then
                        counter <= 1;
                    elsif clk_counter = d1s+d2s then
                        counter <= 2;
                    elsif clk_counter = d1s+d2s+d3s then
                        counter <= 3;
                    end if;
                    clk_counter <= clk_counter+1;
                end if;
            end if;
            
            if btnL = '1' then --take inputs
                if enable = '0' then
                    enable <= '1';
                    sws <= sw;
                    swstore <= sw;
                    d1s <= d1;
                    d2s <= d2;
                    d3s <= d3;
                    d4s <= d4;
                else
                    sws <= sw;
                end if;
            end if;
            if btnR = '1' then --change brightness
                if sw(1 downto 0) = "00" then
                    d1 <= 10000;
                elsif sw(1 downto 0) = "01" then
                    d1 <= 30000;
                elsif sw(1 downto 0) = "10" then
                    d1 <= 60000;
                elsif sw(1 downto 0) = "11" then
                    d1 <= 100000;
                end if;
                if sw(3 downto 2) = "00" then
                    d2 <= 10000;
                elsif sw(3 downto 2) = "01" then
                    d2 <= 30000;
                elsif sw(3 downto 2) = "10" then
                    d2 <= 60000;
                elsif sw(3 downto 2) = "11" then
                    d2 <= 100000;
                end if;
                if sw(5 downto 4) = "00" then
                    d3 <= 10000;
                elsif sw(5 downto 4) = "01" then
                    d3 <= 30000;
                elsif sw(5 downto 4) = "10" then
                    d3 <= 60000;
                elsif sw(5 downto 4) = "11" then
                    d3 <= 100000;
                end if;
                if sw(7 downto 6) = "00" then
                    d4 <= 10000;
                elsif sw(7 downto 6) = "01" then
                    d4 <= 30000;
                elsif sw(7 downto 6) = "10" then
                    d4 <= 60000;
                elsif sw(7 downto 6) = "11" then
                    d4 <= 100000;
                end if;
            end if;
        end if;
    end process;

    process(counter) is
    begin
        case counter is
            when 0 => s <= swstore(3 downto 0);
            when 1 => s <= swstore(7 downto 4);
            when 2 => s <= swstore(11 downto 8);
            when 3 => s <= swstore(15 downto 12);
            when others => s <= swstore(3 downto 0);
        end case;
    end process;

    process(counter, enable, rotate) is
    begin
        if enable = '1' then
            if counter = 4 then
                an <= "1111";
            else
                case counter+rotate is
                    when 0 => an <= "1110";
                    when 1 => an <= "1101";
                    when 2 => an <= "1011";
                    when 3 => an <= "0111";
                    when 4 => an <= "1110";
                    when 5 => an <= "1101";
                    when 6 => an <= "1011";
                    when others => an <= "1111";
                end case;
            end if;
        else
            an <= "1111";
        end if;
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
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
           sw : in STD_LOGIC_VECTOR(3 downto 0);
           seg : out STD_LOGIC_VECTOR(6 downto 0); 
           an : out STD_LOGIC_VECTOR(3 downto 0));
end bch_to_display;

architecture Behavioral of bch_to_display is

begin
    process(sw) is
    begin
        seg(0) <= not ((sw(3) and not sw(2) and not sw(1)) or (not sw(3) and sw(2) and sw(0)) or (sw(3) and not sw(0)) or (not sw(3) and sw(1)) or (sw(2) and sw(1)) or (not sw(2) and not sw(0)));
        seg(1) <= not ((not sw(3) and not sw(1) and not sw(0)) or (not sw(3) and sw(1) and sw(0)) or (sw(3) and not sw(1) and sw(0)) or (not sw(2) and not sw(1)) or (not sw(2) and not sw(0))); 
        seg(2) <= not ((not sw(3) and not sw(1)) or (not sw(3) and sw(0)) or (not sw(1) and sw(0)) or (not sw(3) and sw(2)) or (sw(3) and not sw(2)));
        seg(3) <= not ((not sw(3) and not sw(2) and not sw(0)) or (not sw(2) and sw(1) and sw(0)) or (sw(2) and not sw(1) and sw(0)) or (sw(2) and sw(1) and not sw(0)) or (sw(3) and not sw(1)));
        seg(4) <= not ((not sw(2) and not sw(0)) or (sw(1) and not sw(0)) or (sw(3) and sw(1)) or (sw(3) and sw(2)));
        seg(5) <= not ((not sw(3) and sw(2) and not sw(1)) or (not sw(1) and not sw(0)) or (sw(2) and not sw(0)) or (sw(3) and not sw(2)) or (sw(3) and sw(1)));
        seg(6) <= not ((not sw(3) and sw(2) and not sw(1)) or (not sw(2) and sw(1)) or (sw(1) and not sw(0)) or (sw(3) and not sw(2)) or (sw(3) and sw(0)));
        an <= "1110";
    end process;

end Behavioral;

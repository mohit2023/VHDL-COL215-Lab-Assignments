----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2022 04:50:06 PM
-- Design Name: 
-- Module Name: debounce - Behavioral
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

entity debounce is
    Port (
        clk: in STD_LOGIC;
        btn: in STD_LOGIC;
        res: out STD_LOGIC := '0'
    );
end debounce;

architecture Behavioral of debounce is

signal state : natural range 0 to 1 := 0;
signal counter: natural range 0 to 100000 := 0;

begin

    process(clk) is
    begin
        if rising_edge(clk) then
            if state = 0 then                     -- waiting for button press
                if btn='1' then
                    state <= 1;
                    counter <= 0;
                end if;
                res <= '0';
            else
                if btn = '1' then                   -- combine long button press to single press and ignore fluctutations too.
                    counter <= 0;
                else
                    if counter = 100000 then        -- wait 1 ms for signal to remain 0 to say that button is pressed ones.
                        res <= '1';
                        state <= 0;
                    else
                        counter <= counter+1;
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;

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
           seg : out STD_LOGIC_VECTOR(6 downto 0); 
           an : out STD_LOGIC_VECTOR(3 downto 0);
           btnL : in STD_LOGIC;
           btnC : in STD_LOGIC;
           btnR : in STD_LOGIC
           );
end bch_to_display;

architecture Behavioral of bch_to_display is

signal s : STD_LOGIC_VECTOR(3 downto 0);
signal pause : STD_LOGIC := '1';
signal sws : STD_LOGIC_VECTOR(15 downto 0);
signal swt : STD_LOGIC_VECTOR(15 downto 0);
signal clk_counter : natural range 0 to 10000000 := 0;
signal counter : natural range 0 to 3 := 0;
signal anode_counter : natural range 0 to 100000;
signal seconds1 : natural range 0 to 9 := 0;
signal seconds2 : natural range 0 to 5 := 0;
signal minutes : natural range 0 to 9 := 0;
signal tenth : natural range 0 to 9 := 0;
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            if anode_counter = 100000 then
                anode_counter <= 0;
                if counter = 3 then
                    counter <= 0;
                else
                    counter <= counter+1;
                end if;
            else
                anode_counter <= anode_counter + 1;
            end if;
        
            if pause = '0' then
                if clk_counter = 10000000 then
                    clk_counter <= 0;
                    if tenth = 9 then
                        tenth <= 0;
                        if seconds1 = 9 then
                            seconds1 <= 0;
                            if seconds2 = 5 then
                                seconds2 <= 0;
                                if minutes = 9 then
                                    minutes <= 0;
                                else
                                    minutes <= minutes+1;
                                end if;
                            else
                                seconds2 <= seconds2+1;
                            end if;
                        else
                            seconds1 <= seconds1 + 1;
                        end if;
                    else
                        tenth <= tenth + 1;
                    end if;
                    sws <= swt;
                else
                    clk_counter <= clk_counter + 1;
                end if;    
            end if;

            if btnL = '1' then --pause
                pause <= '1';
            end if;
            if btnR = '1' then --resume
                pause <= '0';
--                clk_counter <= 0;
            end if;
            if btnC = '1' then --reset
                pause <= '1';
                clk_counter <= 0;
                minutes <= 0;
                seconds1 <= 0;
                seconds2 <= 0;
                tenth <= 0;
                sws <= swt;
            end if;
       end if;
    end process;

    process(tenth) is
    begin
        case tenth is
            when 0 => swt(3 downto 0) <= "0000";
            when 1 => swt(3 downto 0) <= "0001";
            when 2 => swt(3 downto 0) <= "0010";
            when 3 => swt(3 downto 0) <= "0011";
            when 4 => swt(3 downto 0) <= "0100";
            when 5 => swt(3 downto 0) <= "0101";
            when 6 => swt(3 downto 0) <= "0110";
            when 7 => swt(3 downto 0) <= "0111";
            when 8 => swt(3 downto 0) <= "1000";
            when 9 => swt(3 downto 0) <= "1001";
            when others => swt(3 downto 0) <= "1110";
        end case;
    end process;

    process(seconds1) is
    begin
        case seconds1 is
            when 0 => swt(7 downto 4) <= "0000";
            when 1 => swt(7 downto 4) <= "0001";
            when 2 => swt(7 downto 4) <= "0010";
            when 3 => swt(7 downto 4) <= "0011";
            when 4 => swt(7 downto 4) <= "0100";
            when 5 => swt(7 downto 4) <= "0101";
            when 6 => swt(7 downto 4) <= "0110";
            when 7 => swt(7 downto 4) <= "0111";
            when 8 => swt(7 downto 4) <= "1000";
            when 9 => swt(7 downto 4) <= "1001";
            when others => swt(7 downto 4) <= "1110";
        end case;
    end process;

    process(seconds2) is
    begin
        case seconds2 is
            when 0 => swt(11 downto 8) <= "0000";
            when 1 => swt(11 downto 8) <= "0001";
            when 2 => swt(11 downto 8) <= "0010";
            when 3 => swt(11 downto 8) <= "0011";
            when 4 => swt(11 downto 8) <= "0100";
            when 5 => swt(11 downto 8) <= "0101";
            when others => swt(11 downto 8) <= "1110";
        end case;
    end process;

    process(minutes) is
    begin
        case minutes is
            when 0 => swt(15 downto 12) <= "0000";
            when 1 => swt(15 downto 12) <= "0001";
            when 2 => swt(15 downto 12) <= "0010";
            when 3 => swt(15 downto 12) <= "0011";
            when 4 => swt(15 downto 12) <= "0100";
            when 5 => swt(15 downto 12) <= "0101";
            when 6 => swt(15 downto 12) <= "0110";
            when 7 => swt(15 downto 12) <= "0111";
            when 8 => swt(15 downto 12) <= "1000";
            when 9 => swt(15 downto 12) <= "1001";
            when others => swt(15 downto 12) <= "1110";
        end case;
    end process;

    process(counter) is
    begin
        case counter is
            when 0 => s <= sws(3 downto 0);
            when 1 => s <= sws(7 downto 4);
            when 2 => s <= sws(11 downto 8);
            when 3 => s <= sws(15 downto 12);
        end case;
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
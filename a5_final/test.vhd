----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2022 10:34:20 AM
-- Design Name: 
-- Module Name: test - Behavioral
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

entity test is
-- empty
end test;

architecture tb of test is

-- DUT component
component bch_to_display is
    Port ( clk : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           btnL : in STD_LOGIC;
           btnR : in STD_LOGIC);
end component;

signal s : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal sws : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal swstore : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal clk_counter : natural range 0 to 400000 := 0;
signal counter : natural range 0 to 4 := 0;
signal rotate_counter : natural range 0 to 400000 := 0;
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

signal clk: STD_LOGIC := '0';
signal sw: STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000"; 
signal seg_out: STD_LOGIC_VECTOR (6 downto 0);
signal an_out: STD_LOGIC_VECTOR (3 downto 0) := "1111";
signal btnL : STD_LOGIC := '0';
signal btnR : STD_LOGIC := '0';
constant clk_period : time := 10 ns; -- 100MHz

begin
    clk <= not clk after clk_period/2;
    
    -- Connect DUT
    DUT: bch_to_display port map(clk, sw, seg_out, an_out, btnL, btnR);
    
    process(clk) is
        begin
            if rising_edge(clk) then
                if enable = '1' then
                    if rotate_counter = 400000 then
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
    
    
    process
    begin
        
        wait for clk_period*1000;
        
        sw <= "0000000011111111";
        wait for clk_period*500;
        
        btnR <= '1';
        wait for clk_period*10;
        btnR <= '0';
        
        sw <= "0011001000010000";
        wait for clk_period*500;
        
        btnL <= '1';
        wait for clk_period*10;
        btnL <= '0';
        
        wait for clk_period*300000;
        
        sw <= "1111001000010000";
        wait for clk_period*3000;
        
        btnL <= '1';
        wait for clk_period*10;
        btnL <= '0';
        
        sw <= "0000000000000001";
        btnR <= '1';
        wait for clk_period*10;
        btnR <= '0';
        
        sw <= "0011001000010001";
        wait for clk_period*200000;
                
        -- Clear inputs
        sw <= "0011001000010000";
    
        assert false report "Test done." severity note;
        wait;
    end process;

end tb;
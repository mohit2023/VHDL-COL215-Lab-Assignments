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
    Port (
           clk : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR(6 downto 0); 
           an : out STD_LOGIC_VECTOR(3 downto 0);
           btnL : in STD_LOGIC;
           btnC : in STD_LOGIC;
           btnR : in STD_LOGIC
           );
end component;

signal s : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal pause : STD_LOGIC := '1';
signal sws : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal swt : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal clk_counter : natural range 0 to 10000000 := 0;
signal counter : natural range 0 to 3 := 0;
signal anode_counter : natural range 0 to 100000;
signal seconds1 : natural range 0 to 9 := 0;
signal seconds2 : natural range 0 to 5 := 0;
signal minutes : natural range 0 to 9 := 0;
signal tenth : natural range 0 to 9 := 0;

signal clk: STD_LOGIC := '0';
signal seg: STD_LOGIC_VECTOR (6 downto 0);
signal an: STD_LOGIC_VECTOR (3 downto 0);
signal btnL : STD_LOGIC := '0';
signal btnR : STD_LOGIC := '0';
signal btnC : STD_LOGIC := '0';
constant clk_period : time := 10 ns; -- 100MHz

begin
    clk <= not clk after clk_period/2;
    
    -- Connect DUT
    DUT: bch_to_display port map(clk, seg, an, btnL, btnC, btnR);
    
    process(clk)
        begin
            if rising_edge(clk) then
                if anode_counter = 1000 then
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
                    if clk_counter = 10000 then
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
    
    
    process
    begin
        
        wait for clk_period*100000;
        
        btnR <= '1';
        wait for clk_period*10;
        btnR <= '0';
        
        wait for clk_period*400000;
        
        btnR <= '1';
        wait for clk_period*100000;
        btnR <= '0';
        
        wait for clk_period*500000;
                
        btnL <= '1';
        wait for clk_period*10;
        btnL <= '0';
        
        wait for clk_period*500000;
                
        btnC <= '1';
        wait for clk_period*100000;
        btnC <= '0';
        
        wait for clk_period*500000;
                
        btnR <= '1';
        wait for clk_period*100000;
        btnR <= '0';
        
        wait for clk_period*500000;
                
        btnC <= '1';
        wait for clk_period*10;
        btnC <= '0';
        
        wait for clk_period*500000;
                
        btnR <= '1';
        wait for clk_period*10;
        btnR <= '0';
        
--        wait for clk_period*60000000;
        
        wait for clk_period*100000;
                
    
        assert false report "Test done." severity note;
        wait;
    end process;

end tb;
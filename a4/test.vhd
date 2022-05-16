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
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal clk: STD_LOGIC := '0';
signal sw: STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000"; 
signal seg_out: STD_LOGIC_VECTOR (6 downto 0);
signal an_out: STD_LOGIC_VECTOR (3 downto 0);
--signal s : STD_LOGIC_VECTOR(3 downto 0);
signal clk_counter : natural range 0 to 25500 := 0;
signal counter : natural range 0 to 3 := 0;
signal rotate_counter : natural range 0 to 262144000 := 0;
signal rotate : natural range 0 to 3 := 0;
constant clk_period : time := 10 ns; -- 100MHz

begin
    clk <= not clk after clk_period/2;
    
    -- Connect DUT
    DUT: bch_to_display port map(clk, sw, seg_out, an_out);
    
    process(clk)
        begin
            if rising_edge(clk) then
                if rotate_counter = 262144000 then
                    rotate_counter <= 0;
                    if rotate = 3 then
                        rotate <= 0;
                    else
                        rotate <= rotate+1;
                    end if;
                else
                    rotate_counter <= rotate_counter+1;
                end if;
                
                if clk_counter = 25500 then
                    clk_counter <= 0;
                    counter <= 0;
                else
                    if clk_counter = 300 then
                        counter <= 1;
                    elsif clk_counter = 1500 then
                        counter <= 2;
                    elsif clk_counter = 6300 then
                        counter <= 3;
                    end if;
                    clk_counter <= clk_counter+1;
                end if;
                
            end if;
        end process;
    
    
    process
    begin
        sw <= "0011001000010000";
        wait for clk_period*300;
        assert(seg_out="1000000" and an_out="1110") 
        report "Fail 0000" severity error;
        
        sw <= "0011001000010000";
        wait for clk_period*1200;
        assert(seg_out="1111001" and an_out="1101") 
        report "Fail 0001" severity error;
        
        sw <= "0011001000010000";
        wait for clk_period*4800;
        assert(seg_out="0100100" and an_out="1011") 
        report "Fail 0010" severity error;
        
        sw <= "0011001000010000";
        wait for clk_period*19200;
        assert(seg_out="0110000" and an_out="0111") 
        report "Fail 0011" severity error;
                
        -- Clear inputs
        sw <= "0011001000010000";
    
        assert false report "Test done." severity note;
        wait;
    end process;

end tb;
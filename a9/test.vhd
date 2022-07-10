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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test is
-- empty
end test;

architecture tb of test is

-- DUT component
component fifo is
    Port ( 
        clk: in STD_LOGIC;
        btnL: in STD_LOGIC;
        btnR: in STD_LOGIC;
        sw: in STD_LOGIC_VECTOR(7 downto 0) ;
        seg: out STD_LOGIC_VECTOR(6 downto 0);
        an: out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;

signal btnL: STD_LOGIC := '0';
signal btnR: STD_LOGIC := '0';
signal sw: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
signal seg : STD_LOGIC_VECTOR(6 downto 0);
signal an : STD_LOGIC_VECTOR(3 downto 0) := "1111";

signal clk: STD_LOGIC := '0';
constant clk_period : time := 10 ns; -- 100MHz

begin
    clk <= not clk after clk_period/2;
    
    -- Connect DUT
    DUT: fifo port map(clk, btnL, btnR, sw, seg, an);
    
    process
    begin
        
        sw(0) <= '1';
        wait for clk_period*100;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;

        sw(1) <= '1';
        wait for clk_period*100;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        sw(2) <= '1';
        wait for clk_period*100;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnR <= '1';
        wait for clk_period*100;
        btnR <= '0';
        wait for clk_period*200;
        
        sw(2) <= '1';
        wait for clk_period*100;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnR <= '1';
        wait for clk_period*100;
        btnR <= '0';
        wait for clk_period*200;
        
        btnR <= '1';
        wait for clk_period*100;
        btnR <= '0';
        wait for clk_period*200;
                
        btnR <= '1';
        wait for clk_period*100;
        btnR <= '0';
        wait for clk_period*200;
        
        sw(2 downto 0) <= "001";
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
        
        btnL <= '1';
        wait for clk_period*100;
        btnL <= '0';
        wait for clk_period*200;
                                                                
                                                                
    
        assert false report "Test done." severity note;
        wait;
    end process;

end tb;
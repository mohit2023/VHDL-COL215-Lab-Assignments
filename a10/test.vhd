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
component code is
    Port ( 
        clk : in STD_LOGIC;
        btnU: in STD_LOGIC;
        btnD: in STD_LOGIC;
        RsRx: in STD_LOGIC;
        RsTx: out STD_LOGIC := '1';
        seg : out STD_LOGIC_VECTOR(6 downto 0); 
        an : out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;

signal clk: STD_LOGIC := '0';
constant clk_period : time := 10 ns; -- 100MHz

signal btnU: STD_LOGIC;
signal btnD:  STD_LOGIC;
signal RsRx:  STD_LOGIC;
signal RsTx:  STD_LOGIC;
signal seg :  STD_LOGIC_VECTOR(6 downto 0); 
signal an :  STD_LOGIC_VECTOR(3 downto 0);

begin
    clk <= not clk after clk_period/2;
    
    -- Connect DUT
    DUT: code port map(clk, btnU, btnD, RsRx, RsTx, seg, an);

    
    process
    begin
        
        RsRx <= '1';
        wait for clk_period*10416;
        
        btnD <= '1';
        wait for clk_period*100;
        btnD <= '0';
        wait for clk_period*10000*25;
        
        RsRx <= '0'; -- start
        wait for clk_period*10416;
        RsRx <= '0'; -- 1
        wait for clk_period*10416;
        RsRx <= '0'; -- 2
        wait for clk_period*10416;        
        RsRx <= '0'; -- 3
        wait for clk_period*10416;
        RsRx <= '1'; -- 4
        wait for clk_period*10416;
        RsRx <= '0'; -- 5
        wait for clk_period*10416;
        RsRx <= '1'; -- 6
        wait for clk_period*10416;
        RsRx <= '0'; -- 7
        wait for clk_period*10416;
        RsRx <= '0'; -- 8
        wait for clk_period*10416;
        RsRx <= '1'; -- stop bit
        wait for clk_period*10416;
        
        RsRx <= '1';
        wait for clk_period*10416;
        
        RsRx <= '0'; -- start
        wait for clk_period*10416;
        RsRx <= '1'; -- 1
        wait for clk_period*10416;
        RsRx <= '0'; -- 2
        wait for clk_period*10416;        
        RsRx <= '0'; -- 3
        wait for clk_period*10416;
        RsRx <= '0'; -- 4
        wait for clk_period*10416;
        RsRx <= '0'; -- 5
        wait for clk_period*10416;
        RsRx <= '0'; -- 6
        wait for clk_period*10416;
        RsRx <= '0'; -- 7
        wait for clk_period*10416;
        RsRx <= '0'; -- 8
        wait for clk_period*10416;
        RsRx <= '1'; -- stop bit
        wait for clk_period*10416;
        
        RsRx <= '1';
        wait for clk_period*10416;
        
        
        RsRx <= '0'; -- start
        wait for clk_period*10416;
        RsRx <= '0'; -- 1
        wait for clk_period*10416;
        RsRx <= '1'; -- 2
        wait for clk_period*10416;        
        RsRx <= '0'; -- 3
        wait for clk_period*10416;
        RsRx <= '0'; -- 4
        wait for clk_period*10416;
        RsRx <= '0'; -- 5
        wait for clk_period*10416;
        RsRx <= '0'; -- 6
        wait for clk_period*10416;
        RsRx <= '0'; -- 7
        wait for clk_period*10416;
        RsRx <= '0'; -- 8
        wait for clk_period*10416;
        RsRx <= '1'; -- stop bit
        wait for clk_period*10416;
                
        RsRx <= '1';
        wait for clk_period*10416*5;
        
        btnU <= '1';
        wait for clk_period*100;
        btnU <= '0';
        wait for clk_period*1000000;
        
        RsRx <= '0'; -- start
        wait for clk_period*10416;
        RsRx <= '0'; -- 1
        wait for clk_period*10416;
        RsRx <= '1'; -- 2
        wait for clk_period*10416;        
        RsRx <= '0'; -- 3
        wait for clk_period*10416;
        RsRx <= '0'; -- 4
        wait for clk_period*10416;
        RsRx <= '0'; -- 5
        wait for clk_period*10416;
        RsRx <= '0'; -- 6
        wait for clk_period*10416;
        RsRx <= '0'; -- 7
        wait for clk_period*10416;
        RsRx <= '0'; -- 8
        wait for clk_period*10416;
        RsRx <= '1'; -- stop bit
        wait for clk_period*10416;
        
        btnD <= '1';
        wait for clk_period*100;
        btnD <= '0';
        wait for clk_period*10000*25;
        
        RsRx <= '0'; -- start
        wait for clk_period*10416;
        RsRx <= '0'; -- 1
        wait for clk_period*10416;
        RsRx <= '0'; -- 2
        wait for clk_period*10416;        
        RsRx <= '0'; -- 3
        wait for clk_period*10416;
        RsRx <= '1'; -- 4
        wait for clk_period*10416;
        RsRx <= '0'; -- 5
        wait for clk_period*10416;
        RsRx <= '1'; -- 6
        wait for clk_period*10416;
        RsRx <= '0'; -- 7
        wait for clk_period*10416;
        RsRx <= '0'; -- 8
        wait for clk_period*10416;
        RsRx <= '1'; -- stop bit
        wait for clk_period*10416;
        
        RsRx <= '1';
        wait for clk_period*10416;
        
        btnU <= '1';
        wait for clk_period*100;
        btnU <= '0';
        wait for clk_period*100000;
        
        
    
        assert false report "Test done." severity note;
        wait;
    end process;

end tb;
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
        btnC: in STD_LOGIC;
        RsRx: in STD_LOGIC;
        RsTx: out STD_LOGIC := '1';
        seg : out STD_LOGIC_VECTOR(6 downto 0); 
        an : out STD_LOGIC_VECTOR(3 downto 0) := "1111"
    );
end component;

signal btnC: STD_LOGIC := '0';
signal RsRx: STD_LOGIC;
signal RsTx: STD_LOGIC := '1';
signal seg : STD_LOGIC_VECTOR(6 downto 0);
signal an : STD_LOGIC_VECTOR(3 downto 0) := "1111";

--signal state : natural range 0 to 5 := 5;
-- 0 : idle state (trying to detetct start bit)
-- 1 : sampling start bit
-- 2 : read 8 bits of data
-- 3 : read stop bit (if 1 then go to state 0, else to state 4)
-- 4 : synchronising gtkterm and code in fpga (by detecting 8 continuous bits)
-- 5 : waiting for user to press reset button to synchronise
--signal rclk : STD_LOGIC := '0';
--signal r_counter : natural range 0 to 325 := 325;
--signal sample_count : natural range 0 to 6;
--signal skip_count : natural range 0 to 160;
--signal bits : STD_LOGIC_VECTOR(7 downto 0);
--signal bit_count : natural range 0 to 7;
--signal set : STD_LOGIC := '0';
--signal enable : STD_LOGIC := '0';
--signal s : STD_LOGIC_VECTOR(3 downto 0);
--signal swstore : STD_LOGIC_VECTOR(7 downto 0);
--signal clk_counter : natural range 0 to 65000 := 0;
--signal counter : natural range 0 to 1 := 0;


signal clk: STD_LOGIC := '0';
constant clk_period : time := 10 ns; -- 100MHz

begin
    clk <= not clk after clk_period/2;
    
    -- Connect DUT
    DUT: code port map(clk, btnC, RsRx, RsTx, seg, an);

    
    process
    begin
        
        RsRx <= '1';
        wait for clk_period*10416;
        
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
        
        btnC <= '1';
        wait for clk_period*10000;
        btnC <= '0';
        wait for clk_period*10416*12;
        
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
        RsRx <= '0'; -- stop bit
        wait for clk_period*10416;
        
        RsRx <= '1';
        wait for clk_period*10416*12;
        
        
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
        
        RsRx <= '0'; -- start
        wait for clk_period*10416;
        RsRx <= '1'; -- 1
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
                
        -- Clear inputs
        RsRx <= '1';
    
        assert false report "Test done." severity note;
        wait;
    end process;

end tb;
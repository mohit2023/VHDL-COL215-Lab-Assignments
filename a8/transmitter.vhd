----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/20/2022 12:03:21 AM
-- Design Name: 
-- Module Name: transmitter - Behavioral
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

entity transmitter is
    Port ( 
        clk : in STD_LOGIC;
        transmit : in STD_LOGIC;
        swstore: in STD_LOGIC_VECTOR(7 downto 0);
        RsTx: out STD_LOGIC := '1'
    );
end transmitter;

architecture Behavioral of transmitter is

signal state : natural range 0 to 3 := 0;
-- 0: idle state, check if need to transmit, if yes then send start bit as 0 else be idle
-- 1: start bit transmitting
-- 2: send all 8 bits
-- 3: send stop bit
signal rclk : STD_LOGIC := '0';
signal r_counter : natural range 0 to 325 := 325;
signal skip_count : natural range 0 to 15;
signal bit_count : natural range 0 to 7;

begin

    process(clk) is
    begin
        if rising_edge(clk) then
        -- for generating approximate 9600bps*16 transmitting speed
            if r_counter = 325 then
                r_counter <= 0;
                rclk <= not rclk;
            else
                r_counter <= r_counter+1;
            end if;
        end if;
    end process;
    
    process(rclk) is
    begin
        if rising_edge(rclk) then
            if state = 0 then                          -- idle state
                if transmit = '1' then                 -- check if there is something to transmit  
                    state <= 1;                        -- transmit start bit as 0  
                    skip_count <= 0;
                    RsTx <= '0';
                end if;
            elsif state = 1 then                       -- start bit transmitting
                if skip_count = 14 then
                    state <= 2;
                    skip_count <= 0;
                    bit_count <= 0;
                else
                    skip_count <= skip_count+1;
                end if;
            elsif state = 2 then                      -- send all 8 bits of data one by one
                RsTx <= swstore(bit_count);
                if skip_count = 15 then               -- wait for 16 clock cycles before sending next bit as we have divided each bits clock cycles in 16 parts to be consistent with receiver speed
                    skip_count <= 0;
                    if bit_count = 7 then
                        state <= 3;
                    else
                        bit_count <= bit_count+1;
                    end if;
                else
                    skip_count <= skip_count+1;
                end if;
            elsif state = 3 then                       -- send stop bit
                RsTx <= '1';
                if skip_count = 15 then
                    state <= 0;
                else
                    skip_count <= skip_count+1;
                end if;
            end if;
        end if;
    end process;

end Behavioral;

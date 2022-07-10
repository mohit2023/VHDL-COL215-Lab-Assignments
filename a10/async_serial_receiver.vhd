----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/17/2022 09:51:12 AM
-- Design Name: 
-- Module Name: async_serial_receiver - Behavioral
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

entity async_serial_receiver is
    Port (
        clk : in STD_LOGIC;
        btnC: in STD_LOGIC;
        RsRx: in STD_LOGIC;
        swstore: out STD_LOGIC_VECTOR(7 downto 0);
        enable : out STD_LOGIC := '0';
        received: out STD_LOGIC := '0';
        rx_full: out STD_LOGIC := '0'
    );
end async_serial_receiver;

architecture Behavioral of async_serial_receiver is

signal state : natural range 0 to 4 := 4;
-- 0 : idle state (trying to detetct start bit)
-- 1 : sampling start bit
-- 2 : read 8 bits of data
-- 3 : read stop bit (if 1 then go to state 0, else to state 4)
-- 4 : synchronising gtkterm and code in fpga (by detecting 8 continuous bits)
signal rclk : STD_LOGIC := '0';
signal r_counter : natural range 0 to 325 := 325;
signal sample_count : natural range 0 to 6;
signal skip_count : natural range 0 to 160;
signal bits : STD_LOGIC_VECTOR(7 downto 0);
signal bit_count : natural range 0 to 7;
signal set : STD_LOGIC := '0';

begin

    process(clk) is
    begin
        if rising_edge(clk) then
            -- for generating approximate 9600bps*16 receiving speed
            if r_counter = 325 then
                r_counter <= 0;
                rclk <= not rclk;
            else
                r_counter <= r_counter+1;
            end if;
            
            --reset button
            if btnC = '1' then
                set <= '1';
            else
                if state = 4 then
                    set <= '0';
                end if;
            end if;
            
        end if;
    end process;
    
    process(rclk) is
    begin
        if rising_edge(rclk) then
            if set='1' then                                          -- user pressed push button to synchronise so start synchronising
                state <= 4;
                skip_count <= 0;
                received <= '0';
                rx_full <= '0';
                enable <= '0';
            else
                if state = 4 then                                       -- synchronise
                    if RsRx = '1' then
                        if skip_count = 160 then                        -- wait for 10 continuous 1 bytes as there will be no start bit
                            skip_count <= 0;
                            state <= 0;
                            rx_full <= '1';
                        else
                            skip_count <= skip_count+1;
                        end if;
                    else
                        skip_count <= 0;
                    end if;
                elsif state = 0 then                                    -- idle state (means it would be getting 1 from rsrx)
                    received <= '0';                                    -- reset received to 0 to not send same data again in transmit
                    if RsRx = '0' then                                  -- wait for start bit to be 0 
                        state <= 1;
                        rx_full <= '0';
                        sample_count <= 0;
                    end if;
                elsif state = 1 then                                    -- sample the start bit (read 8 continuous 0)
                    if RsRx = '0' then
                        if sample_count = 6 then
                            state <= 2;
                            skip_count <= 0;
                            bit_count <= 0;
                        else
                            sample_count <= sample_count+1;
                        end if;
                    end if;
                elsif state = 2 then                                    -- read 8 bits of data from approx middle of the bit
                    if skip_count = 15 then
                        skip_count <= 0;
                        bits(bit_count) <= RsRx;                        -- store the bit in bits variable
                        if bit_count = 7 then                           -- all bits read 
                            state <= 3;
                        else
                            bit_count <= bit_count+1;
                        end if;
                    else
                        skip_count <= skip_count+1;
                    end if;
                elsif state = 3 then                                    -- read stop bit from middle
                    if skip_count = 15 then
                        if RsRx = '1' then                              --if 1 then good, display data
                            enable <= '1';
                            swstore <= bits;
                            received <= '1';                            -- used to tell trasmitter to transmit current byte 
                            state <= 0;
                            rx_full <= '1';
                        else                                            -- if 0 then some error, synchronise
                            enable <= '0';
                            state <= 4;
                        end if;
                    else
                        skip_count <= skip_count+1;
                    end if;
                end if;
            end if;
        end if;
    end process;


end Behavioral;



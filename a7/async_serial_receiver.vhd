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
        seg : out STD_LOGIC_VECTOR(6 downto 0); 
        an : out STD_LOGIC_VECTOR(3 downto 0) := "1111"
    );
end async_serial_receiver;

architecture Behavioral of async_serial_receiver is

signal state : natural range 0 to 5 := 5;
-- 0 : idle state (trying to detetct start bit)
-- 1 : sampling start bit
-- 2 : read 8 bits of data
-- 3 : read stop bit (if 1 then go to state 0, else to state 4)
-- 4 : synchronising gtkterm and code in fpga (by detecting 8 continuous bits)
-- 5 : waiting for user to press reset button to synchronise
signal rclk : STD_LOGIC := '0';
signal r_counter : natural range 0 to 325 := 325;
signal sample_count : natural range 0 to 6;
signal skip_count : natural range 0 to 160;
signal bits : STD_LOGIC_VECTOR(7 downto 0);
signal bit_count : natural range 0 to 7;
signal set : STD_LOGIC := '0';
signal enable : STD_LOGIC := '0';
signal s : STD_LOGIC_VECTOR(3 downto 0);
signal swstore : STD_LOGIC_VECTOR(7 downto 0);
signal clk_counter : natural range 0 to 65000 := 0;
signal counter : natural range 0 to 1 := 0;

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
            
            -- anode switch rate for perception of vision
            if clk_counter = 65000 then
                clk_counter <= 0;
                if counter = 1 then
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;
            else
                clk_counter <= clk_counter + 1;
            end if;
            
            -- reset button
            if btnC = '1' then
                if state = 5 then
                    set <= '1';
                end if;
            end if;
            
        end if;
    end process;
    
    process(rclk) is
    begin
        if rising_edge(rclk) then
            if state = 4 then                                -- synchronise
                if RsRx = '1' then
                    if skip_count = 160 then                 -- wait for 10 continuous 1 bytes as there will be no start bit
                        skip_count <= 0;
                        state <= 0;
                    else
                        skip_count <= skip_count+1;
                    end if;
                else
                    skip_count <= 0;
                end if;
            elsif state = 0 then                             -- idle state (means it would be getting 1 from rsrx)
                if RsRx = '0' then                           -- wait for start bit (0)
                    state <= 1;
                    sample_count <= 0;
                end if;
            elsif state = 1 then                             -- sample the start bit (read 8 continuous 0)
                if RsRx = '0' then
                    if sample_count = 6 then
                        state <= 2;
                        skip_count <= 0;
                        bit_count <= 0;
                    else
                        sample_count <= sample_count+1;
                    end if;
                end if;
            elsif state = 2 then                              -- read 8 bits of data from approx middle of the bit
                if skip_count = 15 then
                    skip_count <= 0;
                    bits(bit_count) <= RsRx;                  -- store the bit in bits variable
                    if bit_count = 7 then                     -- all bits read
                        state <= 3;
                    else
                        bit_count <= bit_count+1;
                    end if;
                else
                    skip_count <= skip_count+1;
                end if;
            elsif state = 3 then                               -- read stop bit from middle
                if skip_count = 15 then
                    if RsRx = '1' then                         --if 1 then good, display data
                        enable <= '1'; 
                        swstore <= bits;
                        state <= 0;
                    else                                       -- if 0 then some error, synchronise
                        enable <= '0';
                        state <= 4;
                    end if;
                else
                    skip_count <= skip_count+1;
                end if;
            else
                if set = '1' then
                    state <= 4;
                end if;
            end if;
        end if;
    end process;
    
    -- select 4 bits out of 8 to display in corresponding segemnt
    process(counter, enable) is
    begin
        case counter is
            when 0 => s <= swstore(3 downto 0);
            when 1 => s <= swstore(7 downto 4);
            when others => s <= "1111";
        end case;
    end process;
    
    -- select anode to display data based on counter change (counter based on perception vision set under to clk_counter)
    process(counter, enable) is
    begin
        if enable = '1' then
            case counter is
                when 0 => an <= "1110";
                when 1 => an <= "1101";
                when others => an <= "1111";
            end case;
        else
            an <= "1111";
        end if;
    end process;
    
    -- 4 bits to segment 
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

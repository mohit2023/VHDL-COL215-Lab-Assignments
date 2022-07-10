----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/27/2022 07:10:16 PM
-- Design Name: 
-- Module Name: timing - Behavioral
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

entity timing is
    Port ( 
        signal clk: in STD_LOGIC;
        signal pb0: in STD_LOGIC;
        signal pb1: in STD_LOGIC;
        signal rx_full: in STD_LOGIC;
        signal tx_empty: in STD_LOGIC;
        signal s: in STD_LOGIC_VECTOR(7 downto 0);
        signal received: in STD_LOGIC;
        signal swstore: in STD_LOGIC_VECTOR(7 downto 0);
        signal enable: in STD_LOGIC;
        signal transmit: out STD_LOGIC := '0';
        signal addr: out STD_LOGIC_VECTOR(3 downto 0);
        signal s_send: out STD_LOGIC_VECTOR(7 downto 0);
        signal we: out STD_LOGIC_VECTOR(0 to 0) := "0";
        signal anode_enable: out STD_LOGIC
    );
end timing;

architecture Behavioral of timing is

signal tx_start: STD_LOGIC := '0';
signal transmit_addr : natural range 0 to 16:= 0;
signal receive_addr : natural range 0 to 16:= 0;
signal read : natural range 0 to 3 := 0;

signal idle: STD_LOGIC := '1';
signal done: STD_LOGIC := '0';           -- 1 when receiver and transmission both done completely (need to press reset button to do something now)

begin

    process(clk) is
    begin
        if rising_edge(clk) then
            
            if pb0 = '1' then                 -- reset
                tx_start <= '0';
                we <= "0";
                transmit_addr <= 0;
                receive_addr <= 0;
                read <= 0;
                idle <= '1';
                done <= '0';
                anode_enable <= '0';
            else
            
                if pb1='1' and rx_full = '1' then  -- transmission start but only if not receiving anything
                    tx_start <= '1';
                    we <= "0";
                end if;
                
                if done = '0' then
                    if tx_start='1' then         -- transmission logic inside it
                        if receive_addr /= 0 then   --no transmission if no data recieved
                            if transmit_addr = receive_addr and read=0 and tx_empty='0' then    --to end transmission
                                tx_start <= '0';
                                idle <= '1';
                                transmit <= '0';
                                done <= '1';
                            else
                                if tx_empty = '1' and idle='1' and read=0 then  --transmit data one by one from bram
                                    transmit <= '0';
                                    we <= "0";
                                    read <= 1;
                                    addr <= std_logic_vector(to_unsigned(transmit_addr, addr'length));
                                    transmit_addr <= transmit_addr+1;
                                elsif read /= 0 and read /= 3 then  --read delay of bram
                                    read <= read+1;
                                elsif read = 3 then     --read from bram is done
                                    s_send <= s;
                                    anode_enable <= '1';
                                    read <= 0;
                                    transmit <= '1';
                                    idle <= '0';
                                end if;
                                if tx_empty = '0' then  --transmission has started
                                    idle <= '1';
                                end if;
                            end if;
                        else
                            tx_start <= '0';
                            done <= '1';
                        end if;
                    else
                        -- receiver
                        if received = '1' then      --recieved some data -> store it in bram
                            if idle = '1' then      -- not stored it alreay
                                if receive_addr /= 16 then        -- check if bram is not full
                                    we <= "1";
                                    addr <= std_logic_vector(to_unsigned(receive_addr, addr'length));
                                    receive_addr <= receive_addr+1;
                                    idle <= '0';
                                    s_send <= swstore;
                                    anode_enable <= enable;
                                end if;
                            else
                                we <= "0";              -- writ enable to be 1 for only 1 clk cycle
                            end if;
                        else
                            idle <= '1';
                        end if;
                    end if;
                else
                    if receive_addr = 0 then
                        anode_enable <= '0';
                    end if;  
                end if;
            end if;
        end if;
    end process;


end Behavioral;

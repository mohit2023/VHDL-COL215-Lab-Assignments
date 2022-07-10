----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2022 02:22:04 PM
-- Design Name: 
-- Module Name: fifo - Behavioral
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

entity fifo is
    Port ( 
        clk: in STD_LOGIC;
        btnL: in STD_LOGIC;
        btnR: in STD_LOGIC;
        sw: in STD_LOGIC_VECTOR(7 downto 0) ;
        seg: out STD_LOGIC_VECTOR(6 downto 0);
        an: out STD_LOGIC_VECTOR(3 downto 0)
    );
end fifo;

architecture Behavioral of fifo is

signal head: natural range 0 to 15 := 0;
signal tail: natural range 0 to 15 := 0;
signal addr: STD_LOGIC_VECTOR(3 downto 0);
signal s: STD_LOGIC_VECTOR(7 downto 0);
signal en: STD_LOGIC := '1';
signal we: STD_LOGIC_VECTOR(0 to 0) := "0";
signal enable: STD_LOGIC := '0';
signal push: STD_LOGIC;
signal pull: STD_LOGIC;
signal s_save: STD_LOGIC_VECTOR(7 downto 0);
signal read: natural range 0 to 3 := 0;
signal full: STD_LOGIC := '0';

begin
    
    -- connect to bram for storage
    bram:
    ENTITY WORK.bram_wrapper
    Port Map (
        BRAM_PORTA_addr(3 downto 0) => addr(3 downto 0),
        BRAM_PORTA_clk => clk, 
        BRAM_PORTA_din(7 downto 0) => sw(7 downto 0),
        BRAM_PORTA_dout(7 downto 0) => s(7 downto 0),
        BRAM_PORTA_en => en,
        BRAM_PORTA_we(0) => we(0)
    );
    
    -- connect to display: show popped data on seven segment display
    display:
    ENTITY WORK.display
    Port Map (
        enable => enable,
        sw_in => s_save,
        clk => clk,
        seg => seg,
        an => an
    );
    
    --  debounce left button for push signal
    debounceL:
    ENTITY WORK.debounce
    Port Map (
        clk => clk,
        btn => btnL,
        res => push
    );
    
    -- debounce right button for pop signal
    debounceR:
    ENTITY WORK.debounce
    Port Map (
        clk => clk,
        btn => btnR,
        res => pull
    );
    
    
    -- fifo logic
    process(clk) is
    begin
        if rising_edge(clk) then
        
            if push = '1' and read=0 then
                -- write switch to fifo buffer
                -- condition to check full buffer
                if full='1' then
                    enable <= '0';
                else  -- space present in buffer
                    if tail+1=head or (tail=15 and head=0) then  -- if last space then it will be full after this push
                        full <= '1';
                    end if;
                    addr <= std_logic_vector(to_unsigned(tail, addr'length));   -- push at tail
                    if tail=15 then                       -- handle circluar buffer
                        tail <= 0;
                    else
                        tail <= tail+1;
                    end if;
                    we <= "1";
                end if;
            elsif pull = '1' then
                -- read from fifo buffer to display
                we <= "0";
                if tail=head and full = '0' then       -- -- empty buffer condition
                    enable <= '0';
                else
                    addr <= std_logic_vector(to_unsigned(head, addr'length)); -- pull from tail
                    if head=15 then                     -- handle circular buffer
                        head <= 0;
                    else
                        head <= head+1;
                    end if;
                    read <= 1;
                    full <= '0';          -- always not full when something is popped
                end if;
            elsif read /= 0 and read /= 3 then       -- wait for read to be completed from bram
                we <= "0";
                read <= read + 1;
            elsif read=3 then                      -- read complete so display data through s_save
                we <= "0";
                read <= 0;
                s_save <= s;
                enable <= '1';
            else
                we <= "0";
            end if;
        end if;
    end process;

end Behavioral;

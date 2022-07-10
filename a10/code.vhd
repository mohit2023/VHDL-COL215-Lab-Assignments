----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/19/2022 10:22:03 PM
-- Design Name: 
-- Module Name: code - Behavioral
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

entity code is
    Port (
        clk : in STD_LOGIC;
        btnU: in STD_LOGIC;
        btnD: in STD_LOGIC;
        RsRx: in STD_LOGIC;
        RsTx: out STD_LOGIC;
        seg : out STD_LOGIC_VECTOR(6 downto 0); 
        an : out STD_LOGIC_VECTOR(3 downto 0)
  );
end code;

architecture Behavioral of code is

signal pb0 : STD_LOGIC;
signal pb1 : STD_LOGIC;

signal swstore : STD_LOGIC_VECTOR(7 downto 0);
signal enable: STD_LOGIC;
signal anode_enable: STD_LOGIC;
signal received: STD_LOGIC;
signal rx_full: STD_LOGIC;

signal s_send : STD_LOGIC_VECTOR(7 downto 0);
signal transmit : STD_LOGIC;
signal tx_empty : STD_LOGIC;

signal addr: STD_LOGIC_VECTOR(3 downto 0);
signal s: STD_LOGIC_VECTOR(7 downto 0);
signal en: STD_LOGIC := '1';
signal we: STD_LOGIC_VECTOR(0 to 0);

begin
    
    -- debounce for push button 1: transmit
    debounceU:
    ENTITY WORK.debounce
    PORT Map (
        clk => clk,
        btn => btnU,
        res => pb1
    );
    
    -- debounce for push button 0: reset
    debounceD:
    ENTITY WORK.debounce
    PORT Map (
        clk => clk,
        btn => btnD,
        res => pb0
    );

    -- connect to receiver
    receiver:
    ENTITY WORK.async_serial_receiver
    Port Map (
        clk => clk, 
        btnC => pb0, 
        RsRx => RsRx, 
        swstore => swstore, 
        enable => enable,
        received => received,
        rx_full => rx_full
    );
    
    -- connect to transmitter
    transmitter:
    ENTITY WORK.transmitter
    Port Map (
        clk => clk, 
        transmit => transmit,
        swstore => s_send, 
        RsTx => RsTx,
        tx_empty => tx_empty
    );
    
    -- connect to block memory generated
    bram:
    ENTITY WORK.bram_wrapper
    Port Map (
        BRAM_PORTA_addr(3 downto 0) => addr(3 downto 0),
        BRAM_PORTA_clk => clk, 
        BRAM_PORTA_din(7 downto 0) => swstore(7 downto 0),
        BRAM_PORTA_dout(7 downto 0) => s(7 downto 0),
        BRAM_PORTA_en => en,
        BRAM_PORTA_we(0) => we(0)
    );
    
    -- connect to timing circuit
    timing:
    ENTITY WORK.timing
    Port Map (
        clk => clk,
        pb0 => pb0,
        pb1 => pb1,
        rx_full => rx_full,
        tx_empty => tx_empty,
        s => s,
        received => received,
        swstore => swstore,
        transmit => transmit,
        addr => addr,
        s_send => s_send,
        we => we,
        enable => enable,
        anode_enable => anode_enable
    );
    
    -- connect to display : debuging purpose
    display:
    ENTITY WORK.display
    Port Map (
        enable => anode_enable,
        sw_in => s_send,
        clk => clk,
        seg => seg,
        an => an
    );

end Behavioral;

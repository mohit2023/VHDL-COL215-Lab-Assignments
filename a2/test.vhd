----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2022 07:35:16 AM
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
    Port ( sw : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal sw_in: STD_LOGIC_VECTOR (3 downto 0); 
signal seg_out: STD_LOGIC_VECTOR (6 downto 0);
signal an_out: STD_LOGIC_VECTOR (3 downto 0);

begin
    -- Connect DUT
    DUT: bch_to_display port map(sw_in, seg_out, an_out);
    
    process
    begin
        sw_in <= "0000";
        wait for 50 ns;
        assert(seg_out="1000000" and an_out="1110") 
        report "Fail 0000" severity error;
        
        sw_in <= "0001";
        wait for 50 ns;
        assert(seg_out="1111001" and an_out="1110") 
        report "Fail 0001" severity error;
        
        sw_in <= "0010";
        wait for 50 ns;
        assert(seg_out="0100100" and an_out="1110") 
        report "Fail 0010" severity error;
        
        sw_in <= "0011";
        wait for 50 ns;
        assert(seg_out="0110000" and an_out="1110") 
        report "Fail 0011" severity error;
        
        sw_in <= "0100";
        wait for 50 ns;
        assert(seg_out="0011001" and an_out="1110") 
        report "Fail 0100" severity error;
                
        sw_in <= "0101";
        wait for 50 ns;
        assert(seg_out="0010010" and an_out="1110") 
        report "Fail 0101" severity error;
                        
        sw_in <= "0110";
        wait for 50 ns;
        assert(seg_out="0000010" and an_out="1110") 
        report "Fail 0110" severity error;

        sw_in <= "0111";
        wait for 50 ns;
        assert(seg_out="1111000" and an_out="1110") 
        report "Fail 0111" severity error;
        
        sw_in <= "1000";
        wait for 50 ns;
        assert(seg_out="0000000" and an_out="1110") 
        report "Fail 1000" severity error;
        
        sw_in <= "1001";
        wait for 50 ns;
        assert(seg_out="0010000" and an_out="1110") 
        report "Fail 1001" severity error;
        
        sw_in <= "1010";
        wait for 50 ns;
        assert(seg_out="0001000" and an_out="1110") 
        report "Fail 1010" severity error;
                
        sw_in <= "1011";
        wait for 50 ns;
        assert(seg_out="0000011" and an_out="1110") 
        report "Fail 1011" severity error;
                        
        sw_in <= "1100";
        wait for 50 ns;
        assert(seg_out="1000110" and an_out="1110") 
        report "Fail 1100" severity error;

        sw_in <= "1101";
        wait for 50 ns;
        assert(seg_out="0100001" and an_out="1110") 
        report "Fail 1101" severity error;
        
        sw_in <= "1110";
        wait for 50 ns;
        assert(seg_out="0000110" and an_out="1110") 
        report "Fail 1110" severity error;
        
        sw_in <= "1111";
        wait for 50 ns;
        assert(seg_out="0001110" and an_out="1110") 
        report "Fail 1111" severity error;
                
        -- Clear inputs
        sw_in <= "0000";
    
        assert false report "Test done." severity note;
        wait;
    end process;

end tb;

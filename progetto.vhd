library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity project_reti_logiche is      
    port (         
        i_clk : in std_logic;         
        i_rst : in std_logic;         
        i_start : in std_logic;         
        i_add : in std_logic_vector(15 downto 0);   
        o_k : out std_logic_vector(9 downto 0);

        o_done : out std_logic;

        o_mem_addr : in std_logic_vector(15 downto 0);   
        i_mem_data : out std_logic_vector (7 downto 0);
        o_mem_data : out std_logic_vector (7 downto 0);
        o_mem_en : out std_logic;
        o_mem_we : out std_logic
    );
end project_reti_logiche;



architecture Behavioral of project_reti_logiche is
-- segnali vari
type S is(RESET, START, DONE);
signal state : S;

begin

    fsm: process (i_clk, i_rst)
    begin
        
    end process;


end architecture;















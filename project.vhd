library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity project_reti_logiche is      
    port (
        i_clk : in std_logic;                              -- Segnale di clock in ingresso
        i_rst : in std_logic;                              -- Segnale di reset in ingresso
        i_start : in std_logic;                            -- Segnale di start in ingresso
        i_add : in std_logic_vector(15 downto 0);          -- Segnale in ingresso contentente il dato ADD
        i_k : in std_logic_vector(9 downto 0);            -- Segnale in ingresso contentente il dato K
        o_done : out std_logic;                            -- Segnale in uscita che comunica il termine dell'elaborazione
        
        o_mem_addr : out std_logic_vector(15 downto 0);     -- Segnale in uscita alla memoria contentente l'indirizzo da leggere/scrivere
        i_mem_data : in std_logic_vector (7 downto 0);    -- Segnale in ingresso dalla memoria contentente il dato letto
        o_mem_data : out std_logic_vector (7 downto 0);    -- Segnale in uscita alla memoria contentente il dato da scrivere
        o_mem_en : out std_logic;                          -- Segnale in uscita che abilita la comunicazione con la memoria
        o_mem_we : out std_logic                           -- Segnale in uscita che abilita la scrittura sulla memoria
    );
end project_reti_logiche;



architecture Behavioral of project_reti_logiche is
-- segnali vari
type S is(RESET, START, DONE);
signal state : S;

begin

    fsm: process (i_clk, i_rst)
    begin
        if i_rst = '1' or state = RESET then
            o_done <= '0';
            o_mem_en <= '0';
            o_mem_we <= '0';
        elsif i_clk'event and i_clk = '1' then
            case state is
                when START =>
                    null;
            
                when others =>
                    state <= reset;
            end case;
        
        end if;
    end process;


end architecture;















library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_reti_logiche is
    port (
        i_clk : in std_logic;                              -- Segnale di clock in ingresso
        i_rst : in std_logic;                              -- Segnale di reset in ingresso
        i_start : in std_logic;                            -- Segnale di start in ingresso
        i_add : in std_logic_vector(15 downto 0);          -- Segnale in ingresso contentente il dato ADD
        i_k : in std_logic_vector(9 downto 0);             -- Segnale in ingresso contentente il dato K
        o_done : out std_logic;                            -- Segnale in uscita che comunica il termine dell'elaborazione
        
        o_mem_addr : out std_logic_vector(15 downto 0);    -- Segnale in uscita alla memoria contentente l'indirizzo da leggere/scrivere
        i_mem_data : in std_logic_vector(7 downto 0);      -- Segnale in ingresso dalla memoria contentente il dato letto
        o_mem_data : out std_logic_vector(7 downto 0);     -- Segnale in uscita alla memoria contentente il dato da scrivere
        o_mem_en : out std_logic;                          -- Segnale in uscita che abilita la comunicazione con la memoria
        o_mem_we : out std_logic                           -- Segnale in uscita che abilita la scrittura sulla memoria
    );
end project_reti_logiche;



architecture Behavioral of project_reti_logiche is
-- segnali vari
type state_type is(RESET, INIT, READW, WRITEW, CONF, DONE);
signal state : state_type;
signal waiting : std_logic;
signal addr : std_logic_vector(15 downto 0);
signal prec : std_logic_vector(7 downto 0);
signal count : std_logic_vector(7 downto 0);

begin

    fsm: process (i_clk, i_rst)
    begin
        if i_rst = '1' or state = RESET then
            o_done <= '0';
            o_mem_en <= '0';
            o_mem_we <= '0';
            prec <= (others => '0');
            count <= "00011111";
        elsif i_clk'event and i_clk = '1' then
            case state is
                when INIT =>
                    if i_start = '1' then
                        addr <= std_logic_vector(unsigned(i_add) + 1);
                        o_mem_addr <= i_add;
                        o_mem_en <= '1';
                        waiting <= '1';
                        state <= WRITEW;
                    else
                        state <= INIT;
                    end if;
                when READW =>
                    if unsigned(addr) < unsigned(i_add) + 2 * unsigned(i_k) then
                        o_mem_we <= '0';
                        o_mem_addr <= addr;
                        waiting <= '1';
                        state <= WRITEW;
                    else
                        o_mem_we <= '0';
                        o_mem_en <= '0';
                        o_done <= '1';
                        state <= DONE;
                    end if;
                when WRITEW =>
                    null;
                when CONF =>
                    o_mem_we <= '1';
                    o_mem_addr <= addr;
                    o_mem_data <= count;
                    addr <= std_logic_vector(unsigned(addr) + 1);
                    waiting <= '1';
                    state <= READW;
                when DONE =>
                    if i_start <= '0' then
                        o_done <= '0';
                        prec <= (others => '0');
                        count <= "00011111";
                        state <= INIT;
                    else
                        state <= DONE;
                    end if;
                when others =>
                    state <= RESET;
            end case;
        
        end if;
    end process;


end architecture;















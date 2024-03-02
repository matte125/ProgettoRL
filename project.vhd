library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_reti_logiche is
  port
  (
    i_clk   : in std_logic; -- Segnale di clock in ingresso
    i_rst   : in std_logic; -- Segnale di reset in ingresso
    i_start : in std_logic; -- Segnale di start in ingresso
    i_add   : in std_logic_vector(15 downto 0); -- Segnale in ingresso contentente il dato ADD
    i_k     : in std_logic_vector(9 downto 0); -- Segnale in ingresso contentente il dato K
    o_done  : out std_logic; -- Segnale in uscita che comunica il termine dell'elaborazione

    o_mem_addr : out std_logic_vector(15 downto 0); -- Segnale in uscita alla memoria contentente l'indirizzo da leggere/scrivere
    i_mem_data : in std_logic_vector(7 downto 0); -- Segnale in ingresso dalla memoria contentente il dato letto
    o_mem_data : out std_logic_vector(7 downto 0); -- Segnale in uscita alla memoria contentente il dato da scrivere
    o_mem_en   : out std_logic; -- Segnale in uscita che abilita la comunicazione con la memoria
    o_mem_we   : out std_logic -- Segnale in uscita che abilita la scrittura sulla memoria
  );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
    -- segnali vari
    type state_type is(RESET, INIT, READW, WRITEW, CONF, DONE);
    signal state   : state_type;
    signal waiting : std_logic; -- Segnale che viene posto a 1 per aspettare il prossimo fronte di salita del clock
    signal addr    : std_logic_vector(15 downto 0); -- Segnale utilizzato per incrementare l'indirizzo da dare in output alla memoria
    signal prec    : std_logic_vector(7 downto 0); -- Segnale che contiene l'ultima parola valida letta dalla memoria (diversa da 0)
    signal count   : std_logic_vector(7 downto 0); -- Segnale che contiene il valore di credibilità

begin

    fsm : process (i_clk, i_rst)
    begin
        if i_rst = '1' or state = RESET then
            o_done   <= '0';
            o_mem_en <= '0';
            o_mem_we <= '0';
            prec     <= (others => '0');
            count    <= "00011111";
            state <= INIT;
        elsif i_clk'event and i_clk = '1' then
            if waiting = '1' then
                waiting <= '0';
            else
                case state is
                    when INIT =>
                        if i_start = '1' then
                            if unsigned(i_k) = 0 then
                                o_done <= '1';
                                state <= DONE;
                            else
                                addr       <= std_logic_vector(unsigned(i_add));
                                o_mem_addr <= i_add;
                                o_mem_en   <= '1';
                                waiting    <= '1';
                                state      <= WRITEW;
                            end if;
                        else
                            state <= INIT;
                        end if;


                    when READW =>
                        if unsigned(addr) < unsigned(i_add) + 2 * unsigned(i_k) then
                            o_mem_we   <= '0';
                            o_mem_addr <= addr;
                            waiting    <= '1';
                            state      <= WRITEW;
                        else
                            o_mem_we <= '0';
                            o_mem_en <= '0';
                            o_done   <= '1';
                            state    <= DONE;
                        end if;

                    when WRITEW =>
                        if i_mem_data = "00000000" then
                            if prec = "00000000" then
                                addr       <= std_logic_vector(unsigned(addr) + 2);
                                o_mem_addr <= std_logic_vector(unsigned(addr) + 2);
                                state      <= READW;
                            else
                                o_mem_data <= prec;
                                o_mem_we   <= '1';
                                waiting    <= '1';
                                o_mem_addr <= addr;
                                addr       <= std_logic_vector(unsigned(addr) + 1);
                                if unsigned(count) > 0 then
                                    count <= std_logic_vector(unsigned(count) - 1);
                                end if;
                                state      <= CONF;
                            end if;
                        else
                            prec  <= i_mem_data;
                            count <= "00011111";
                            state <= CONF;
                            addr  <= std_logic_vector(unsigned(addr) + 1);
                        end if;

                    when CONF =>
                        o_mem_we   <= '1';
                        o_mem_addr <= addr;
                        o_mem_data <= count;
                        addr       <= std_logic_vector(unsigned(addr) + 1);
                        waiting    <= '1';
                        state      <= READW;

                    when DONE =>
                        if i_start <= '0' then
                            o_done     <= '0';
                            prec       <= (others => '0');
                            count      <= "00011111";
                            state      <= INIT;
                        else
                            state <= DONE;
                        end if;

                    when others =>
                        state <= RESET;
                end case;
            end if;
        end if;
    end process;
end architecture;
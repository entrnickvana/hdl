
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_complex.all;
use ieee.float_pkg.all;
use ieee.fixed_pkg.all;
use std.textio.all;

entity mac_tb is

end entity mac_tb;

architecture behav of mac_tb is
  
  signal sim_clk  :  std_logic;
  signal sim_rst  :  std_logic;
  signal sim_x_re :  u_sfixed(0 downto -15);
  signal sim_x_im :  u_sfixed(0 downto -15);
  signal sim_y_re :  u_sfixed(0 downto -15);
  signal sim_y_im :  u_sfixed(0 downto -15);
  signal sim_s_re :  u_sfixed(0 downto -15);
  signal sim_s_im :  u_sfixed(0 downto -15);
  
  begin
  
    dut : entity work.mac(behav)
    port map(
      clk  => sim_clk, 
      rst  => sim_rst, 
      x_re => sim_x_re,
      x_im => sim_x_im,
      y_re => sim_y_re,
      y_im => sim_y_im,
      s_re => sim_s_re,
      s_im => sim_s_im
      );

  clk_stimulus : process
    constant T_sim : time := 10 ns;
    constant num_clk_cycles : integer := 100000;
  begin
    for ii in 1 to num_clk_cycles loop
      sim_clk <= '0';
      wait for T_sim/2;
      sim_clk <= '1';
      wait for T_sim/2;      
    end loop;

  end process clk_stimulus;
  
  stimulus : process
    variable xxx    : complex := (0.0,0.0);
    variable yyy    : complex := (0.0,0.0);
    variable result : complex := (0.0,0.0);
  begin
    sim_rst <= '1';
    wait for 100 ns;
    
    sim_rst <= '0';
    sim_x_re <= to_sfixed(0.1, sim_x_re'high, sim_x_re'low);
    sim_x_im <= to_sfixed(0.0, sim_x_re'high, sim_x_re'low);
    sim_y_re <= to_sfixed(0.1, sim_x_re'high, sim_x_re'low);
    sim_y_im <= to_sfixed(0.0, sim_x_re'high, sim_x_re'low);
    wait for 22 ns;

    xxx := (0.1, 0.0);
    yyy := (0.1, 0.0);
    result := xxx*yyy;

    sim_x_re <= to_sfixed(0.0, sim_x_re'high, sim_x_re'low);
    sim_x_im <= to_sfixed(0.1, sim_x_re'high, sim_x_re'low);
    sim_y_re <= to_sfixed(0.0, sim_x_re'high, sim_x_re'low);
    sim_y_im <= to_sfixed(0.1, sim_x_re'high, sim_x_re'low);
    wait for 10 ns;

    sim_x_re <= to_sfixed(0.1, sim_x_re'high, sim_x_re'low);
    sim_x_im <= to_sfixed(0.0, sim_x_re'high, sim_x_re'low);
    sim_y_re <= to_sfixed(0.0, sim_x_re'high, sim_x_re'low);
    sim_y_im <= to_sfixed(0.1, sim_x_re'high, sim_x_re'low);
    wait for 10 ns;

    sim_x_re <= to_sfixed(0.0, sim_x_re'high, sim_x_re'low);
    sim_x_im <= to_sfixed(0.1, sim_x_re'high, sim_x_re'low);
    sim_y_re <= to_sfixed(0.1, sim_x_re'high, sim_x_re'low);
    sim_y_im <= to_sfixed(0.0, sim_x_re'high, sim_x_re'low);
    wait for 10 ns;
    
    --sim_x_re <= to_sfixed(real(xxx), sim_x_re'high, sim_x_re'low);
    --sim_x_im <= to_sfixed(real(xxx), sim_x_re'high, sim_x_re'low);
    --sim_y_re <= to_sfixed(real(yyy), sim_x_re'high, sim_x_re'low);
    --sim_y_im <= to_sfixed(real(yyy), sim_x_re'high, sim_x_re'low);
    
  end process stimulus;

end architecture behav;

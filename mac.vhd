
library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use ieee.math_complex.all;

entity mac is
  port(
    clk : in std_logic;
    rst : in std_logic;
    x_re : in  u_sfixed(0 downto -15);
    x_im : in  u_sfixed(0 downto -15);
    y_re : in  u_sfixed(0 downto -15);
    y_im : in  u_sfixed(0 downto -15);
    s_re : out u_sfixed(0 downto -15);
    s_im : out u_sfixed(0 downto -15)
    );
end entity mac;

architecture behav of mac is
  signal re_prod1 : u_sfixed(1 downto -30);
  signal re_prod2 : u_sfixed(1 downto -30);
  signal im_prod1 : u_sfixed(1 downto -30);
  signal im_prod2 : u_sfixed(1 downto -30);
  signal re_sum   : u_sfixed(2 downto -30)
  signal im_sum   : u_sfixed(2 downto -30);
  
begin

  complex_mult : process(clk) is
  begin
    if (rst = '1') then
      re_prod1 <= (others => '0');
      re_prod2 <= (others => '0');
      im_prod1 <= (others => '0');
      im_prod2 <= (others => '0');
    elsif rising_edge(clk) then
      
      --Calculate products
      re_prod1 <= x_re*y_re;
      re_prod2 <= x_im*y_im; --negative real
      im_prod1 <= x_re*y_im;
      im_prod2 <= x_im*y_re;

      --Sum registered products for real and imag parts
      re_sum <= re_prod1 - re_prod2;
      im_sum <= im_prod1 + im_prod2;

    end if;
      
  end process complex_mult;

  s_re <= re_sum(0 downto -15);
  s_im <= im_sum(0 downto -15);  

end architecture behav;
  


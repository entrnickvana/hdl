
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
  signal re_prod1 : u_sfixed(3 downto -15);
  signal re_prod2 : u_sfixed(3 downto -15);
  signal im_prod1 : u_sfixed(3 downto -15);
  signal im_prod2 : u_sfixed(3 downto -15);
  
begin
  

end architecture behav;
  



library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use ieee.numeric_std.all;
use ieee.math_complex.all;


entity mac_top is
  port(
  	clk : in std_logic;
  	rst : in std_logic;  	
    a_re : in u_sfixed(0 downto -15);
    a_im : in u_sfixed(0 downto -15);
    b_re : in u_sfixed(0 downto -15);    
    b_im : in u_sfixed(0 downto -15);        
    s_re : out u_sfixed(0 downto -15);
    s_im : out u_sfixed(0 downto -15)        
  	);
end entity mac_top;

architecture behav of mac_top is

  --Components
  component mac is
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
  end component mac;


  type conv_array is array(0 to 31) of u_sfixed(0 downto -15);
  type prod_array is array(0 to 31) of u_sfixed(0 downto -15);  
  signal a_arr_re : conv_array := (others => (others => '0'));
  signal a_arr_im : conv_array := (others => (others => '0')); 
  signal b_arr_re : conv_array := (others => (others => '0'));    
  signal b_arr_im : conv_array := (others => (others => '0')); 

  signal s_arr_re : prod_array := (others => (others => '0'));   
  signal s_arr_im : prod_array := (others => (others => '0'));

  type sum_array_16 is array(0 to 3) of u_sfixed(1 downto -15);  
  signal s16_re : sum_array_16 := (others => (others => '0'));
  signal s16_im : sum_array_16 := (others => (others => '0'));  
  signal s8_re : sum_array_16 := (others => (others => '0'));  
  signal s8_im : sum_array_16 := (others => (others => '0'));    
  signal s_out_re : u_sfixed(0 downto -15) := (others => '0');      
  signal s_out_im : u_sfixed(0 downto -15) := (others => '0');        

begin

  gen_cmult : for ii in 0 to 31 generate
    cmult_0 : mac
      port map(
      	clk => clk,
      	rst => rst,
      	x_re => a_arr_re(ii),
      	x_im => a_arr_im(ii),      	
      	y_re => b_arr_re(ii),
      	y_im => b_arr_im(ii),      	
        s_re => s_arr_re(ii),
        s_im => s_arr_im(ii)        
      	);

  end generate gen_cmult;

  conv : process(clk) is
  begin
    if (rst = '1') then
      a_arr_re <= (others => (others => '0'));
      a_arr_im <= (others => (others => '0'));      
      b_arr_re <= (others => (others => '0'));      
      b_arr_im <= (others => (others => '0'));            
    elsif rising_edge(clk) then

      a_arr_re(0) <= a_re;
      a_arr_im(0) <= a_im;      
      b_arr_re(0) <= b_re;
      b_arr_im(0) <= b_im;      

      for ii in 0 to 7 loop
        s16_re(ii) <= s_arr_re(ii) + s_arr_re(ii + 8) + s_arr_re(ii + 16) + s_arr_re(ii + 24);
        s16_im(ii) <= s_arr_im(ii) + s_arr_im(ii + 8) + s_arr_im(ii + 16) + s_arr_im(ii + 24);        
      end loop;

      for ii in 0 to 1 loop
        s8_re(ii) <= s16_re(ii) + s16_re(ii + 2) + s16_re(ii + 4) + s16_re(ii + 6);
        s8_im(ii) <= s16_im(ii) + s16_im(ii + 2) + s16_im(ii + 4) + s16_im(ii + 6);        
      end loop;

      s_out_re <= s8_re(0) + s8_re(1);
      s_out_im <= s8_im(0) + s8_im(1);      

      s_re <= s8_re(0) + s8_re(1);
      s_im <= s8_im(0) + s8_im(1);      

    end if;

  end process conv;
	
end architecture behav;

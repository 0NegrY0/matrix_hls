-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity matrix_tb is
end;

architecture bench of matrix_tb is

  component matrix
      Port ( clk : in STD_LOGIC;
             rst : in STD_LOGIC;
             matrixA : in STD_LOGIC_VECTOR (31 downto 0);
             matrixB : in STD_LOGIC_VECTOR (31 downto 0);
             matrixC : in STD_LOGIC_VECTOR (31 downto 0);
             matrixD : in STD_LOGIC_VECTOR (31 downto 0);
             matrixF : out STD_LOGIC_VECTOR (63 downto 0));
  end component;

  signal clk: STD_LOGIC;
  signal rst: STD_LOGIC;
  signal matrixA: STD_LOGIC_VECTOR (31 downto 0);
  signal matrixB: STD_LOGIC_VECTOR (31 downto 0);
  signal matrixC: STD_LOGIC_VECTOR (31 downto 0);
  signal matrixD: STD_LOGIC_VECTOR (31 downto 0);
  signal matrixF: STD_LOGIC_VECTOR (63 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: matrix port map ( clk     => clk,
                         rst     => rst,
                         matrixA => matrixA,
                         matrixB => matrixB,
                         matrixC => matrixC,
                         matrixD => matrixD,
                         matrixF => matrixF );

  stimulus: process
  begin
  
    -- Put initialisation code here

    wait for 100 ns;
    rst <= '1';
    wait for 20 ns;
    rst <= '0';

    -- Put test bench stimulus code here
  
    --Teste normal  
--    matrixA <= "00000010000001010000001100000111";        --2 5 3 7
--    matrixB <= "00000001000000100000010000000110";        --1 2 4 6
--    matrixC <= "00001000000001000000000100000010";        --8 4 1 2
--    matrixD <= "00001001000001000000010100000111";        --9 4 5 7                     --matrixF <="0000000001110010000000000101111000000000001100100000000001000010"      -- 114 94 50 66
  
    --Teste com 2 zeros
--    matrixA <= "00010100000101010000111101000001";          --20 21 15 65
--    matrixB <= "00111010001010010000010100000011";          --58 41 5 3
--    matrixC <= "00000111000010000000000100001010";          --7 8 1 10
--    matrixD <= "00000111000010000000010100000011";          --7 8 4 3                     --matrixF <="0000000000000000000000111100001100000000000000000000001101010000"        --0 963 0 848  (1346 963 1242 848)

    --Teste com 4 zeros  
    matrixA <= "00010100000101010000111101000001";          --20 21 15 65
    matrixB <= "00111010001010010000010100000011";          --58 41 5 3
    matrixC <= "00011100001011010001100000001010";          --28 45 24 10
    matrixD <= "00001111000110000001000100011100";          --15 24 17 28                   --matrixF <= (others => '0')        -- 0 0 0 0 (2450 2815 1725 1666)
    
    wait for 100 * clock_period; 

    
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;

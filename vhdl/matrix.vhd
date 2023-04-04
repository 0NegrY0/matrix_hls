----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2023 08:50:58
-- Design Name: 
-- Module Name: matrix - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity matrix is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           matrixA : in STD_LOGIC_VECTOR (31 downto 0);
           matrixB : in STD_LOGIC_VECTOR (31 downto 0);
           matrixC : in STD_LOGIC_VECTOR (31 downto 0);
           matrixD : in STD_LOGIC_VECTOR (31 downto 0);
           matrixF : out STD_LOGIC_VECTOR (63 downto 0));
end matrix;

architecture Behavioral of matrix is

    signal matA_B : STD_LOGIC_VECTOR(63 downto 0);
    signal matC_D : STD_LOGIC_VECTOR(63 downto 0);
    signal mat_ADD : STD_LOGIC_VECTOR(63 downto 0);
    
    type state is (err,s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
    signal CE_1, NE_1 : state;


begin

    FSM:process(clk, rst)
    begin
        if(rst = '1') then
            CE_1 <= s0;
        elsif(rising_edge(clk)) then
            CE_1 <= NE_1;
        end if;
    end process;
    
    
    mat:process(clk,rst)
    begin
        case CE_1 is
            when s0 =>
                matA_B(7 downto 0) <= std_logic_vector((unsigned(matrixA(7 downto 0)) * unsigned(matrixB(7 downto 0))) + (unsigned(matrixA(15 downto 8)) * unsigned(matrixB(23 downto 16))));
                matC_D(7 downto 0) <= std_logic_vector((unsigned(matrixC(7 downto 0)) * unsigned(matrixD(7 downto 0))) + (unsigned(matrixC(15 downto 8)) * unsigned(matrixD(23 downto 16))));
                NE_1 <= s1;
            when s1 =>
                matA_B(15 downto 8) <= std_logic_vector((unsigned(matrixA(7 downto 0)) * unsigned(matrixB(15 downto 8))) + (unsigned(matrixA(15 downto 8)) * unsigned(matrixB(32 downto 24))));
                matC_D(15 downto 8) <= std_logic_vector((unsigned(matrixC(7 downto 0)) * unsigned(matrixD(15 downto 8))) + (unsigned(matrixC(15 downto 8)) * unsigned(matrixB(32 downto 24))));
                NE_1 <= s2;
            when s2 =>
                matA_B(23 downto 16) <= std_logic_vector((unsigned(matrixA(23 downto 16)) * unsigned(matrixB(7 downto 0))) + (unsigned(matrixA(32 downto 24)) * unsigned(matrixB(23 downto 16))));
                matC_D(23 downto 16) <= std_logic_vector((unsigned(matrixC(23 downto 16)) * unsigned(matrixD(7 downto 0))) + (unsigned(matrixC(32 downto 24)) * unsigned(matrixD(23 downto 16))));
                NE_1 <= s3;
            when s3 =>
                matA_B(32 downto 24) <= std_logic_vector((unsigned(matrixA(23 downto 16)) * unsigned(matrixB(15 downto 8))) + (unsigned(matrixA(32 downto 24)) * unsigned(matrixB(32 downto 24))));
                matC_D(32 downto 24) <= std_logic_vector((unsigned(matrixC(23 downto 16)) * unsigned(matrixD(15 downto 8))) + (unsigned(matrixC(32 downto 24)) * unsigned(matrixD(32 downto 24))));
                NE_1 <= s4;
            when s4 =>
                mat_ADD(7 downto 0) <= std_logic_vector(unsigned(matA_B(7 downto 0)) + unsigned(matC_D(7 downto 0))); 
                NE_1 <= s5;
            when s5 =>
                mat_ADD(15 downto 8) <= std_logic_vector(unsigned(matA_B(15 downto 8)) + unsigned(matC_D(15 downto 8)));
                NE_1 <= s6;
            when s6 =>
                mat_ADD(23 downto 16) <= std_logic_vector(unsigned(matA_B(23 downto 16)) + unsigned(matC_D(23 downto 16)));
                NE_1 <= s7;
            when s7 =>
                mat_ADD(32 downto 24) <= std_logic_vector(unsigned(matA_B(32 downto 24)) + unsigned(matC_D(32 downto 24)));
                NE_1 <= s8;
            when s8 =>
                if(mat_ADD(7 downto 0) >= "0000010000011010") then          --mair ou igual a 1050
                    matrixF(7 downto 0) <= (others => '0');
                else
                    matrixF(7 downto 0) <= mat_ADD(7 downto 0);
                end if;
                NE_1 <= s9;
            when s9 =>
                if(mat_ADD(15 downto 8) >= "0000010000011010") then          --mair ou igual a 1050
                    matrixF(15 downto 8) <= (others => '0');
                else
                    matrixF(15 downto 8) <= mat_ADD(15 downto 8);
                end if;
                NE_1 <= s10;
            when s10 =>
                if(mat_ADD(23 downto 16) >= "0000010000011010") then          --mair ou igual a 1050
                    matrixF(23 downto 16) <= (others => '0');
                else
                    matrixF(23 downto 16) <= mat_ADD(23 downto 16);
                end if;
                NE_1 <= s11;
            when s11 =>    
                if(mat_ADD(32 downto 24) >= "0000010000011010") then          --mair ou igual a 1050
                    matrixF(32 downto 24) <= (others => '0');
                else
                    matrixF(32 downto 24) <= mat_ADD(32 downto 24);
                end if;
                NE_1 <= s12;
            when s12 =>
                NE_1 <= s12;                 
            when others =>
                NE_1 <= err;
        end case;
    end process;

end Behavioral;

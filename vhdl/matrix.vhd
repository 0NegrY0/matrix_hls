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

    --PO---------------------------------------------------------------------------
    signal saidaMuxA : std_logic_vector(63 downto 0);
    signal selMuxA : std_logic_vector (1 downto 0);
    signal saidaMuxB : std_logic_vector(63 downto 0);
    signal selMuxB : std_logic_vector (1 downto 0);
    signal saidaMuxSoma : std_logic_vector(63 downto 0);
    signal selMuxSoma : std_logic;




    signal selULA : std_logic_vector(3 downto 0);
    signal saidaULA : std_logic_vector (63 downto 0);

    signal reg_Res1 : std_logic_vector (63 downto 0);
    signal reg_Res2 : std_logic_vector (63 downto 0);
    signal reg1 : std_logic_vector (63 downto 0);
    signal reg2 : std_logic_vector (63 downto 0);
    signal regsoma : std_logic_vector (63 downto 0);
    signal regfim : std_logic_vector (63 downto 0);

    signal carga1, carga2, carga3, carga4 : std_logic;

    
    signal saidaRegSoma : std_logic_vector (63 downto 0);




begin

    mux4x1A: process(selMuxA, saidaMuxA, matrixA, matrixC, reg_res1)
    begin
        case selMuxA is
            when "00" =>
                saidaMuxA <= matrixA;
            when "01" =>
                saidaMuxA <= matrixC;
            when "10" =>
                saidaMuxA <= reg_res1;
            when others =>
                saidaMuxA <= (others => '0');
        end case;
    end process;
    
    mux4x1B: process(selMuxB, saidaMuxB, matrixB, matrixD, reg_res2)
    begin
        case selMuxB is
            when "00" =>
                saidaMuxB <= matrixB;
            when "01" =>
                saidaMuxB <= matrixD;
            when "10" =>
                saidaMuxB <= reg_res2;
            when others =>
                saidaMuxB <= (others => '0');
        end case;
    end process;
       
    muxSoma: process (selMuxSoma, saidaRegSoma, saidaMuxA, saidaMuxSoma)
    begin 
        case selMuxSoma is
            when '0' =>
                saidaMuxSoma <= saidaMuxA;
            when '1' =>
                saidaMuxSoma <= saidaRegSoma;
            when others =>
                saidaMuxSoma <= (others => '0');
        end case;
    end process;
    
    ULA: process (saidaMuxSoma, saidaMuxB, selULA, saidaULA)
    begin
        case selULA is
            when "0000" =>                  --multiplicação de matrix 8bits
                saidaULA(7 downto 0) <= std_logic_vector((unsigned(saidaMuxSoma(7 downto 0)) * unsigned(saidaMuxB(7 downto 0))) + (unsigned(saidaMuxSoma(15 downto 8)) * unsigned(saidaMuxB(23 downto 16))));
                saidaULA(15 downto 8) <= std_logic_vector((unsigned(saidaMuxSoma(7 downto 0)) * unsigned(saidaMuxB(15 downto 8))) + (unsigned(saidaMuxSoma(15 downto 8)) * unsigned(saidaMuxB(32 downto 24))));
                saidaULA(23 downto 16) <= std_logic_vector((unsigned(saidaMuxSoma(23 downto 16)) * unsigned(saidaMuxB(7 downto 0))) + (unsigned(saidaMuxSoma(32 downto 24)) * unsigned(saidaMuxB(23 downto 16))));
                saidaULA(32 downto 24) <= std_logic_vector((unsigned(saidaMuxSoma(23 downto 16)) * unsigned(saidaMuxB(15 downto 8))) + (unsigned(saidaMuxSoma(32 downto 24)) * unsigned(saidaMuxB(32 downto 24))));
            
            when "0001" =>                  --soma matrix 16bits    
                saidaULA(7 downto 0) <= std_logic_vector(unsigned(saidaMuxSoma(7 downto 0)) + unsigned(saidaMuxB(7 downto 0))); 
                saidaULA(15 downto 8) <= std_logic_vector(unsigned(saidaMuxSoma(15 downto 8)) + unsigned(saidaMuxB(15 downto 8)));
                saidaULA(23 downto 16) <= std_logic_vector(unsigned(saidaMuxSoma(23 downto 16)) + unsigned(saidaMuxB(23 downto 16)));
                saidaULA(32 downto 24) <= std_logic_vector(unsigned(saidaMuxSoma(32 downto 24)) + unsigned(saidaMuxB(32 downto 24)));
            
            when "0010" =>                   --teste matrix 16bits
                if(saidaMuxSoma(7 downto 0) >= "0000010000011010") then          --mair ou igual a 1050
                    matrixF(7 downto 0) <= (others => '0');
                else
                    matrixF(7 downto 0) <= saidaMuxSoma(7 downto 0);
                end if;                    
                
                if(saidaMuxSoma(15 downto 8) >= "0000010000011010") then          --mair ou igual a 1050
                    saidaULA(15 downto 8) <= (others => '0');
                else
                    saidaULA(15 downto 8) <= saidaMuxSoma(15 downto 8);
                end if;
                
                if(saidaMuxSoma(23 downto 16) >= "0000010000011010") then          --mair ou igual a 1050
                    saidaULA(23 downto 16) <= (others => '0');
                else
                    saidaULA(23 downto 16) <= saidaMuxSoma(23 downto 16);
                end if;
                
                if(saidaMuxSoma(32 downto 24) >= "0000010000011010") then          --mair ou igual a 1050
                    saidaULA(32 downto 24) <= (others => '0');
                else
                    saidaULA(32 downto 24) <= saidaMuxSoma(32 downto 24);
                end if;

            when others =>
                saidaULA <= (others => '0');
        end case;
            
    end process;
        
        
    regres1: process(clk, rst)
    begin
        if rst = '1' then
            reg1 <= (others => '0');
        elsif (rising_edge(clk)) then
            if(carga1 = '1') then
                reg1 <= saidaULA;
            end if;
        end if;
    end process;
    reg_Res1 <= reg1;
    
    
    regres2: process(clk, rst)
    begin
        if rst = '1' then
            reg2 <= (others => '0');
        elsif (rising_edge(clk)) then
            if(carga2 = '1') then
                reg2 <= saidaULA;
            end if;
        end if;
    end process;
    reg_Res2 <= reg2;

    regres3: process(clk, rst)
    begin
        if rst = '1' then
            reg1 <= (others => '0');
        elsif (rising_edge(clk)) then
            if(carga3 = '1') then
                regsoma <= saidaULA;
            end if;
        end if;
    end process;
    reg_Res <= regsoma;

    regres4: process(clk, rst)
    begin
        if rst = '1' then
            reg1 <= (others => '0');
        elsif (rising_edge(clk)) then
            if(carga1 = '1') then
                reg1 <= saidaULA;
            end if;
        end if;
    end process;
    reg_Res1 <= reg1;






------------------------------------------------------------------------------------------
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

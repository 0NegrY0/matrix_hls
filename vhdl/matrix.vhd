----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Carlos Negri
-- 
-- Create Date: 11.04.2023 17:04:21
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

--Variaveis Parte Operativa***********************************************************************

--Registradores de entrada
signal regA : std_logic_vector(31 downto 0);
signal regAsaida : std_logic_vector(31 downto 0);
signal cargaA : std_logic;
signal regB : std_logic_vector(31 downto 0);
signal regBsaida : std_logic_vector(31 downto 0);
signal cargaB : std_logic;
signal regC : std_logic_vector(31 downto 0);
signal regCsaida : std_logic_vector(31 downto 0);
signal cargaC : std_logic;
signal regD : std_logic_vector(31 downto 0);
signal regDsaida : std_logic_vector(31 downto 0);
signal cargaD : std_logic;

--multiplexadores 1
signal saida1MuxAB : std_logic_vector(63 downto 0);
signal saida2MuxAB : std_logic_vector(63 downto 0);
signal saida1MuxCD : std_logic_vector(63 downto 0);
signal saida2MuxCD : std_logic_vector(63 downto 0);

--somadores
signal saidaSomador1 : std_logic_vector(63 downto 0);
signal saidaSomador2 : std_logic_vector(63 downto 0);
signal saidaSomador3 : std_logic_vector(63 downto 0);


--RegistradoresSoma
signal regSomaAB : std_logic_vector(63 downto 0);
signal regSomaABsaida : std_logic_vector(63 downto 0);
signal cargaSomaAB : std_logic;
signal regSomaCD : std_logic_vector(63 downto 0);
signal regSomaCDsaida : std_logic_vector(63 downto 0);
signal cargaSomaCD : std_logic;
signal regSomaFim : std_logic_vector(63 downto 0);
signal regSomaFimsaida : std_logic_vector(63 downto 0);
signal cargaSomaFim : std_logic;

--Testador
signal saidaTestador : std_logic_vector(63 downto 0);

--RegistradorFinal
signal regFim : std_logic_vector(63 downto 0);
--signal regFimSaida : std_logic_vector(63 downto 0);         --saida diretamente na matrixF
signal cargaFim : std_logic;

--************************************************************************************************


--Variaveis Parte de Controle*********************************************************************

--FSM
type state is (err,s0,s2,s3,s4,s5);
signal CE, NE : state;

--************************************************************************************************

begin


--Parte Operativa*********************************************************************************

--Registradores de entrada------------------------------------------------
regA_op:process(clk, rst)
begin
    if rst = '1' then
        regA <= (others => '0');
    elsif (rising_edge(clk)) then
        if(cargaA = '1') then
            regA <= matrixA;
        end if;
    end if;
end process;
regAsaida <= regA;

regB_op:process(clk, rst)
begin
    if rst = '1' then
        regB <= (others => '0');
    elsif (rising_edge(clk)) then
        if(cargaB = '1') then
            regB <= matrixB;
        end if;
    end if;
end process;
regBsaida <= regB;

regC_op:process(clk, rst)
begin
    if rst = '1' then
        regC <= (others => '0');
    elsif (rising_edge(clk)) then
        if(cargaC = '1') then
            regC <= matrixC;
        end if;
    end if;
end process;
regCsaida <= regC;

regD_op:process(clk, rst)
begin
    if rst = '1' then
        regD <= (others => '0');
    elsif (rising_edge(clk)) then
        if(cargaD = '1') then
            regD <= matrixD;
        end if;
    end if;
end process;
regDsaida <= regD;
--------------------------------------------------------------------------

--------------------------------------------------------------------------
mux1_1:process(regAsaida, regBsaida, saida1MuxAB, saida2MuxCD)
begin
    saida1MuxAB(15 downto 0) <= std_logic_vector((unsigned(regAsaida(7 downto 0)) * unsigned(regBsaida(7 downto 0))));
    saida2MuxAB(15 downto 0) <= std_logic_vector((unsigned(regAsaida(15 downto 8)) * unsigned(regBsaida(23 downto 16))));
    
    saida1MuxAB(31 downto 16) <= std_logic_vector((unsigned(regAsaida(7 downto 0)) * unsigned(regBsaida(15 downto 8))));
    saida2MuxAB(31 downto 16) <= std_logic_vector((unsigned(regAsaida(15 downto 8)) * unsigned(regBsaida(31 downto 24))));
    
    saida1MuxAB(47 downto 32) <= std_logic_vector((unsigned(regAsaida(23 downto 16)) * unsigned(regBsaida(7 downto 0))));
    saida2MuxAB(47 downto 32) <= std_logic_vector((unsigned(regAsaida(31 downto 24)) * unsigned(regBsaida(23 downto 16))));
  
    saida1MuxAB(63 downto 48) <= std_logic_vector((unsigned(regAsaida(23 downto 16)) * unsigned(regBsaida(15 downto 8))));
    saida2MuxAB(63 downto 48) <= std_logic_vector((unsigned(regAsaida(31 downto 24)) * unsigned(regBsaida(31 downto 24))));
end process;   

mux1_2:process(regCsaida, regDsaida, saida1MuxCD, saida2MuxCD)
begin
    saida1MuxCD(15 downto 0) <= std_logic_vector((unsigned(regCsaida(7 downto 0)) * unsigned(regDsaida(7 downto 0))));
    saida2MuxCD(15 downto 0) <= std_logic_vector((unsigned(regCsaida(15 downto 8)) * unsigned(regDsaida(23 downto 16))));
    
    saida1MuxCD(31 downto 16) <= std_logic_vector((unsigned(regCsaida(7 downto 0)) * unsigned(regDsaida(15 downto 8))));
    saida2MuxCD(31 downto 16) <= std_logic_vector((unsigned(regCsaida(15 downto 8)) * unsigned(regDsaida(31 downto 24))));
  
    saida1MuxCD(47 downto 32) <= std_logic_vector((unsigned(regCsaida(23 downto 16)) * unsigned(regDsaida(7 downto 0))));
    saida2MuxCD(47 downto 32) <= std_logic_vector((unsigned(regCsaida(31 downto 24)) * unsigned(regDsaida(23 downto 16))));
  
    saida1MuxCD(63 downto 48) <= std_logic_vector((unsigned(regCsaida(23 downto 16)) * unsigned(regDsaida(15 downto 8))));
    saida2MuxCD(63 downto 48) <= std_logic_vector((unsigned(regCsaida(31 downto 24)) * unsigned(regDsaida(31 downto 24))));
end process;    
--------------------------------------------------------------------------

--------------------------------------------------------------------------
somador1:process(saida1MuxAB, saida2MuxAB, saidaSomador1)
begin
    saidaSomador1(15 downto 0) <= std_logic_vector(unsigned(saida1MuxAB(15 downto 0)) + unsigned(saida2MuxAB(15 downto 0))); 
    saidaSomador1(31 downto 16) <= std_logic_vector(unsigned(saida1MuxAB(31 downto 16)) + unsigned(saida2MuxAB(31 downto 16))); 
    saidaSomador1(47 downto 32) <= std_logic_vector(unsigned(saida1MuxAB(47 downto 32)) + unsigned(saida2MuxAB(47 downto 32))); 
    saidaSomador1(63 downto 48) <= std_logic_vector(unsigned(saida1MuxAB(63 downto 48)) + unsigned(saida2MuxAB(63 downto 48)));
end process;

somador2:process(saida1MuxCD, saida2MuxCD, saidaSomador2)
begin
    saidaSomador2(15 downto 0) <= std_logic_vector(unsigned(saida1MuxCD(15 downto 0)) + unsigned(saida2MuxCD(15 downto 0))); 
    saidaSomador2(31 downto 16) <= std_logic_vector(unsigned(saida1MuxCD(31 downto 16)) + unsigned(saida2MuxCD(31 downto 16))); 
    saidaSomador2(47 downto 32) <= std_logic_vector(unsigned(saida1MuxCD(47 downto 32)) + unsigned(saida2MuxCD(47 downto 32))); 
    saidaSomador2(63 downto 48) <= std_logic_vector(unsigned(saida1MuxCD(63 downto 48)) + unsigned(saida2MuxCD(63 downto 48)));
end process;  
--------------------------------------------------------------------------

--------------------------------------------------------------------------
regSoma1:process(clk, rst)
begin
    if rst = '1' then
        regSomaAB <= (others => '0');
    elsif (rising_edge(clk)) then
        if(cargaSomaAB = '1') then
            regSomaAB <= saidaSomador1;
        end if;
    end if;
end process;
regSomaABsaida <= regSomaAB;

regSoma2:process(clk, rst)
begin
    if rst = '1' then
        regSomaCD <= (others => '0');
    elsif (rising_edge(clk)) then
        if(cargaSomaCD = '1') then
            regSomaCD <= saidaSomador2;
        end if;
    end if;
end process;
regSomaCDsaida <= regSomaCD;
--------------------------------------------------------------------------

--------------------------------------------------------------------------
somador3:process(regSomaABsaida, regSomaCDsaida, saidaSomador3)
begin
    saidaSomador3(15 downto 0) <= std_logic_vector(unsigned(regSomaABsaida(15 downto 0)) + unsigned(regSomaCDsaida(15 downto 0))); 
    saidaSomador3(31 downto 16) <= std_logic_vector(unsigned(regSomaABsaida(31 downto 16)) + unsigned(regSomaCDsaida(31 downto 16))); 
    saidaSomador3(47 downto 32) <= std_logic_vector(unsigned(regSomaABsaida(47 downto 32)) + unsigned(regSomaCDsaida(47 downto 32))); 
    saidaSomador3(63 downto 48) <= std_logic_vector(unsigned(regSomaABsaida(63 downto 48)) + unsigned(regSomaCDsaida(63 downto 48)));
end process;
--------------------------------------------------------------------------

--------------------------------------------------------------------------
regSoma_Fim:process(clk, rst)
begin
    if rst = '1' then
        regSomaFIm <= (others => '0');
    elsif (rising_edge(clk)) then
        if(cargaSomaFim = '1') then
            regSomaFim <= saidaSomador3;
        end if;
    end if;
end process;
regSomaFimsaida <= regSomaFim;
--------------------------------------------------------------------------

--------------------------------------------------------------------------
testador:process(regSomaFimsaida)
begin
    if(regSomaFimsaida(15 downto 0) >= "0000010000011010") then                              --maior ou igual a 1050
        saidaTestador(15 downto 0) <= (others => '0');
    else
        saidaTestador(15 downto 0) <= regSomaFimsaida(15 downto 0);
    end if;
--///////////////////////////
    if(regSomaFimsaida(31 downto 16) >= "0000010000011010") then                              --maior ou igual a 1050
        saidaTestador(31 downto 16) <= (others => '0');
    else
        saidaTestador(31 downto 16) <= regSomaFimsaida(31 downto 16);
    end if;
--///////////////////////////
    if(regSomaFimsaida(47 downto 32) >= "0000010000011010") then                              --maior ou igual a 1050
        saidaTestador(47 downto 32) <= (others => '0');
    else
        saidaTestador(47 downto 32) <= regSomaFimsaida(47 downto 32);
    end if;
--///////////////////////////
    if(regSomaFimsaida(63 downto 48) >= "0000010000011010") then                              --maior ou igual a 1050
        saidaTestador(63 downto 48) <= (others => '0');
    else
        saidaTestador(63 downto 48) <= regSomaFimsaida(63 downto 48);
    end if;
end process;
--------------------------------------------------------------------------


--------------------------------------------------------------------------
reg_final:process(clk, rst)
begin
     if rst = '1' then
        regFIm <= (others => '0');
    elsif (rising_edge(clk)) then
        if(cargaFim = '1') then
            regFim <= saidaTestador;
        end if;
    end if;
end process;
matrixF <= regFim;                                                                          --saida da matrixF
--------------------------------------------------------------------------

--************************************************************************************************

            ---------
            --LIMBO--
            ---------

--Parte de Controle*******************************************************************************

--FSM---------------------------------------------------------------------
FSM:process(clk, rst)
begin
    if(rst = '1') then
        CE <= s0;
    elsif(rising_edge(clk)) then
        CE <= NE;
    end if;
end process;
--------------------------------------------------------------------------

--------------------------------------------------------------------------
control:process(CE, NE, cargaA, cargaB, cargaC, cargaD, cargaSomaAB, cargaSomaCD, cargaSomaFim, cargaFim)
begin
    cargaA <= '0';
    cargaB <= '0';
    cargaC <= '0';
    cargaD <= '0';
    cargaSomaAB <= '0';
    cargaSomaCD <= '0';
    cargaSomaFim <= '0';
    cargaFim <= '0';
    
    case CE is
        when s0 =>
            cargaA <= '1';
            cargaB <= '1';
            cargaC <= '1';
            cargaD <= '1';
            
            NE <= s2;
            
        when s2 =>
            cargaSomaAB <= '1';
            cargaSomaCD <= '1';
            
            NE <= s3;
            
        when s3 =>
            cargaSomaFim <= '1';
            
            NE <= s4;
            
        when s4 =>
            cargaFim <= '1';
            
            NE <= s5;
            
        when s5 =>
            NE <= s5;                       --HALT    
            
        when others =>
            NE <= err;
    end case;
end process;
--------------------------------------------------------------------------

--************************************************************************************************

end Behavioral;

/*******************************************************************************
Vendor: Xilinx 
Associated Filename: matrixmul.cpp
Purpose: Vivado HLS tutorial example 
Device: All 
Revision History: March 1, 2013 - initial release
                                                
*******************************************************************************
Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.

This file contains confidential and proprietary information of Xilinx, Inc. and 
is protected under U.S. and international copyright and other intellectual 
property laws.

DISCLAIMER
This disclaimer is not a license and does not grant any rights to the materials 
distributed herewith. Except as otherwise provided in a valid license issued to 
you by Xilinx, and to the maximum extent permitted by applicable law: 
(1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX 
HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR 
FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether 
in contract or tort, including negligence, or under any other theory of 
liability) for any loss or damage of any kind or nature related to, arising under 
or in connection with these materials, including for any direct, or any indirect, 
special, incidental, or consequential loss or damage (including loss of data, 
profits, goodwill, or any type of loss or damage suffered as a result of any 
action brought by a third party) even if such damage or loss was reasonably 
foreseeable or Xilinx had been advised of the possibility of the same.

CRITICAL APPLICATIONS
Xilinx products are not designed or intended to be fail-safe, or for use in any 
application requiring fail-safe performance, such as life-support or safety 
devices or systems, Class III medical devices, nuclear facilities, applications 
related to the deployment of airbags, or any other applications that could lead 
to death, personal injury, or severe property or environmental damage 
(individually and collectively, "Critical Applications"). Customer asresultes the 
sole risk and liability of any use of Xilinx products in Critical Applications, 
subject only to applicable laws and regulations governing limitations on product 
liability. 

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT 
ALL TIMES.

*******************************************************************************/
#include "matrixmul.h"

void matrixmul(
      mat_a_t a[MAT_A_ROWS][MAT_A_COLS],
      mat_b_t b[MAT_B_ROWS][MAT_B_COLS],
	  mat_c_t c[MAT_C_ROWs][MAT_C_COLS],
	  mat_d_t d[MAT_D_ROWs][MAT_D_COLS],
      result_t res_a_b[MAT_A_ROWS][MAT_B_COLS],
      result_t res_c_d[MAT_C_ROWS][MAT_D_COLS],
	  result_t mf[MAT_A_ROWS][MAT_D_COLS]
)
{
  // Iterate over the rows of the A matrix
   Row: for(int i = 0; i < MAT_A_ROWS; i++) {
      // Iterate over the columns of the B matrix
      Col: for(int j = 0; j < MAT_B_COLS; j++) {
         res_a_b[i][j] = 0;
         // Do the inner product of a row of A and col of B
         Product: for(int k = 0; k < MAT_B_ROWS; k++) {
            res_a_b[i][j] += a[i][k] * b[k][j];
         }
      }
   }
   // Iterate over the rows of the C matrix
   Row: for(int i = 0; i < MAT_C_ROWS; i++) {
         // Iterate over the columns of the D matrix
         Col: for(int j = 0; j < MAT_D_COLS; j++) {
            res_c_d[i][j] = 0;
            // Do the inner product of a row of C and col of D
            Product: for(int k = 0; k < MAT_D_ROWS; k++) {
               res_c_d[i][j] += c[i][k] * d[k][j];
            }
         }
      }

   // Iterate over the rows of the res_a_b matrix
      Row: for(int i = 0; i < MAT_A_ROWS; i++) {
            // Iterate over the columns of the res_c_d matrix
            Col: for(int j = 0; j < MAT_D_COLS; j++) {
               res_add[i][j] = res_a_b[i][j] + res_c_d[i][j];		//SUM
            }
      }

  // Iterate over the rows of the res_a_b matrix
		Row: for(int i = 0; i < MAT_A_ROWS; i++) {
			  // Iterate over the columns of the res_c_d matrix
			  Col: for(int j = 0; j < MAT_D_COLS; j++) {
				  if(res_add[i][j] >= 1050){
					  mf[i][j] = 0;
				  }
				  else{
					  mf[i][j] = res_add[i][j];
				  }
			  }
		}



}


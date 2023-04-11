#include "matrixmul.h"

void matrixmul(
      mat_a_t a[MAT_A_ROWS][MAT_A_COLS],
      mat_b_t b[MAT_B_ROWS][MAT_B_COLS],
	  mat_c_t c[MAT_C_ROWS][MAT_C_COLS],
	  mat_d_t d[MAT_D_ROWS][MAT_D_COLS],

	  result_t mf[MAT_A_ROWS][MAT_D_COLS]
)
{
	result_t res_a_b[MAT_A_ROWS][MAT_B_COLS];
	result_t res_c_d[MAT_C_ROWS][MAT_D_COLS];
	result_t res_add[MAT_A_ROWS][MAT_D_COLS];



  // Iterate over the rows of the A matrix
   Row1: for(int i = 0; i < MAT_A_ROWS; i++) {
      // Iterate over the columns of the B matrix
      Col1: for(int j = 0; j < MAT_B_COLS; j++) {
         res_a_b[i][j] = 0;
         // Do the inner product of a row of A and col of B
         Product1: for(int k = 0; k < MAT_B_ROWS; k++) {
            res_a_b[i][j] += a[i][k] * b[k][j];
         }
      }
   }
   // Iterate over the rows of the C matrix
   Row2: for(int i = 0; i < MAT_C_ROWS; i++) {
         // Iterate over the columns of the D matrix
         Col2: for(int j = 0; j < MAT_D_COLS; j++) {
            res_c_d[i][j] = 0;
            // Do the inner product of a row of C and col of D
            Product2: for(int k = 0; k < MAT_D_ROWS; k++) {
               res_c_d[i][j] += c[i][k] * d[k][j];
            }
         }
      }

   // Iterate over the rows of the res_a_b matrix
      Row3: for(int i = 0; i < MAT_A_ROWS; i++) {
            // Iterate over the columns of the res_c_d matrix
            Col3: for(int j = 0; j < MAT_D_COLS; j++) {
               res_add[i][j] = res_a_b[i][j] + res_c_d[i][j];		//SUM
            }
      }

  // Iterate over the rows of the res_a_b matrix
		Row4: for(int i = 0; i < MAT_A_ROWS; i++) {
			  // Iterate over the columns of the res_c_d matrix
			  Col4: for(int j = 0; j < MAT_D_COLS; j++) {
				  if(res_add[i][j] >= 1050){
					  mf[i][j] = 0;
				  }
				  else{
					  mf[i][j] = res_add[i][j];
				  }
			  }
		}



}

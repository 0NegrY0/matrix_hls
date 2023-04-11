#include <iostream>
#include "matrixmul.h"

using namespace std;

int main(int argc, char **argv)
{
   mat_a_t in_mat_a[2][2] = {
		  {2,5},
		  {3,7}
   };
   mat_b_t in_mat_b[2][2] = {
		   {1,2},
		   {4,6}
   };
   mat_c_t in_mat_c[2][2] = {
		   {8,4},
		   {1,2}
   };
   mat_d_t in_mat_d[2][2] = {
		   {9,4},
		   {5,7}
   };

   mat_a_t mat_error[2][2] = {
		   {0,0},
		   {0,0}
   };


   result_t hw_result[2][2];
   result_t sw_result[2][2], mux1_result[2][2], mux2_result[2][2], add_result[2][2];
   int err_cnt = 0;

   // Generate the expected result

   // Iterate over the rows of the A matrix
   for(int i = 0; i < MAT_A_ROWS; i++) {
      for(int j = 0; j < MAT_B_COLS; j++) {
         // Iterate over the columns of the B matrix
         mux1_result[i][j] = 0;
         // Do the inner product of a row of A and col of B
         for(int k = 0; k < MAT_B_ROWS; k++) {
            mux1_result[i][j] += in_mat_a[i][k] * in_mat_b[k][j];
         }
      }
   }

   // Iterate over the rows of the C matrix
     for(int i = 0; i < MAT_C_ROWS; i++) {
        for(int j = 0; j < MAT_D_COLS; j++) {
           // Iterate over the columns of the D matrix
           mux2_result[i][j] = 0;
           // Do the inner product of a row of C and col of D
           for(int k = 0; k < MAT_D_ROWS; k++) {
              mux2_result[i][j] += in_mat_c[i][k] * in_mat_d[k][j];
           }
        }
     }

   // ADD
     for(int i = 0; i < MAT_A_ROWS; i++){
    	 for(int j = 0; j < MAT_D_COLS; j++){
    		 add_result[i][j] = mux1_result[i][j] + mux2_result[i][j];
    	 }
     }

   //TEST
     for(int i = 0; i < MAT_A_ROWS; i++){
    	 for(int j = 0; j < MAT_D_COLS; j++){
    		if(add_result[i][j] >= 1050){
    			sw_result[i][j] = 0;
    		}
    		else{
    			sw_result[i][j] = add_result[i][j];
    		}
    	 }
     }

   // Compare TB vs HW C-model and/or RTL




   // Run matrix multiply block
   matrixmul(in_mat_a, in_mat_b, in_mat_c, in_mat_d, hw_result);

   //matrixmul(in_mat_a,mat_error, hw_result); //simulate error



   // Compare hw_result with sw_result
   for (int i = 0; i < MAT_A_ROWS; i++) {
      for (int j = 0; j < MAT_B_COLS; j++) {
         // Check HW result against SW
         if (hw_result[i][j] != sw_result[i][j]) {
            err_cnt++;
         }

      }
   }


   if (err_cnt){
	  cout << "\n" << endl;
      cout << ">> ERROR: " << err_cnt << " mismatches detected!" << endl;

      //print matrix error results
      cout << "Matrix results:" << endl;
	  for (int i = 0; i < MAT_A_ROWS; i++) {
		  cout << "\n" << endl;
		  for (int j = 0; j < MAT_B_COLS; j++) {
			 cout << hw_result[i][j] << " ";
		  }
	  }
	 cout << "\n" << endl;

   }
   else{
	  cout << "\n" << endl;
      cout << "Test passes!! \n" << endl;

     //print matrix results
     cout << "Matrix results:" << endl;
   	 for (int i = 0; i < MAT_A_ROWS; i++) {
   		  cout << "\n" << endl;
   		  for (int j = 0; j < MAT_B_COLS; j++) {
   			 cout << hw_result[i][j] << " ";
   		  }
   	   }
   	 cout << "\n" << endl;
   }
 // return err_cnt;
}



#ifndef __MATRIXMUL_H__
#define __MATRIXMUL_H__

#include <cmath>
using namespace std;



#define MAT_A_ROWS 2
#define MAT_A_COLS 2
#define MAT_B_ROWS 2
#define MAT_B_COLS 2
#define MAT_C_ROWS 2
#define MAT_C_COLS 2
#define MAT_D_ROWS 2
#define MAT_D_COLS 2


typedef unsigned char mat_a_t; //8bits
typedef unsigned char mat_b_t; //8bits
typedef unsigned char mat_c_t; //8bits
typedef unsigned char mat_d_t; //8bits
typedef unsigned short result_t; //16bits

// Prototype of top level function for C-synthesis
void matrixmul(
      mat_a_t a[MAT_A_ROWS][MAT_A_COLS],
      mat_b_t b[MAT_B_ROWS][MAT_B_COLS],
      mat_c_t c[MAT_C_ROWS][MAT_C_COLS],
      mat_d_t d[MAT_D_ROWS][MAT_D_COLS],

	  result_t mf[MAT_A_ROWS][MAT_D_COLS]);

#endif

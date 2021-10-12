// You can parametrize the size or the type of the outputs
// Valid types are 'int8','uint8','int16','uint16','int32','uint32' ...
// 'double','single','half','boolean','x_sfix<n1>_En<n2>','x_ufix<n1>_En<n2>
// Note the usage of workspace variable in the block mask
// for specifying values of template parameters

#include <stdint.h>

template <int M, int N, typename OUT_TYPE>
void func4_b(int16_t in, OUT_TYPE out1[M], OUT_TYPE out2[M][N] )
{
   // Function body
}



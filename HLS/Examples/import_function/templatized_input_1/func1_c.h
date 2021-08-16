// To define accepted datatypes for the variables using
// SUPPORTED_TYPES Pragma


#pragma XMC INPORT x
#pragma XMC INPORT y
#pragma XMC SUPPORTED_TYPES T: int8, int16, int32, double, single, half
template <class T>
T func1_c(T x, T y)
{
   return (x > y) ? x : y;
}



// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
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



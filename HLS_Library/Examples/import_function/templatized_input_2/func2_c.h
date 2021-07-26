// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
// To define datatypes that are not supported for the variables using
// UNSUPPORTED_TYPES pragma

#pragma XMC UNSUPPORTED_TYPES T: boolean
#pragma XMC INPORT x, y
template <typename T>
T func2_c(T x, T y)
{
   return (x < y) ? x : y;
}



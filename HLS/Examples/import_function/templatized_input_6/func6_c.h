// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
// This example shows how model composer supports template specializatin
 
#pragma XMC INPORT x,y
template <typename T>
T func6_c(T x , T y) {
	return (x < y) ? x : y;
}

template <>
bool func6_c<bool>(bool x, bool y) {
	return (x & y);
}


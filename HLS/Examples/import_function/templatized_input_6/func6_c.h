// This example shows how model composer supports template specialization
 
#pragma XMC INPORT x,y
template <typename T>
T func6_c(T x , T y) {
	return (x < y) ? x : y;
}

template <>
int func6_c<int>(int x, int y) {
	return (x * y);
}


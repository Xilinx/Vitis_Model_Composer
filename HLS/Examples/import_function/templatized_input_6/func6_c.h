///////////////////////////////////////////////////////////////////////////
// Copyright 2021 Xilinx
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
///////////////////////////////////////////////////////////////////////////

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


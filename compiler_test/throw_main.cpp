#include <iostream>

using namespace std;

void throw_func( bool th )
{
	if( th ) throw std::runtime_error("generate runtime error");
}

int main()
{
    auto str = string("built std::string");
	cout << "\n\n\thello world :) " << str << " \n\n";

	try
	{
		throw_func( true );
	}
	catch(const std::exception& e)
	{
		std::cerr << "\tcatch exception with reason: " << e.what() << "\n\n\n";
	}
	
	return 0;
}



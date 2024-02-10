// build with:
//
// clang++ -O3 -march=x86-64-v2  packed_integer.cpp
//
// to check 128 integer std::atomic support

#include <iostream>
#include <atomic>

using namespace std;

using int64  = int64_t;
using int128 = unsigned __int128;


template<typename R, typename F, typename S>
    R pack_integers( F first, S second )
{
    // F and S must be integral types
    // the size of the types must be  less or equal the size of E
    // F and S must be of the same sign
    // R must be unsigned
    static_assert( std::is_integral_v<F> && std::is_integral_v<S>,  "pack_integer function can only be called with integer types as arguments" );
    static_assert( sizeof(F) + sizeof(S) <= sizeof(R),              "cannot pack integers: not enough bits" );
    static_assert( std::is_signed_v<F> == std::is_signed_v<S>,      "pack_integers function must be called with arguments with the same (un)signed type" );
    static_assert( std::is_unsigned_v<R>,                           "pack_integers return type must be unsigned");

    if constexpr( std::is_signed_v<S> )
        if ( second < 0 ) throw std::runtime_error("cannot pack integers if the second value is negative");

    return ( (R( first )) << sizeof(R)*4 | R(second) );
}

template<typename F, typename S, typename R>
    std::pair<F, S> unpack_integers( R packed )
{
    // packed integers are stored into R
    // by using half size for the first integer
    // and the rest for the second
    static_assert( std::is_integral_v<F> && std::is_integral_v<S>,  "pack_integer function can only be called with integer types as arguments" );
    static_assert( sizeof(F) + sizeof(S) <= sizeof(R),              "cannot pack integers: not enough bits" );
    static_assert( std::is_signed_v<F> == std::is_signed_v<S>,      "pack_integers function must be called with arguments with the same (un)signed type" );
    static_assert( std::is_unsigned_v<R>,                           "pack_integers return type must be unsigned");

    // to extract the first packed number, the factor 4 cames out in this way:
    // sizeof() returns the number of bytes,
    // then I multiply by 8 to obtain the number of bits (required to be used with >> bit shift operator)
    // and then I divide by to to obtain the half of the bits to execute the bitshift
    auto first  = F ( packed >> ( sizeof(R) * 4 ) );
    auto second = S ( packed );
    return std::pair<F,S>( first, second );
}


int128 pack_whole (int64 first, int64 second)
{
    if (second < 0) throw (false);
    return ((int128 (first)) << 64) | int128 (second);
}

int64 first_of_whole (int128 packed)
{
    return int64 (packed >> 64);
}

int64 second_of_whole (int128 packed)
{
    return int64 (packed);
}

int main (void)
{
    cout << "int64  : " << sizeof (int64) << "bytes" << endl;
    cout << "int128 : " << sizeof (int128) << "bytes" << endl << endl;
    cout << endl;

    pair <int64, int64> ant { 73, 42 };
    
    int128 ibex { pack_whole (ant.first, ant.second) };
    std::atomic<int128> at_ibex{ibex};

    int64   first_diff  { 33 },
            second_diff { 11 };

    cout << "ant  = { " << ant.first << ", " << ant.second << " }"<< endl;
    cout << "ibex = { " << first_of_whole (ibex) << ", " << second_of_whole (ibex) << " }"<< endl;
    cout << endl;

    cout << "ant  diff = { " << first_diff << ", " << second_diff << " }"<< endl;
    
    ant.first   += first_diff;
    ant.second  += second_diff;

    auto diff = pack_whole (first_diff, second_diff);
    // ibex += diff;
    at_ibex.fetch_add(diff);
     
    cout << "ibex diff = { " << first_of_whole (diff) << ", " << second_of_whole (diff) << " }"<< endl;
    cout << endl;
    cout << "ant  = { " << ant.first << ", " << ant.second << " }" << endl;
    cout << "ibex = { " << first_of_whole (ibex) << ", " << second_of_whole (ibex) << " }"<< endl;
    cout << "atomic.ibex = { " << first_of_whole (at_ibex.load()) << ", " << second_of_whole (at_ibex.load()) << " }"<< endl;


    cout << endl << endl;
    int32_t f = 3030;
    int8_t s = 110;
    auto packed = pack_integers<int128>( f, s );
    cout << "\n\tPackIntegers function: [" << f << ", " << int16_t(s) << "] -> [" << uint64_t(packed) << "]\n\n";
    auto [ uf, us ] = unpack_integers<int32_t, int8_t>( packed );
    cout << "\n\tUnpackIntegers function: [" << uf << ", " << int16_t(us) << "]\n\n";

    try
    {
        s = -42;
        packed = pack_integers<int128>( f, s );
        cout << "\n\tnegative check failed: exception not thrown...\n\n";
    }
    catch(const std::exception& e)
    {
        cout << "\n\tnegative check SUCCEDED: std::exception catched...\n\n";
    }
    catch( ... )
    {
        cout << "\n\tnegative check SUCCEDED: generic exception catched...\n\n";
    }
    

    return 0;
    
}


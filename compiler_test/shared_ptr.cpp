#include <iostream>
#include <atomic>
#include <memory>

using namespace std;

class metrics
{
private:
    std::atomic<uint32_t> lat;
public:
    metrics() { cout << "\tmetrics CTOR\n"; lat.store(0); }
    ~metrics() { cout << "\tmetrics DTOR\n"; }
    bool update_lat ( uint32_t delta ) { auto prev = lat.fetch_add(delta); return (prev % 2); }
    uint32_t get_lat () { return lat.load(); }
};

using metrics_shared_ptr = shared_ptr<metrics>;

int main()
{
    auto met_ptr = make_shared<metrics>();
    cout << "after construction, lat is [" << met_ptr->get_lat() << "]\n";

    met_ptr->update_lat(23);
    cout << "after first update, lat is [" << met_ptr->get_lat() << "]\n";

    if( !met_ptr || !met_ptr->update_lat(19))
        cout << "something went wrong: invalid ptr OR odd value [" << met_ptr->get_lat() << "]\n";
    else
        cout << "after second update, lat is [" << met_ptr->get_lat() << "]\n";

    if( !met_ptr || !met_ptr->update_lat(1))
        cout << "OK, ODD VALUE [" << met_ptr->get_lat() << "]\n";
    else
        cout << "ERROR: WE SHOULD GO INTO THE OTHER IF BRANCH\n";

    met_ptr = nullptr;
    if( !met_ptr || !met_ptr->update_lat(1) )
        cout << "OK, pointer correctly reset\n";
    else
        cout << "ERROR: WE SHOULD GO INTO THE OTHER IF BRANCH\n";
    
    return 0;
}



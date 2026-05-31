/// @param unixTime

function HotglueTimeUnixToGameMaker(_unixTime)
{
    return date_inc_second(date_create_datetime(1980, 1, 1, 0, 0, 0), _unixTime - 315532800);
}
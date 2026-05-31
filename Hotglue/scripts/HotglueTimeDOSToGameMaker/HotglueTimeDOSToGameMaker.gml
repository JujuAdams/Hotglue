/// @param dosDate
/// @param dosTime

function HotglueTimeDOSToGameMaker(_dosDate, _dosTime)
{
    var _day   = _dosDate & 31;
    var _month = (_dosDate >> 5) & 15;
    var _year  = ((_dosDate >> 9) & 127) + 1980;
    
    var _second = 2*(_dosTime & 31);
    var _minute = (_dosTime >> 5) & 63;
    var _hour   = (_dosTime >> 11) & 31;
    
    return date_create_datetime(_year, _month, _day, _hour, _minute, _second);
}
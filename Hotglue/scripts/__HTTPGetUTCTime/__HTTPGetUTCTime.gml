// Feather disable all

function __HTTPGetUTCTime()
{
    var _oldTimezone = date_get_timezone();
    date_set_timezone(timezone_utc);
    var _time = date_current_datetime();
    date_set_timezone(_oldTimezone);
    
    return _time;
}
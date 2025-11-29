// Feather disable all

function InterfaceWarning(_string)
{
    var _currentDateTime = date_current_datetime();
    show_debug_message($"{date_datetime_string(_currentDateTime)} Warning! {_string}");
    
    with(oInterface)
    {
        with(warningsTab)
        {
            newWarnings = true;
            array_push(warningArray, {
                time: _currentDateTime,
                text: _string,
            });
        }
    }
}
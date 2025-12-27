// Feather disable all

var _system = __HotglueSystem();

if (_system.__uriTestTimeout < current_time)
{
    __HotglueWarning("URI test timed out");
    _system.__uriTestTimeout = undefined;
}
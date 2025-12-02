// Feather disable all

function LogSetNewWarnings(_state)
{
    static _system = __LogSystem();
    
    _system.__newWarnings = _state;
}
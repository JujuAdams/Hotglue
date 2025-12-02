// Feather disable all

/// @param port

function HotglueSetHTTPCallbackPort(_port)
{
    static _system = __HotglueSystem();
    
    _system.__localhostPort = _port;
}
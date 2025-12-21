// Feather disable all

function HotglueUDPPortIsOpen()
{
    static _system = __HotglueSystem();
    
    return (_system.__udpSocket >= 0);
}
// Feather disable all

function HotglueUDPPortIsOpen()
{
    with(__objHotglue)
    {
        return (__udpSendSocket >= 0);
    }
    
    return false;
}
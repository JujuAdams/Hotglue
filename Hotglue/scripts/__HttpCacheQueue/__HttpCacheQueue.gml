// Feather disable all

/// @param struct

function __HttpCacheQueue(_struct)
{
    static _queueArray = __HttpCacheSystem().__queueArray;
    
    array_push(_queueArray, _struct);
}
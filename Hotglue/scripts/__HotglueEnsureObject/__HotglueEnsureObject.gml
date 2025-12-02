// Feather disable all

function __HotglueEnsureObject()
{
    if (not instance_exists(__objHotglue))
    {
        instance_create_depth(0, 0, 0, __objHotglue);
    }
    
    return __objHotglue.id;
}
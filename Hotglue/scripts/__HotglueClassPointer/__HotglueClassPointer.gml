// Feather disable all

/// @param struct/array
/// @param member

function __HotglueClassPointer(_ds, _member) constructor
{
    if (is_struct(_ds))
    {
        __Get = function()
        {
            return __ds[$ __member];
        }
        
        __Set = function(_value)
        {
            __ds[$ __member] = _value;
        }
    }
    else if (is_array(_ds))
    {
        __Get = function()
        {
            return __ds[__member];
        }
        
        __Set = function(_value)
        {
            __ds[__member] = _value;
        }
    }
    else
    {
        __HotglueError($"Invalid data type ({instanceof(_ds)})");
    }
    
    __ds = _ds;
    __member = _member;
}
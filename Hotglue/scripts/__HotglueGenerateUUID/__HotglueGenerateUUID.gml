// Feather disable all

/// @param [hyphenate=true]

function __HotglueGenerateUUID(_hyphenate = true)
{
    //UUIDv4 as per https://www.cryptosys.net/pki/uuid-rfc4122.html
    
    var _UUID = md5_string_unicode(string(irandom(0xFFFFFFFF)) + string(irandom(0xFFFFFFFF)) + string(irandom(0xFFFFFFFF)) + string(irandom(0xFFFFFFFF)));
    _UUID = string_set_byte_at(_UUID, 13, ord("4"));
    _UUID = string_set_byte_at(_UUID, 17, ord(choose("8", "9", "a", "b")));
    
    if (_hyphenate)
    {
        _UUID = string_copy(_UUID, 1, 8) + "-" + string_copy(_UUID, 9, 4) + "-" + string_copy(_UUID, 13, 4) + "-" + string_copy(_UUID, 17, 4) + "-" + string_copy(_UUID, 21, 12);
    }
    
    return _UUID;
}
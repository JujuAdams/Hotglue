// Feather disable all

function __HotglueEncodeURI(_inURI)
{
    static _inBufferStatic  = buffer_create(1024, buffer_grow, 1);
    static _outBufferStatic = buffer_create(1024, buffer_grow, 1);
    
    static _allowArrayStatic = (function()
    {
        var _array = array_create(256, false);
        
        _array[ord("A")] = true;
        _array[ord("B")] = true;
        _array[ord("C")] = true;
        _array[ord("D")] = true;
        _array[ord("E")] = true;
        _array[ord("F")] = true;
        _array[ord("G")] = true;
        _array[ord("H")] = true;
        _array[ord("I")] = true;
        _array[ord("J")] = true;
        _array[ord("K")] = true;
        _array[ord("L")] = true;
        _array[ord("M")] = true;
        _array[ord("N")] = true;
        _array[ord("O")] = true;
        _array[ord("P")] = true;
        _array[ord("Q")] = true;
        _array[ord("R")] = true;
        _array[ord("S")] = true;
        _array[ord("T")] = true;
        _array[ord("U")] = true;
        _array[ord("V")] = true;
        _array[ord("W")] = true;
        _array[ord("X")] = true;
        _array[ord("Y")] = true;
        _array[ord("Z")] = true;
        
        _array[ord("a")] = true;
        _array[ord("b")] = true;
        _array[ord("c")] = true;
        _array[ord("d")] = true;
        _array[ord("e")] = true;
        _array[ord("f")] = true;
        _array[ord("g")] = true;
        _array[ord("h")] = true;
        _array[ord("i")] = true;
        _array[ord("j")] = true;
        _array[ord("k")] = true;
        _array[ord("l")] = true;
        _array[ord("m")] = true;
        _array[ord("n")] = true;
        _array[ord("o")] = true;
        _array[ord("p")] = true;
        _array[ord("q")] = true;
        _array[ord("r")] = true;
        _array[ord("s")] = true;
        _array[ord("t")] = true;
        _array[ord("u")] = true;
        _array[ord("v")] = true;
        _array[ord("w")] = true;
        _array[ord("x")] = true;
        _array[ord("y")] = true;
        _array[ord("z")] = true;
        
        _array[ord("0")] = true;
        _array[ord("1")] = true;
        _array[ord("2")] = true;
        _array[ord("3")] = true;
        _array[ord("4")] = true;
        _array[ord("5")] = true;
        _array[ord("6")] = true;
        _array[ord("7")] = true;
        _array[ord("8")] = true;
        _array[ord("9")] = true;
        
        _array[ord("-")] = true;
        _array[ord("_")] = true;
        _array[ord(".")] = true;
        _array[ord("!")] = true;
        _array[ord("~")] = true;
        _array[ord("*")] = true;
        _array[ord("'")] = true;
        _array[ord("(")] = true;
        _array[ord(")")] = true;
        
        return _array;
    })();
    
    static _hexArrayStatic = (function()
    {
        var _array = array_create(256);
        
        var _hexLookup = [ord("0"),
                          ord("1"),
                          ord("2"),
                          ord("3"),
                          ord("4"),
                          ord("5"),
                          ord("6"),
                          ord("7"),
                          ord("8"),
                          ord("9"),
                          ord("A"),
                          ord("B"),
                          ord("C"),
                          ord("D"),
                          ord("E"),
                          ord("F")];
        
        var _i = 0;
        repeat(256)
        {
            _array[_i] = (_hexLookup[_i & 0x0f] << 8) | (_hexLookup[_i >> 4]);
            ++_i;
        }
        
        return _array;
    })();
    
    var _inBuffer   = _inBufferStatic;
    var _outBuffer  = _outBufferStatic;
    var _allowArray = _allowArrayStatic;
    var _hexArray   = _hexArrayStatic;
    
    buffer_seek(_inBuffer, buffer_seek_start, 0);
    buffer_write(_inBuffer, buffer_text, _inURI);
    var _length = buffer_tell(_inBuffer);
    
    buffer_seek(_inBuffer, buffer_seek_start, 0);
    buffer_seek(_outBuffer, buffer_seek_start, 0);
    
    repeat(_length)
    {
        var _byte = buffer_read(_inBuffer, buffer_u8);
        if (_allowArray[_byte])
        {
            buffer_write(_outBuffer, buffer_u8, _byte);
        }
        else
        {
            buffer_write(_outBuffer, buffer_u8, ord("%"));
            buffer_write(_outBuffer, buffer_u16, _hexArray[_byte]);
        }
    }
    
    buffer_write(_outBuffer, buffer_u8, 0);
    buffer_seek(_outBuffer, buffer_seek_start, 0);
    
    return buffer_read(_outBuffer, buffer_string);
}
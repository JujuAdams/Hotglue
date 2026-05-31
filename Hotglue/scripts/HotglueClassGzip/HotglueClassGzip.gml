/// @param buffer

function HotglueClassGzip(_buffer) constructor
{
    __data = _buffer;
    
    __Initialize();
    
    try
    {
        var _magic = buffer_read(_buffer, buffer_u16);
        if (_magic != 0x8b1f)
        {
            throw "Failed magic number";
        }
        
        __compressionMethod = buffer_read(_buffer, buffer_u8);
        __flags             = buffer_read(_buffer, buffer_u8);
        __modifiedTime      = HotglueTimeUnixToGameMaker(buffer_read(_buffer, buffer_s32));
        __xFlags            = buffer_read(_buffer, buffer_u8);
        __os                = buffer_read(_buffer, buffer_u8);
        
        __fText = __flags & 0b1;
        
        if (__flags & 0b100)
        {
            __fExtra = buffer_read(_buffer, buffer_u8);
            buffer_seek(_buffer, buffer_seek_relative, __fExtra);
        }
        
        if (__flags & 0b1000)
        {
            __fName = buffer_read(_buffer, buffer_string);
        }
        
        if (__flags & 0b1_0000)
        {
            __fComment = buffer_read(_buffer, buffer_string);
        }
        
        if (__flags & 0b10)
        {
            __fHalfCRC = buffer_read(_buffer, buffer_u16);
        }
        
        __dataOffset = buffer_tell(_buffer);
        buffer_seek(_buffer, buffer_seek_end, 8);
        __compressedSize = buffer_tell(_buffer) - __dataOffset;
        
        __crc = buffer_read(_buffer, buffer_u32);
        __uncompressedSize = buffer_read(_buffer, buffer_u32);
    }
    catch(_error)
    {
        show_debug_message(_error);
        __Initialize();
    }
    
    
    
    
    
    static __Initialize = function()
    {
        __compressionMethod = undefined;
        __flags             = undefined;
        __modifiedTime      = undefined; //Unix time
        __xFlags            = undefined;
        __os                = undefined;
        __fText             = undefined;
        __flags             = undefined;
        __fExtra            = undefined;
        __fName             = undefined;
        __fComment          = undefined;
        __fHalfCRC          = undefined;
        __dataOffset        = undefined;
        __compressedSize    = undefined;
        __crc               = undefined;
        __uncompressedSize  = undefined;
    }
    
    static Destroy = function()
    {
        __Initialize();
        buffer_delete(__data);
    }
    
    static GetFilename = function()
    {
        return __fName;
    }
    
    static Decompress = function(_destDirectory, _filename = __fName)
    {
        _filename ??= "gzipContent";
        
        var _zipSize = 98 + 2 * string_byte_length(_filename) + __compressedSize;
        var _buffer = buffer_create(_zipSize, buffer_fixed, 1);
        
        //Local file header
        buffer_write(_buffer, buffer_u32,  0x4034b50); //Magic number
        buffer_write(_buffer, buffer_u16,  20); //version needed
        buffer_write(_buffer, buffer_u16,  0); //general flag
        buffer_write(_buffer, buffer_u16,  8); //compression method
        buffer_write(_buffer, buffer_u16,  HotglueTimeGameMakerToDOSDate(__modifiedTime)); //mod time
        buffer_write(_buffer, buffer_u16,  HotglueTimeGameMakerToDOSTime(__modifiedTime)); //mod date
        buffer_write(_buffer, buffer_u32,  __crc); //crc
        buffer_write(_buffer, buffer_u32,  __compressedSize); //compressed size
        buffer_write(_buffer, buffer_u32,  __uncompressedSize); //uncompressed size
        buffer_write(_buffer, buffer_u16,  string_byte_length(_filename)); //file name length
        buffer_write(_buffer, buffer_u16,  0); //extra length
        buffer_write(_buffer, buffer_text, _filename); //file name
        
        //Compressed data
        buffer_copy(__data, __dataOffset, __compressedSize, _buffer, buffer_tell(_buffer));
        buffer_seek(_buffer, buffer_seek_relative, __compressedSize);
        
        //Central directory file header
        var _start = buffer_tell(_buffer);
        
        buffer_write(_buffer, buffer_u32,  0x2014b50); //signature
        buffer_write(_buffer, buffer_u16,  (__os << 8) | 63); //OS (15-8) - version made by (7 - 0), 6.3
        buffer_write(_buffer, buffer_u16,  20); //version required 2.0
        buffer_write(_buffer, buffer_u16,  0); //general flag
        buffer_write(_buffer, buffer_u16,  __compressionMethod); //compression method
        buffer_write(_buffer, buffer_u16,  HotglueTimeGameMakerToDOSDate(__modifiedTime)); //mod time
        buffer_write(_buffer, buffer_u16,  HotglueTimeGameMakerToDOSTime(__modifiedTime)); //mod date
        buffer_write(_buffer, buffer_u32,  __crc); //crc
        buffer_write(_buffer, buffer_u32,  __compressedSize); //compressed size
        buffer_write(_buffer, buffer_u32,  __uncompressedSize); //uncompressed size
        buffer_write(_buffer, buffer_u16,  string_byte_length(_filename)); //file name length
        buffer_write(_buffer, buffer_u16,  0); //extra length
        buffer_write(_buffer, buffer_u16,  0); //comment length
        buffer_write(_buffer, buffer_u16,  0); //disk start n
        buffer_write(_buffer, buffer_u16,  0); //internal file attributes
        buffer_write(_buffer, buffer_u32,  0); //external file attributes
        buffer_write(_buffer, buffer_u32,  0); //local file header start
        buffer_write(_buffer, buffer_text, _filename); //zip name
        
        var _size = buffer_tell(_buffer) - _start;
        
        //central directory end
        buffer_write(_buffer, buffer_u32, 0x6054b50); //signature
        buffer_write(_buffer, buffer_u16, 0); //current disk number
        buffer_write(_buffer, buffer_u16, 0); //central dir disk start
        buffer_write(_buffer, buffer_u16, 1); //number of central dir records on disk
        buffer_write(_buffer, buffer_u16, 1); //total number of central dir records
        buffer_write(_buffer, buffer_u32, _size); //size of central dir
        buffer_write(_buffer, buffer_u32, _start); //start of central dir
        buffer_write(_buffer, buffer_u16, 0); //comment length
        
        buffer_save(_buffer, "temp.zip");
        buffer_delete(_buffer);
        zip_unzip("temp.zip", _destDirectory);
        file_delete("temp.zip");
        
        return file_exists(_destDirectory + _filename)? (_destDirectory + _filename) : undefined;
    }
}
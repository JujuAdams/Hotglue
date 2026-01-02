// Feather disable all

/// @param httpResponseCode

function __HTTPResponseIsSuccess(_httpResponseCode)
{
    try
    {
        return (floor(real(_httpResponseCode)/100) == 2);
    }
    catch(_error)
    {
        
    }
    
    return false;
}
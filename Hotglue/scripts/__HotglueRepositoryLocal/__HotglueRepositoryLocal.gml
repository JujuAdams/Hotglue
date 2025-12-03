// Feather disable all

/// @param url

function __HotglueRepositoryLocal(_url) : __HotglueRepositoryCommon(_url) constructor
{
    //Figure out a friendly name for the repository
    __name = filename_name(_url);
    
    
    
    static GetLatestStable = function()
    {
        //TODO - Return the one and only release
        return undefined;
    }
    
    static GetLatestRelease = function()
    {
        //TODO - Return the one and only release
        return undefined;
    }
    
    static GetReleases = function()
    {
        return __releasesArray;
    }
    
    static GetHotglueJSON = function()
    {
        //TODO - Return the file from disk
        return undefined;
    }
}
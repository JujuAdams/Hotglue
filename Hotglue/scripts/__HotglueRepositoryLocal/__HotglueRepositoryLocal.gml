// Feather disable all

/// @param url

function __HotglueRepositoryLocal(_url) : __HotglueRepositoryCommon(_url) constructor
{
    //Figure out a friendly name for the repository
    __name = filename_name(_url);
    
    __release = __HotglueClassReleaseCommon(__name, undefined, _url, _url, "", true);
    __releasesArray[@ 0] = __release;
    
    
       
    static GetLatestStable = function()
    {
        //TODO - Return the one and only release
        return __release;
    }
    
    static GetLatestRelease = function()
    {
        //TODO - Return the one and only release
        return __release;
    }
    
    static GetReleases = function()
    {
        return __releasesArray;
    }
    
    static GetReadme = function()
    {
        //TODO - Return the file from disk
        return undefined;
    }
}
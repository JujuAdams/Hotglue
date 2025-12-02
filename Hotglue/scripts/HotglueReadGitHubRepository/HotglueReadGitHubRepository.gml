// Feather disable all

/// @param url
/// @param [callback]

function HotglueReadGitHubRepository(_url, _callback = undefined)
{
    var _repo = new __HotglueGitHubRepo(_url)
    _repo.GetHotglueJSON();
    _repo.GetReleases();
    _repo.SetFinalCallback(_callback);
    return _repo;
}
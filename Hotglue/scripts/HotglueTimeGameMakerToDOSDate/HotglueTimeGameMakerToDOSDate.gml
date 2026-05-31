/// @param gameMakerTime

function HotglueTimeGameMakerToDOSDate(_gameMakerTime)
{
    return ((date_get_year(_gameMakerTime) - 1980) << 9) | (date_get_month(_gameMakerTime) << 5) | date_get_day(_gameMakerTime);
}
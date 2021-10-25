JCSWeatherKit Architecture
====================

JCSWeatherKit is implemented as a layered architecture.

    +-------------------------------------------------------------+
    |                         JCSWeatherKit                        |
    |        +----------------------------------------------------+
    |        |                  JCSWeatherSession                           |
    |    +--------------------------------------------------------+
    |    | JCSWeatherSource | JCSWeatherRequestInfo | JCSLocationService | 
    +----+-----------------+-----------------+--------------------+
    |       JCSWeatherData        |     JCSWeatherError    |
    +----------------------+-----------------+


### JCSWeatherSession

Provides asynchronous request of getting weather from OpenWeatherAPI. The input weather source needs to be set by the initial method or attribute.

Primary entry points: JCSWeatherSession.h,


### JCSWeatherSource

Provides configuration data, including APPID and base URL where JCSWeatherSession can get weather data from.

Primary entry point: JCSWeatherSource.h


### JCSWeatherRequestInfo

Used for passing parameters to OpenWeatherAPI, such as city id, city name, zip code, and so on.

In the category JCSWeatherRequestInfo+Private, splices URL through parameters.
Primary entry point: JCSWeatherRequestInfo.h


### JCSLocationService

Used for getting user location to fetch weather data.
 
Primary entry point: JCSLocationService.h


### JCSWeatherData

A data container for all weather data. Also provides transforming JSON data to all the weather data.

Primary entry point: JCSWeatherData.h


### JCSWeatherError

Defines errors types and passes control to a supplied function.
It handles the following errors:

* invalid weather source.
* disabled location service.


Primary entry point: JCSWeatherError.h






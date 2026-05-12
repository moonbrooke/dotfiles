#!/bin/bash

# Check for debug flag
DEBUG=0
if [ "$1" == "--debug" ]; then
    DEBUG=1
    shift
fi

# Check if location is provided
if [ -z "$1" ]; then
    echo "Usage: $0 [--debug] [Location]"
    exit 1
fi

if [[ -f ~/.secrets ]]; then
    source ~/.secrets
fi

# Your OpenWeatherMap API key
API_KEY="$OWM_API"

# Function to map weather condition to emoji
weather_to_emoji() {
    case $1 in
        "Clear") echo "☀️ Clear" ;;
        "Clouds") echo "☁️ Cloudy" ;;
        "Mist") echo "🌫️ Mist" ;;
        "Fog") echo "🌫️ Fog" ;;
        "Rain") echo "🌧️ Rain" ;;
        "Snow") echo "❄️ Snow" ;;
        "Drizzle") echo "🌦️ Drizzle" ;;
        "Thunderstorm") echo "⛈️ Thunderstorm" ;;
        *) echo "✨" ;;
    esac
}

# Function to map wind direction in degrees to arrows
wind_to_arrow() {
    local deg=$1
    if [ $deg -ge 0 -a $deg -lt 23 ] || [ $deg -ge 338 ]; then
        echo "→"
    elif [ $deg -ge 23 -a $deg -lt 68 ]; then
        echo "↗"
    elif [ $deg -ge 68 -a $deg -lt 113 ]; then
        echo "↑"
    elif [ $deg -ge 113 -a $deg -lt 158 ]; then
        echo "↖"
    elif [ $deg -ge 158 -a $deg -lt 203 ]; then
        echo "←"
    elif [ $deg -ge 203 -a $deg -lt 248 ]; then
        echo "↙"
    elif [ $deg -ge 248 -a $deg -lt 293 ]; then
        echo "↓"
    else
        echo "↘"
    fi
}

# Get latitude and longitude of the location
location=$(echo "$1" | sed 's/ /%20/g')  # URL-encode spaces
geo_data=$(curl -s "http://api.openweathermap.org/geo/1.0/direct?q=$location&appid=$API_KEY")
[ $DEBUG -eq 1 ] && echo "Geo Data: $geo_data"

lat=$(echo $geo_data | jq -r '.[0].lat')
lon=$(echo $geo_data | jq -r '.[0].lon')
location_name=$(echo $geo_data | jq -r '.[0].name')
country=$(echo $geo_data | jq -r '.[0].country')

# Get current weather data
weather_data=$(curl -s "http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$API_KEY&units=metric")
[ $DEBUG -eq 1 ] && echo "Weather Data: $weather_data"

weather_main=$(echo $weather_data | jq -r '.weather[0].main')
temp=$(echo $weather_data | jq -r '.main.temp')
wind_speed=$(echo $weather_data | jq -r '.wind.speed')
wind_deg=$(echo $weather_data | jq -r '.wind.deg')

# Convert weather condition to emoji
weather_emoji=$(weather_to_emoji "$weather_main")

# Convert wind direction to arrow
wind_arrow=$(wind_to_arrow "$wind_deg")

# Determine temperature sign
if (( $(echo "$temp > 0" | bc -l) )); then
    temp_sign="+"
else
    temp_sign=""
fi

# Print the one-liner
echo "$location_name, $country: $weather_emoji ${temp_sign}${temp}°C 🌬️ ${wind_arrow} ${wind_speed}km/h"


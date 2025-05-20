import holidays
from datetime import date

# Get today's date
today = date.today()

# Define selected countries with ISO codes and holidays objects
country_holidays = {
    "🇨🇳": holidays.China(),
    "🇨🇭": holidays.Switzerland(),
    "🇺🇸": holidays.UnitedStates(),
    "🇯🇵": holidays.Japan(),
    "🇰🇷": holidays.Korea(),
    "🇩🇪": holidays.Germany(),
    "🇮🇹": holidays.Italy(),
    "🇫🇷": holidays.France(),
    "🇬🇧": holidays.UnitedKingdom(),
    "🇷🇺": holidays.Russia(),
}

for code, hdays in country_holidays.items():
    if today in hdays:
        print(f"{code} {hdays[today]}")
        break
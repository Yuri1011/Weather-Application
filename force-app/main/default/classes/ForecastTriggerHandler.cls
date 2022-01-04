public with sharing class ForecastTriggerHandler {
    public static void fillFieldWeatherMessage() {
        Weather_Setting__c settingsWeather = Weather_Setting__c.getOrgDefaults();
        Decimal lowerLimitTemp = settingsWeather.Lower_Limit__c;
        String lowerLimitMessage = settingsWeather.Lower_Limit_Message__c;
        String upperLimitMessage = settingsWeather.Upper_Limit_Message__c;
        Decimal upperLimitTemp = settingsWeather.Upper_Limit__c;
        String normalLevelMessage = settingsWeather.Normal_Level_Message__c;

        List<Forecast__c> forecasts = Trigger.new;

        for (Forecast__c record : forecasts) {
            if (record.Temperature__c < lowerLimitTemp) {
                record.Weather_Message__c = lowerLimitMessage;
            }else if (record.Temperature__c > upperLimitTemp) {
                record.Weather_Message__c = upperLimitMessage;
            }else {
                record.Weather_Message__c = normalLevelMessage;
            }
        }
    }
}

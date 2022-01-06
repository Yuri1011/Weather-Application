public with sharing class FieldFillHelper {
    public static void fillWeatherMessageField() {
        Weather_Setting__c settingsWeather = Weather_Setting__c.getOrgDefaults();

        for (Forecast__c record : (List<Forecast__c>)Trigger.new) {
            if (record.Temperature__c < settingsWeather.Lower_Limit__c) {
                record.Weather_Message__c = settingsWeather.Lower_Limit_Message__c;
            }else if (record.Temperature__c > settingsWeather.Upper_Limit__c) {
                record.Weather_Message__c = settingsWeather.Upper_Limit_Message__c;
            }else {
                record.Weather_Message__c = settingsWeather.Normal_Level_Message__c;
            }
        }
    }
}

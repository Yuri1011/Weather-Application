public with sharing class ForecastTriggerHandler {
    public static void fillFieldWeatherMessage() {
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

    public static void deleteDublicateForecastForCity() {

        Set<Id> idsNewRecordCity = new Set<Id>();
        for (Forecast__c record : (List<Forecast__c>)Trigger.new) {
             idsNewRecordCity.add(record.City__c);
        }

        List<City__c> newRecordsCity = [
            SELECT Id, Name, Country__c 
            FROM City__c 
            WHERE Id IN: idsNewRecordCity];

        List<String> nameAndAbr = new List<String>();
        for (City__c record : newRecordsCity) {
            nameAndAbr.add(record.Name);
            nameAndAbr.add(record.Country__c);
        }

        delete[
            SELECT Id, Name, Country__c
            FROM City__c 
            WHERE Id != :newRecordsCity AND Name IN: nameAndAbr AND Country__c IN: nameAndAbr];
    }
}

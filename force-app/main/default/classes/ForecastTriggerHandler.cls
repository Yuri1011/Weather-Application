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
        List<City__c> oldRecordsCity = [SELECT Id, Name, Country__c FROM City__c];

        Id idNewRecordCity;
        for (Forecast__c record : (List<Forecast__c>)Trigger.new) {
             idNewRecordCity = record.City__c;
        }

        List<City__c> newRecordsCity = [
            SELECT Id, Name, Country__c 
            FROM City__c 
            WHERE Id = :idNewRecordCity];

        List<Id> deleteDublicateRecordsCity = new List<Id>();

        for (City__c record : newRecordsCity) {
            for (City__c variable : oldRecordsCity) {
                if (record.Id != variable.Id && record.Name == variable.Name && record.Country__c == variable.Country__c) {
                    deleteDublicateRecordsCity.add(variable.Id);
                }
            }
        }

        delete[
            SELECT Id 
            FROM City__c 
            WHERE Id IN: deleteDublicateRecordsCity];
    }
}

public with sharing class DublicateHelper {
    public static void deleteDublicate() {
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
            SELECT Id
            FROM City__c 
            WHERE Id NOT IN :newRecordsCity
            AND Name IN: nameAndAbr 
            AND Country__c IN: nameAndAbr];
    }
}

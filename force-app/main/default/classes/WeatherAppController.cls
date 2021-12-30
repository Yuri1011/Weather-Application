public with sharing class WeatherAppController {

    @AuraEnabled (cacheable = true)
    public static Weather_Setting__c getCustomSettingsWeather(){
      return [SELECT Id, Api_Key__c, Forecast_Service_URL__c FROM Weather_Setting__c];
    }

    @AuraEnabled (cacheable = true)
    public static Object getTemperature(String api, String apiKey, String city ) {

      Http http = new Http();
      HttpRequest req = new HttpRequest();
      req.setEndpoint(api + city + '&units=metric' + '&appid=' + apiKey);
      req.setMethod('GET');
      HTTPResponse res = http.send(req);
      JSONParser parser = JSON.createParser(res.getBody());
      return res.getBody();
    }
}

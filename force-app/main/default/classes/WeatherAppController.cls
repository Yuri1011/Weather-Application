public with sharing class WeatherAppController {

  @AuraEnabled (cacheable = true)
  public static void getCustomSettingsWeather(String city){

    List<Weather_Setting__c> settingsWeather = new List<Weather_Setting__c>();
    settingsWeather =  [SELECT Id, Api_Key__c, Forecast_Service_URL__c FROM Weather_Setting__c];
    String api;
    String apiKey;
    for (Weather_Setting__c record : settingsWeather) {
      api = record.Forecast_Service_URL__c;
      apiKey = record.Api_Key__c;
    }
    getForecastWeather(api, apiKey, city);
  }

  @AuraEnabled (cacheable = true)
  public static Object getForecastWeather(String api, String apiKey, String city ) {
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(api + city + '&units=metric' + '&appid=' + apiKey);
    req.setMethod('GET');
    HTTPResponse res = http.send(req);

    Map<String, Object> forecastsMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody()); 
    String jsonCity = JSON.serialize(forecastsMap.get('city'));
    Map<String, Object> cityMap = (Map<String, Object>) JSON.deserializeUntyped(jsonCity);
    String cityName = cityMap.get('name').toString();
    String countryAbr = cityMap.get('country').toString();

    createRecordCity(cityName, countryAbr);
    
    return res.getBody();
  }

  @AuraEnabled
  public static void createRecordCity(String cityName, String countryAbr) {
    City__c recordCity = new City__c();
    recordCity.Name = cityName;
    recordCity.Country__c = countryAbr;

    // System.debug('createRecordCity====>>>' + cityName);
    // insert recordCity;
  }

  @AuraEnabled
  public static void createForecast() {


    // Forecast__c newForecast = new Forecast__c();
    // newForecast.Name = nameForecastCity;
    // newForecast.Date__c = dateForecast;
    // newForecast.Time__c = timeChange;
    // newForecast.Temperature__c = tempForecast;

  }
}

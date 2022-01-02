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
    return res.getBody();
  }

  @AuraEnabled
  public static void createRecordCity(String nameCity, String countryAbr) {
    City__c recordCity = new City__c();
    recordCity.Name = nameCity;
    recordCity.Country__c = countryAbr;

    // insert recordCity;
  }

  @AuraEnabled
  public static Forecast__c createForecast(String nameForecastCity, Date dateForecast, String timeForecast, Decimal tempForecast) {

    // String[] strTimeSplit = timeForecast.split(':');
    List<String> strTimeSplit = new List<String>();
    strTimeSplit = timeForecast.split(':');
    Time timeChange = Time.newInstance(Integer.valueOf(strTimeSplit[0]), Integer.valueOf(strTimeSplit[1]), Integer.valueOf(strTimeSplit[2]), 0);

    Forecast__c newForecast = new Forecast__c();
    newForecast.Name = nameForecastCity;
    newForecast.Date__c = dateForecast;
    newForecast.Time__c = timeChange;
    newForecast.Temperature__c = tempForecast;

    return newForecast;

  }

  // public static void createRecordForecast() {
  //   List<Forecast__c> listForecasts = new List<Forecast__c>();
  //   listForecasts.add(newForecast);

  //   // insert recordCity;
  // }
}

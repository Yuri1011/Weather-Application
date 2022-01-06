public with sharing class WeatherAppController {
  static String METRIC = '&units=metric';
  static String APPID = '&appid=';
  static String QUERY_METHOD = 'GET';

  @AuraEnabled
  public static WeatherWrapper getData(String city) {
    try {
      Weather_Setting__c settingsWeather = Weather_Setting__c.getOrgDefaults();
      doApiCall(city, settingsWeather);
      WeatherWrapper forecastWeather = prepareWrapper(city, settingsWeather);

      return forecastWeather;

    } catch (Exception e) {
      String errorMsg = e.getMessage();
      throw new AuraHandledException(errorMsg);
    }
  }

  public static String doApiCall(String city, Weather_Setting__c settingsWeather) {
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(settingsWeather.Forecast_Service_URL__c + city + METRIC + APPID + settingsWeather.Api_Key__c);
    req.setMethod(QUERY_METHOD);
    HTTPResponse res = http.send(req);

    if (res.getStatusCode() != 201) {
      System.debug('The status code returned was not expected: ' + res.getStatusCode());
    }else{
      System.debug(res.getBody());
    }

    return res.getBody();
  }

  public static WeatherWrapper prepareWrapper(String city, Weather_Setting__c settingsWeather) {
    WeatherWrapper wrapper = (WeatherWrapper)JSON.deserialize(doApiCall(city, settingsWeather), WeatherWrapper.class);
    
    Map<String, Object> forecastsMap = (Map<String, Object>) JSON.deserializeUntyped(doApiCall(city, settingsWeather));
    String jsonList = JSON.serialize(forecastsMap.get('list'));
    List<Forecast> listForecasts = (List<Forecast>) JSON.deserialize(jsonList, List<Forecast>.class);
    wrapper.listForecasts = listForecasts;

    City__c recordCity = createCityRecord(wrapper.city.name, wrapper.city.country);
    createForecasts(recordCity, listForecasts);

    return wrapper;
  }

  public static City__c createCityRecord(String cityName, String countryAbr) {
    City__c recordCity = new City__c();
    recordCity.Name = cityName;
    recordCity.Country__c = countryAbr;

    insert recordCity;

    return recordCity;
  }

  public static void createForecasts(City__c recordCity, List<Forecast> listForecasts) {

    List<Forecast__c> recordsForecast = new List<Forecast__c>();

    for (Forecast variable : listForecasts) {
      DateTime dataTimesForecast =  DateTime.newInstance(1000 * (Long) variable.dt);
      Forecast__c newForecast = new Forecast__c();
      newForecast.Name = recordCity.Name + '-' + dataTimesForecast.format('DD.MM.YYYY');
      newForecast.Date__c = dataTimesForecast.date();
      newForecast.Time__c = dataTimesForecast.time();     
      newForecast.Temperature__c = variable.main.temp;
      newForecast.City__c = recordCity.Id;
      recordsForecast.add(newForecast); 
    }

    insert recordsForecast;
  }

  public class WeatherWrapper{
  @AuraEnabled
    public City city;

  @AuraEnabled
    public List<Forecast> listForecasts;
  }

  public class City{
  @AuraEnabled
    public String name;

  @AuraEnabled
    public String country;
  }

  public class Forecast{
  @AuraEnabled
    public Main main;

  @AuraEnabled
    public Integer dt;
  }

  public class Main{
  @AuraEnabled
    public Decimal temp;

  @AuraEnabled
    public Decimal temp_min;

  @AuraEnabled
    public Decimal temp_max;
  }
}

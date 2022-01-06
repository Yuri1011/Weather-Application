public with sharing class ForecastTriggerHandler {
    public static void fillField() {
        FieldFillHelper.fillWeatherMessageField();
    }

    public static void deleteDublicateForecastForCity() {
        DublicateHelper.deleteDublicate();
    }
}

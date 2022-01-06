public with sharing class ForecastTriggerHandler {
    public static void doBeforeInsert() {
        FieldFillHelper.fillWeatherMessageField();
        DublicateHelper.deleteDublicate();
    }
}

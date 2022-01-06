import { api, LightningElement } from 'lwc';

export default class ForecastWeatherForCity extends LightningElement {
   @api forecastRecords;
}
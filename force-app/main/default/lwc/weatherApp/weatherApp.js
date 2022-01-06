import { LightningElement } from 'lwc';
import getData from '@salesforce/apex/WeatherAppController.getData';

export default class WeatherApp extends LightningElement {
    city;
    forecastRecords;

    onchangeInputCity(event) {
        this.city = event.target.value;
    }

    weatherCheck() {
        getData({city: this.city})
        .then(result => {
            this.forecastRecords = result.listForecasts;
        })
        .catch(error =>{
            console.log(error);
        })
    }
}
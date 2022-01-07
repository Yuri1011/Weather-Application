import { LightningElement } from 'lwc';
import getData from '@salesforce/apex/WeatherAppController.getData';

export default class WeatherApp extends LightningElement {
    city;
    datesForecast;
    forecastRecords;

    onchangeInputCity(event) {
        this.city = event.target.value;
    }

    weatherCheck() {
        getData({city: this.city})
        .then(result => {
            this.forecastRecords = result.listForecasts;
            const arrayDate = [];
            this.forecastRecords.forEach(item => {
                const currentDate = item.dt * 1000;
                arrayDate.push(currentDate);
                this.datesForecast = arrayDate;
            })
        })
        .catch(error =>{
            console.log(error);
        })
    }
}
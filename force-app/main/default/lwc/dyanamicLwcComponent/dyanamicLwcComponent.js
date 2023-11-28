import { LightningElement, api, wire } from 'lwc';
import getDataWithFieldSet from '@salesforce/apex/Account_DesignLWC.getDataWithFieldSet';
import getLabels from '@salesforce/apex/Account_DesignLWC.getLabels';

export default class DynamicLwcComponent extends LightningElement {
    @api fieldset;
    @api accessLevel;
    @api object;

    records;
    labels=[];

    @wire(getDataWithFieldSet, { fieldSet: '$fieldset', obj: '$object' })
    wiredGetData({ data, error }) {
        if (data) {
            this.records = data.map(record => record.dataMap);
            console.log('this.records', JSON.stringify(this.records));
        } else if (error) {
            console.error('Error loading data:', error);
        }
    }

    @wire(getLabels, { obj: '$object' })
    wiredGetLabels({ data, error }) {
        if (data) {
            this.labels = data;
            console.log('this.labels', JSON.stringify(this.labels));
        } else if (error) {
            console.error('Error loading field labels:', error);
        }
    }

 
}
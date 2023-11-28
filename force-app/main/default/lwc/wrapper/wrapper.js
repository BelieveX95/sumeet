// accountContactOpportunityWrapper.js
import { LightningElement, wire } from 'lwc';
import getAccountContactOpportunityData from '@salesforce/apex/DemoWrapperClass.getAccountContactOpportunityData';

const COLUMNS = [
    { label: 'Account Name', fieldName: 'acc.Name', type: 'text' },
    { label: 'Contact Name', fieldName: 'contacts', type: 'text', cellAttributes: { alignment: 'left' } },
    { label: 'Opportunity Name', fieldName: 'opportunities', type: 'text', cellAttributes: { alignment: 'left' } },
];

export default class AccountContactOpportunityWrapper extends LightningElement {
    columns = COLUMNS;
    data;

    @wire(getAccountContactOpportunityData)
    wiredAccountData({ data, error }) {
        if (data) {
            this.data = data;
            console.log('this.data',this.data);
            console.log('this.data',JSON.stringify(this.data));

        } else if (error) {
            console.error('Error fetching data:', error);
        }
    }
}
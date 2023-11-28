import { LightningElement, api, track,wire } from 'lwc';
import getContactsAndFields from '@salesforce/apex/ContactController.getRecordsAndFields';

export default class RecordTable extends LightningElement {
    @api objectName;
    @api fieldName;

   @track contacts;
  columns;
   

    @wire(getContactsAndFields, { objectName: '$objectName', fieldSetName: '$fieldName' })
  wiredContacts({ error, data }) {
    if (data) {
      this.contacts = data;

      if (data.length > 0) {
        this.columns = Object.keys(data[0]).map((fieldName) => {
          return { label: fieldName, fieldName: fieldName };
        });
        console.log('this.columns,this.columns',JSON.stringify(this.columns));
      }
    } else if (error) {
      console.error('Error fetching contacts: ', error);
    }
  }
}
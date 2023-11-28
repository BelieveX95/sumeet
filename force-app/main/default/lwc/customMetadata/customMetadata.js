import { LightningElement, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import getRecords from '@salesforce/apex/customMetadataList.getRecords';

export default class MappingObjectPicklist extends LightningElement {
  templateOptions = [];
  sourceObjectOptions = [];
  destinationObjectOptions = [];

  @wire(getRecords)
  wiredRecords({ error, data }) {
    if (data) {
      this.templateOptions = this.getFieldOptions(data, 'Template_Name__c');
      this.sourceObjectOptions = this.getFieldOptions(data, 'Source_Object__c');
      this.destinationObjectOptions = this.getFieldOptions(data, 'Destination_Object__c');
    } else if (error) {
      console.error('Error retrieving Mapping_Object__mdt records:', error);
    }
  }

  getFieldOptions(records, fieldName) {
    const options = [];
    records.forEach(record => {
      const field = record[fieldName];
      if (field) {
        options.push({ label: field, value: field });
      }
    });
    return options;
  }
}
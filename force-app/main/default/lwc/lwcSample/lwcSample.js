import { LightningElement, wire ,api} from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Account.Name'
export default class LwcSample extends LightningElement {
    @api recordId;

    @wire(getRecord,{recordid:'$recordId',field: [NAME_FIELD]})

    wriedRecord({data,erro}){
        if(data){
            conole.log('JSON Data',JSON.stringify(data));
        }else if(error){
            console.log('JSON RERRO',JSON.stringify(error));
        }
    }
    
}
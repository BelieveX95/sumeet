import { LightningElement } from 'lwc';

export default class LwcAccountRecord extends LightningElement {
    record;
    showDetails = false;

    handlerecordid(event) {
        const Recordid = event.detail;
        this.record = Recordid;
        this.showDetails = true;
        console.log('Getting Id On Parent##', Recordid);
    }
}
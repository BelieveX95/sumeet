import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LwcChildComp extends LightningElement {
    handleClick() {
        var clearValueEvent = new CustomEvent('reset');
        
        this.dispatchEvent(clearValueEvent);

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Value Cleared',
                variant: 'success',
            }),
        
        )}
}
import { LightningElement, wire } from 'lwc';

export default class LwcParentComp extends LightningElement {
    ShowValue = '';

    handlekeyup(event) {
        this.ShowValue = event.target.value;

        console.log(this.ShowValue );
    }

    handleClearValue() {
        this.ShowValue = '';
        alert(Cleard);

    }
    
}
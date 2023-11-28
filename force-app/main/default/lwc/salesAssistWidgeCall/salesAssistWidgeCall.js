import { LightningElement, track } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import saleassistWidget from '@salesforce/resourceUrl/DisplayProduct';
export default class Live_VideoLWC extends LightningElement {
    
     @track widgetId = 'd39cc008-5dcc-4568-aeff-7c1216d54f93';
 
    connectedCallback() {
        this.loadSaleAssistLibrary();
    }
    
 @track sampleUrl = 'https://static.saleassist.ai/widgets/widget.js';
    loadSaleAssistLibrary() {
        loadScript(this, saleassistWidget + '/widget.js')
            .then(() => {
                // Assuming saleassist is globally available
                window.saleassist.mountWidget({ id: this.widgetId });
            })
            .catch(error => {
                console.error('Error loading SaleAssist library:', error);
            });
    }
}
import { LightningElement } from 'lwc';
import bootstrap from '@salesforce/resourceUrl/bootstrap';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

export default class BootStapDemo extends LightningElement {
    renderedCallback(){
        console.log('bootstrap',bootstrap);
        
        Promise.all([
            loadScript(this,bootstrap +'/bootstrap-5.0.2-dist/js/bootstrap.js' ),        
            loadStyle(this,bootstrap + '/bootstrap-5.0.2-dist/css/bootstrap.min.css')
        ])

        .then(() => {
            console.log('success');
        })
    }

}
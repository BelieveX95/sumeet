import { LightningElement } from 'lwc';

export default class SearchContact extends LightningElement {

    handleSearch(event){
        const searchQuery = event.target.value.toLowerCase();
        console.log('with onkeyup',searchQuery);
        const searchEvent = new CustomEvent('search', {
          detail: { searchQuery }
        });
        this.dispatchEvent(searchEvent);
        console.log('with onkeyup dispatch',this.dispatchEvent);

      }   
}
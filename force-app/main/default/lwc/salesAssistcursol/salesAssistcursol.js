import { LightningElement } from 'lwc';

export default class SliderLWC extends LightningElement {
    handleRadioChange(event) {
        const selectedIndex = event.target.getAttribute('data-index');
        const cards = this.template.querySelectorAll('.cards .card');

        cards.forEach((card, index) => {
            card.classList.remove('active');
            if (index == selectedIndex) {
                card.classList.add('active');
            }
        });
    }
}
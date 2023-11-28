import { LightningElement, track } from 'lwc';

export default class IframeCarousel extends LightningElement {
    @track frame1 = 'https://believe-dev-ed--c.develop.vf.force.com/apex/Widget1?core.apexpages.request.devconsole=1';
    @track frame2 = 'https://believe-dev-ed--c.develop.vf.force.com/apex/Widget2?core.apexpages.request.devconsole=1';
    @track frame3 = 'https://believe-dev-ed--c.develop.vf.force.com/apex/Widget3?core.apexpages.request.devconsole=1';

    @track currentItemIndex = 1; // Index of the currently centered item

    handleNext() {
        this.currentItemIndex = (this.currentItemIndex % 3) + 1;
    }

    handlePrevious() {
        this.currentItemIndex = this.currentItemIndex > 1 ? this.currentItemIndex - 1 : 3;
    }
}
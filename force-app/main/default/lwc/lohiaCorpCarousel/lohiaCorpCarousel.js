import { LightningElement } from 'lwc';
import bootstrap from '@salesforce/resourceUrl/bootstrap';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';

import LohiaCorpS3 from '@salesforce/resourceUrl/LohiaCorpS3';
import LohiaCorpS2 from '@salesforce/resourceUrl/LohiaCorpS2';
import LohiaCorpS1 from '@salesforce/resourceUrl/LohiaCorpS1';


export default class LohiaCorpCarousel extends LightningElement {

 image1=LohiaCorpS3;
 image2=LohiaCorpS2;
 image3=LohiaCorpS1;

  renderedCallback() {
    Promise.all([
      loadScript(this, bootstrap + '/bootstrap-5.0.2-dist/js/bootstrap.js'),
      loadStyle(this, bootstrap + '/bootstrap-5.0.2-dist/css/bootstrap.min.css')
    ]).then(() => {
      console.log('Bootstrap resources loaded successfully');
      this.initCarousel();
    });
  }

  initCarousel() {
    console.log('is it working==>>');
    const carousel = new window.bootstrap.Carousel(
      this.template.querySelector('.carousel'), {
        interval: 2000, 
        wrap: true 
      }
    );
  }
}
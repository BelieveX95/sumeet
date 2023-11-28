import { LightningElement, wire, track } from 'lwc';
import getProducts from '@salesforce/apex/ProductListController.getProducts';
import addToBasket from '@salesforce/apex/ProductListController.addToBasket';

export default class ProductListTable extends LightningElement {
    @track products = [];
    error;
    outofstock = false;
    Instock = true;
    @track likeState = false;


    @wire(getProducts)
    wiredProducts({ error, data }) {
        if (data) {
            this.products = data.map(product => ({
                ...product,
                count: 0
            }));

            console.log('wired data', this.products);
        } else if (error) {
            this.error = error;
        }
    }

    increment(event) {
        const productId = event.target.dataset.productid;
        console.log(productId);
        const productIndex = this.products.findIndex(product => product.Id === productId);

        if (productIndex !== -1) {
            this.products[productIndex].count++;
            this.updateTotalPrice(productIndex);
        }
    }

    decrement(event) {
        const productId = event.target.dataset.productid;

        const productIndex = this.products.findIndex(product => product.Id === productId);

        if (productIndex !== -1) {
            if (this.products[productIndex].count > 1) {
                this.products[productIndex].count--;
                this.updateTotalPrice(productIndex);
            } else {
                this.products[productIndex].count = 1;
            }
        }
    }

    updateTotalPrice(index) {
        const product = this.products[index];
        product.totalPrice = product.count * product.UnitPrice;
    }




    handlebasket(event) {

        const productId = event.target.dataset.productid;
        console.log('clicked', productId);

        const productIndex = this.products.findIndex(product => product.Id === productId);
        console.log('clicked', productIndex);

        if (productIndex !== -1) {
            const product = this.products[productIndex];
            const { Id, count, totalPrice } = product;
            console.log('clicked', totalPrice);

            addToBasket({ productId: Id, count, totalPrice })
                .then(result => {
                    alert('Product added to basket successfully');
                })
                .catch(error => {
                    console.error('Error adding product to basket: ', error);
                });
        }
    }

    HandleSaving() {
        this.Instock = true;
        alert('Saving Available');

    }

    HandleAlternative() {
        this.outofstock = true;
    }

    Handletracker() {
        this.outofstock = true;
    }

    handleLikeButtonClick() {
        this.likeState = !this.likeState;
    }


}
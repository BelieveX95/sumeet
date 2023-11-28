import { LightningElement, track } from 'lwc';
import makePostRequest from '@salesforce/apex/SalesAssistController.makePostRequest';
import createMeetingConfiguration from '@salesforce/apex/MeetingConfigurationController.createMeetingConfiguration';

export default class MyComponent extends LightningElement {
    @track videoUrl = [];
    callButton;
    email = '';
    joinlink;
    @track isLoading = false;

    connectedCallback() {
        console.log('Function calledd on load');
        this.handleButtonClick();

    }

    handleButtonClick() {
        const apiKey = '419294D617DE904831D36E4449DCFF3D';
        const apiSecret = '376936fe91543a4faeb793c7d694a0650e1d9ec8824b5d8abf2d76a053ec26da';
        const email = 'sumeet.kendre@gmail.com';
        const mobileNumber = '9999701540';
        const name = 'Sumeet';
        const storeName = 'Believe';
        makePostRequest({ apiKey, apiSecret, email, mobileNumber, name, storeName })
            .then(result => {
                console.log('Sccess', result);

                const responseData = JSON.parse(result);
                console.log('responseData==>', responseData);

                if (responseData.widgets && responseData.widgets.length > 0) {
                    this.videoUrl = responseData.widgets[0].source_welcome_video_url;
                    console.log('this.videoUrl==>', this.videoUrl);
                }
            })
            .catch(error => {
                console.log('error', error);

            });
    }

    handleCreateMeeting() {
        this.isLoading = true;

        createMeetingConfiguration()
            .then(responseBody => {
                console.log('Response Body:', responseBody);
                const datafromapex = JSON.parse(responseBody);

                if (datafromapex.moderators && datafromapex.moderators.length > 0) {
                    this.joinlink = datafromapex.join_links.public;
                    console.log('joinlink==>', JSON.stringify(this.joinlink));
                }

                this.handleLink();
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }

    handleLink(event) {
        this.isLoading = false;

        if (this.joinlink) {
            window.open(this.joinlink, '_blank');
        } else {
            console.log('Join link is not available');
        }
    }

}
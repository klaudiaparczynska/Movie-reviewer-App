import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import getRecordWithVisibleReview from '@salesforce/apex/HelperClassToHideReview.getRecordWithVisibleReview';
import hideReview from '@salesforce/apex/HelperClassToHideReview.hideReview';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';

export default class HideButton extends NavigationMixin(LightningElement) {
    filteredReviews;
    review;
    @api recordId;

    @wire(getRecordWithVisibleReview, {recordId: '$recordId'})
    getRecordWithVisibleReview({error, data}) {
        if(data) {
            if(data.length > 0){
                this.filteredReviews = data;
                this.error = undefined;
            }
        } if(error) {

        }
    }
    
    
    hideReview(event){
        hideReview({recordId:this.recordId})
            .then(result =>{
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Hidden review',
                    variant: 'success',
                });
                this.dispatchEvent(evt);
                getRecordNotifyChange([{recordId: this.recordId}]);
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.recordId,
                        objectApiName: 'Movie_Review__c',
                        actionName: 'view'
                        }
                })
                this.filteredReviews = result;
            })
            .catch(error =>{
                this.error = error;
                console.log(error);
            })
    }
    closeAction(event){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}
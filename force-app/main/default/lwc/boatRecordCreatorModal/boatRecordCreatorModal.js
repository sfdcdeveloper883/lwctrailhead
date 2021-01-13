import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { NavigationMixin } from 'lightning/navigation';

export default class BoatRecordCreatorModal extends NavigationMixin(LightningElement) {

    @api
    boatType;

    showBoatRecordCreatorModal = false;

    @api
    show() {
        this.showBoatRecordCreatorModal = true;
    }

    @api
    hide() {
        this.showBoatRecordCreatorModal = false;
    }

    handleCancel = (event) => {
        this.hide();
    }

    generateCreatedBoatUrl = async (boatId) => {
        return await this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: boatId,
                actionName: 'view',
            },
        });
    }

    submitForm = (event) => {
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    handleCreatedBoat = (event) => {
        this.hide();
        this.showCreatedBoatToast(event.detail.id, event.detail.fields.Name.value);
    }

    showCreatedBoatToast = async (boatId, boatName) => {
        const url = await this.generateCreatedBoatUrl(boatId);

        this.dispatchEvent(new ShowToastEvent({
            title: 'Success!',
            variant: 'success',
            message: 'Boat {0} successfully created. See it {1}!',
            messageData: [
                boatName,
                {
                    url,
                    label: 'here'
                }
            ]
        }));
    }

}
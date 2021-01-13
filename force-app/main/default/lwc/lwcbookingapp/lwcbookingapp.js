import { LightningElement, track, api } from 'lwc';
import fetchdetails from '@salesforce/apex/ResourceHallController.fetchHalldetails';
import { NavigationMixin } from 'lightning/navigation';


const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Price', fieldName: 'Price__c' },
    /* { label: 'Start Date', fieldName: 'Start_Date__c' },
     { label: 'End Date', fieldName: 'End_Date__c' },*/
    { label: 'Availability', fieldName: 'Availability__c' },
    {
        type: "button", typeAttributes: {
            label: 'View',
            name: 'View',
            title: 'View',
            disabled: false,
            value: 'view',
            iconPosition: 'left'
        }
    },
    {
        type: "button", typeAttributes: {
            label: 'Book',
            name: 'Book',
            title: 'Book',
            disabled: false,
            value: 'Book',
            iconPosition: 'left'
        }
    },
    {
        type: "button", typeAttributes: {
            label: 'Cancel',
            name: 'Cancel',
            title: 'Cancel',
            disabled: false,
            value: 'Cancel',
            iconPosition: 'left'
        }
    }
];
export default class Lwcbookingapp extends NavigationMixin( LightningElement ) {

    @track halls;
    @track error;
    @track columns = columns;
    @track isModalOpen;
    @track recId;
    @track stdate;
    @track endDate;
    @track available;

    handlestDateChange( event ) {
        this.stdate = event.target.value;
        alert( this.stdate );
    }

    handleendDateChange( event ) {
        this.endDate = event.target.value;
    }

    handleKeyChange( event ) {
        const searchKey = event.target.value;
        const stDate = this.stdate;
        const endDate = this.endDate;
        if ( searchKey )
        {
            fetchdetails( { searchKey, stDate, endDate } )
                .then( result => {
                    this.halls = result;
                } )
                .catch( error => {
                    this.error = error;
                } );
        } else
            this.halls = undefined;

    }

    closeModal() {
        this.isModalOpen = false;
    }

    renderedCallback() {

        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if ( inputFields )
        {
            inputFields.forEach( field => {
                if ( field.fieldName == 'Resource_Hall__c' )
                    field.value = this.recId;
            } );
        }
    }

    handleSuccess( event ) {

        this[ NavigationMixin.Navigate ]( {
            type: 'standard__recordPage',
            attributes: {
                recordId: event.detail.id,
                actionName: 'view',
            },
        } );
    }

    callRowAction( event ) {

        this.recId = event.detail.row.Id;
        this.available = event.detail.row.Availability__c;
        const actionName = event.detail.action.name;
        if ( actionName === 'Book' )
        {
            if ( this.available == 'Booked' )
            {
                var result = confirm( 'Hall is already Booked' );
                if ( result )
                {
                    this.isModalOpen = true;
                }
            } else
            {
                this.isModalOpen = true;
            }


        } else if ( actionName === 'View' )
        {

        } else if ( actionName === 'Cancel' )
        {
            updatedetails( {
                chkAvailability: 'Available',
                recordId: recId

            } )
                .then( ( resp ) => {
                } ).catch( ( err ) => {
                } );
        }

    }

    get getLocationoptions() {
        return [
            { label: 'Bangalore', value: 'Bangalore' },
            { label: 'Chennai', value: 'Chennai' },
            { label: 'Mumbai', value: 'Mumbai' },
        ];
    }

}
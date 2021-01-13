import { LightningElement, wire, track } from 'lwc';
import getContactList from '@salesforce/apex/DisplayAccountContacts.getAccountList';
import getAccountList from '@salesforce/apex/DisplayAccountContacts.getContactList';
const acccolumns = [
    { label: 'Id', fieldName: 'Id', type: 'text' },
    { label: 'Name', fieldName: 'Name', type: 'text' }
]
const contcolumns = [
    { label: 'Id', fieldName: 'Id', type: 'text' },
    { label: 'Name', fieldName: 'Name', type: 'text' }
]
export default class Displayaccountcontact extends LightningElement {
    @track contdata;
    @track acctdata;
    @wire( getContactList )
    contacts( { error, data } ) {
        console.log( data )
        this.contdata = JSON.stringify( data );
    };

    @wire( getAccountList )
    accounts( { error, data } ) {
        console.log( data )
        this.acctdata = JSON.stringify( data );
    };
}
import { LightningElement, wire } from 'lwc';
import { reduceErrors } from 'c/ldsUtils';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import getContacts from '@salesforce/apex/ContactController.getContacts';
const COLUMNS = [
    { label: 'Contact LastName', fieldName: LASTNAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Contact FirstName', fieldName: FIRSTNAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Email', fieldName: EMAIL_FIELD.fieldApiName, type: 'text' }
];

export default class ContactList extends LightningElement {
    columns = COLUMNS;
    errors;
    get errors() {
        return (this.contacts.error) ?
            reduceErrors(this.contacts.error) : [];
    }
    @wire(getContacts)
    contacts({ data, error }) {
        if (error)
            this.errors = reduceErrors(error);
    };
}
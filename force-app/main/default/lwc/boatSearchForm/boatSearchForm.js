import { LightningElement, track, wire } from 'lwc';

import getBoatTypes from '@salesforce/apex/BoatDataService.getBoatTypes';

const ALL_TYPES_LABEL = 'All Types';
const ALL_TYPES = '';

export default class BoatSearchForm extends LightningElement {

	@track
	searchOptions = []
	selectedBoatTypeId = '';
	@track error = undefined;
	boatTypeOptionsDisabled = true;

	connectedCallback() {
		return this.fetchBoatTypes();
	}

	@wire( getBoatTypes )
	boatTypes( { error, data } ) {
		if ( data )
		{
			this.searchOptions = data.map( type => {
				return {
					label: type.Name,
					value: type.Id
				};
			} );

			this.searchOptions.unshift( { label: 'All Types', value: '' } );
		} else if ( error )
		{
			this.searchOptions = undefined;
			this.error = error;
		}
	}

	handleSearchOptionChange( event ) {
		event.preventDefault();
		this.selectedBoatTypeId = event.detail.value;
		const searchEvent = new CustomEvent( 'search', {
			detail: {
				boatTypeId: this.selectedBoatTypeId
			}
		} );
		this.dispatchEvent( searchEvent );
	}

	fetchBoatTypes = async () => {
		const boatTypes = await getboatTypes();
		const searchOptions = boatTypes.map( type => {
			return {
				label: type.Name,
				value: type.Id
			};
		} );

		searchOptions.unshift( {
			label: ALL_TYPES_LABEL,
			value: ALL_TYPES
		} )

		this.searchOptions = searchOptions;
		this.boatTypeOptionsDisabled = false;
	};



	handleSearchClick = ( event ) => {
		this.dispatchEvent( new CustomEvent( "search", {
			detail: {
				boatTypeId: this.selectedBoatTypeId
			}
		} ) );
	}

	handleShowNewBoatModal = () => {
		this.template.querySelector( 'c-boat-record-creator-modal' ).show();
	}

}
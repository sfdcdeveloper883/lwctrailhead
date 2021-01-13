/*
*/
import { LightningElement, track, wire } from 'lwc';
import getAllProducts from '@salesforce/apex/ProductController.getAllProducts';

const actions = [
    { label: 'Delete', name: 'delete' }
];

//define treegrid columns
const columns = [
    { label: 'Catalogue Hierarchy', fieldName: 'label', type: 'text' },
    {
        label: 'Type', fieldName: 'type', type: 'text', fixedWidth: 150, initialWidth: 150,
        cellAttributes: { iconName: { fieldName: 'treeIcon' } }
    },
    { type: 'action', typeAttributes: { rowActions: actions } },
];
//define initial Product Catalogue rows
const items = [{
    label: "Product Catalogue 1", name: "Product Catalogue 1",
    type: "Catalogue",
    treeIcon: 'standard:catalog',
    _children: [],
    expanded: false,
}, {
    label: "Product Catalogue 2", name: "Product Catalogue 2",
    type: "Catalogue",
    treeIcon: 'standard:catalog',
    _children: [],
    expanded: false,
}, {
    label: "Product Catalogue 3", name: "Product Catalogue 3",
    type: "Catalogue",
    treeIcon: 'standard:catalog',
    _children: [],
    expanded: false,
}];

export default class BuildProductCatalogue extends LightningElement {
    iconName = 'standard:outcome';
    @track treeList = items;
    @track columns = columns;
    @track listItems = []; //combobox items
    @track listValues = []; //combobox values
    @track selectedItems = []; //to hold combo box selected items
    @track globalSelectedItems = []; //for displaying pills
    @track selectedTreeNodes = []; // for holding selected tree nodes
    isProductsSelected = false;

    constructor() {
        super();
        //register dragover event to the template
        this.template.addEventListener('dragover', this.handleDragOver.bind(this));
    }

    //retrieve all the products from database
    @wire(getAllProducts)
    wiredAllProducts({ error, data }) {
        if (data) {
            data.map(element => {
                this.listItems = [...this.listItems, {
                    value: element.Id,
                    label: element.Name
                }];
            });
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.treeList = undefined;
        }
    }

    //This method is called during checkbox value change
    handleCheckboxChange(event) {
        let selectItemTemp = event.detail.value;
        this.selectedItems = []; //it will hold only newly selected checkbox items.        

        /* find the value in items array which has been prepared during database call
           and push the key/value inside selectedItems array           
        */
        selectItemTemp.map(p => {
            let arr = this.listItems.find(element => element.value == p);
            if (arr != undefined) {
                this.selectedItems.push(arr);
                this.listValues.push(arr.value);
            }
        });
        this.globalSelectedItems = this.selectedItems;
        this.isProductsSelected = this.selectedItems.length > 0;
    }

    //this will removes combo box values
    handleRemoveComboItems(event) {
        const removeItem = event.target.dataset.item; //"0032v00002x7UEHAA2" 

        this.listValues = this.listValues.filter(item => item != removeItem);

        //this will prepare globalSelectedItems array excluding the item to be removed.
        this.globalSelectedItems = this.globalSelectedItems.filter(item => item.value != removeItem);
        this.selectedItems = this.globalSelectedItems;
        this.isProductsSelected = this.globalSelectedItems.length > 0;
    }

    //when drag is start this method fires
    handleDragStart(event) {
        event.dataTransfer.dropEffect = 'move';
        event.dataTransfer.setData('text', JSON.stringify(this.selectedItems));
    }

    handleDragOver(event) {
        event.dataTransfer.dropEffect = 'move';
        event.preventDefault();
    }

    //when item is dropped this event fires
    handleDrop(event) {
        event.stopPropagation();
        event.preventDefault();
        event.dataTransfer.dropEffect = 'copy';
        let droppedItems = event.dataTransfer.getData('text');
        let droppedProductList = Array.from(JSON.parse(droppedItems));

        if (droppedProductList != null && droppedProductList != undefined) {

            this.selectedTreeNodes.map(nodeItem => {
                //prepare type
                let droppedItemType = nodeItem.type === 'Catalogue' ? 'Product Line' :
                    nodeItem.type === 'Product Line' ? 'Product Group' :
                        nodeItem.type === 'Product Group' ? 'Product' : 'Item';
                //assign icons based on type
                let droppedIcon = droppedItemType == 'Product Line' ? 'standard:assignment' :
                    droppedItemType == 'Product Group' ? 'standard:flow' :
                        droppedItemType == 'Product' ? 'standard:reward' : 'standard:task2';

                let newChildren = [];
                //create array for children and append new items under treenode                
                droppedProductList.map(item => {
                    const newItem = {
                        label: item.label,
                        name: nodeItem.name + '-' + item.label,
                        type: droppedItemType,
                        treeIcon: droppedIcon,
                        expanded: true,
                        _children: []
                    };
                    newChildren.push(newItem);
                });
                this.treeList = appendNewItems(nodeItem.name, this.treeList, newChildren);
            });
        }
        //remove product list selection.
        this.listValues = [];
        this.globalSelectedItems = [];
        this.isProductsSelected = false;
    }

    //this selects treegrid node
    handleTreeNodeSelect(event) {
        this.selectedTreeNodes = event.detail.selectedRows;
    }

    //this deletes the items from treegrid
    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case 'delete':
                const rows = Array.from(this.treeList);
                deleteTreeNode(row.name, rows);
                this.treeList = rows;
                break;
        }
    }
}

//this function traverses nested tree and push the children
function appendNewItems(rowName, data, children) {
    return data.map(row => {
        if (row.name === rowName) {
            //if children exists then loop through children to push
            if (row.hasOwnProperty('_children') && Array.isArray(row._children)
                && row._children.length > 0) {
                children.map(newItem => {
                    row._children.push(newItem);
                });
            } else {
                row._children = children;
            }
            return row;
        } else {
            appendNewItems(rowName, row._children, children);
        }
        return row;
    });
}

//this function traverses nested tree to delete the item
function deleteTreeNode(rowName, data) {
    return data.map(row => {
        const rows = data;
        if (row.name === rowName) {
            row._children = [];
            const rowIndex = rows.indexOf(row);
            rows.splice(rowIndex, 1);
            return rows;
        } else {
            deleteTreeNode(rowName, row._children);
        }
    });
}
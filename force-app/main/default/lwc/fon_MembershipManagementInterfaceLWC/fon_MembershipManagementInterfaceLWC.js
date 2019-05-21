import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class MembershipCmpCtrl extends NavigationMixin(LightningElement) {
    @api tabName;
    @api label;
    @api recordId;
    
    navigateNewMember() {
        this[NavigationMixin.Navigate]({
			type: 'standard__component',
			attributes: {
                componentName: 'c:Fon_NewMembershipCmp',
                contactId: '003Z000003D4EJyIAN'
			}
		});
    }
}
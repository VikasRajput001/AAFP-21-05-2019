global virtual inherited sharing class OrderSummary extends FDService.WrapperBase {
	@AuraEnabled 
	global Id id;
	@AuraEnabled 
	global Id ownerId;
	@AuraEnabled 
	global Boolean isDeleted;
	@AuraEnabled 
	global String name;
	@AuraEnabled 
	global Datetime createdDate;
	@AuraEnabled 
	global Id createdById;
	@AuraEnabled 
	global Datetime lastModifiedDate;
	@AuraEnabled 
	global Id lastModifiedById;
	@AuraEnabled 
	global Datetime systemModstamp;
	@AuraEnabled 
	global Id account;
	@AuraEnabled 
	global Id contact;
	@AuraEnabled 
	global String customerLink;
	@AuraEnabled
	global Date dateCreated;
	@AuraEnabled 
	global String entity;
	@AuraEnabled 
	global String filterCriteria;
	@AuraEnabled 
	global String memo;
	@AuraEnabled 
	global String pdfURL;
	@AuraEnabled
	global String orderSummaryURL;
	@AuraEnabled
	global String addressTo	;
	@AuraEnabled 
	global Boolean showOutstandingCredits = false;

	@AuraEnabled
	global List<Id> orders = new List<Id>();
	@AuraEnabled
	global List<Id> invoices = new List<Id>();

	public static final String FEATURE = 'Order_Summary';

	global OrderSummary() {}

	global override void fromSObject(SObject OrderSummaryObj) {
		buildToWrapperFromJSON();
		this.dateCreated = (Date)OrderSummaryObj.get('OrderApi__Date__c');
	}


	private void buildToSObjectJSON() {
		Map<String,List<Id>> jsonObj = new Map<String,List<Id>>();
		if (this.orders != null && this.orders.size() > 0) {
			jsonObj.put('orders',this.orders);
		}
		if (this.invoices != null && this.invoices.size() > 0) {
			jsonObj.put('invoices',this.invoices);
		}
		this.filterCriteria = JSON.serialize(jsonObj);
	}

	private void buildToWrapperFromJSON() {
		this.orders = new List<Id>();
		this.invoices = new List<Id>();
		if (String.isNotEmpty(this.filterCriteria)) {
			Map<String, List<Id>> jsonObj = ( Map<String, List<Id>> ) JSON.deserialize(this.filterCriteria, Map<String, List<Id>>.class);
			if (jsonObj.containsKey('orders')) {
				this.orders = jsonObj.get('orders');
			}
			if (jsonObj.containsKey('invoices')) {
				this.invoices = jsonObj.get('invoices');
			}
		}
	}
}
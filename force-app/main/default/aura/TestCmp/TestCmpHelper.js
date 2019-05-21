({
    doInit : function (component) {
        this.getTabReports(component);
        
    },
    getTabReports : function (component) {
        var self = this;
        var action = component.get('c.getTabReports');
        action.setCallback(this,function(response){
            if (response.getState() === 'ERROR') {
                response.getError().forEach(function(error) {
                    component.find('toastMessages').showMessage('', error.message,false,'error','topCenter');
                });
            }
            else {
                self.buildReportLookup(component,response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    buildReportLookup : function (component,reports) {
        $A.createComponent('Framework:InputFields',
                           {
                               fieldType : 'advancedselectfield',
                               'aura:id' : 'reportListView',
                               isRequired : true,
                               value : component.get('v.searchSelectObj'),
                               label : 'Report',
                               otherAttributes : {
                                   allowCreate : false,
                                   selectOptions: reports,
                                   otherMethods : {
                                       create: false
                                   }
                               }
                               
                           },function(cmp){
                               component.set('v.reportGlobalId',cmp.getGlobalId());
                               cmp.set('v.value',component.get('v.searchSelectObj'));
                               var divComponent2 = component.find('reportsLookup');
                               divComponent2.set("v.body", [cmp]);
                           });
    }
})
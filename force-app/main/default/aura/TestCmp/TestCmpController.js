({
    doInit : function (component,event,helper) {
        component.set('v.searchSelectObj',{
            site : null,
            selectAllBox : false,
            ticketType : null,
            reportListView : null
        });
        helper.doInit(component);
    }
})
({
	getTPCP_AlertDisplay: function (component, event, helper) {
        console.log('inside getTPCP_AlertDisplay');
        var action = component.get("c.getTPCP_AlertMessageDisplay");
        action.setCallback(this, function(response) {
        var state = response.getState();
        var a = JSON.parse(JSON.stringify(response.getReturnValue()));
            console.log(state);
            if (state === "SUCCESS") {
                console.log('Response of getTpUserPendingTrainings: ' + JSON.stringify(response.getReturnValue()));
        		component.set("v.AlertMessageList", a);
                console.log('adasdasdasdasd'+component.get('v.AlertMessageList'));
            }
		
	});
        
        $A.enqueueAction(action);
    },
})
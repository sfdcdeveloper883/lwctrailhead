({
	doInit: function (component, event, helper) {  
        console.log('inside doInit');
       	helper.getTPCP_AlertDisplay(component, event, helper);
                   
        },
    
    closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false
      console.log(component.get("v.isNotificationOpen"));
         if(component.get("v.isNotificationOpen") == false)
     		 component.set("v.isNotificationOpen", true);
         else
             component.set("v.isNotificationOpen", false);  
       
   },
})
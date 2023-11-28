({

    calloutforOTP : function(component, event, helper) {

        component.set("v.firstScreen", false); 

        component.set("v.secondScreen", true); 

        component.set("v.thirdScreen", false); 


        component.set("v.spinner", true); 


        var check = component.get('v.aadNumber');

        console.log(check); 

        var action = component.get('c.makeCalloutforOTP'); 

        action.setParams({

            "aadharNumber" : check 

        });

        action.setCallback(this, function(a){

            var state = a.getState();       // get the response state

            if(state == 'SUCCESS') {

                console.log(a.getReturnValue());

                component.set("v.spinner", false); 

                component.set('v.otpWrapper', a.getReturnValue());

                console.log(component.get('v.otpWrapper'));

           }

        });

        $A.enqueueAction(action);

    },

    

    calloutforAadharDetails : function(component, event, helper) {

        component.set("v.firstScreen", false); 

        component.set("v.secondScreen", false); 

        component.set("v.thirdScreen", true); 

        component.set("v.spinner", true); 


        var otp = component.get('v.otpNumber');

        var mobNumber = component.get('v.mobileNumber');

        var obj = component.get("v.otpWrapper");

        //console.log(obj);

        console.log(obj.data.client_id);

        var clintID = obj.data.client_id;

        console.log(clintID);

        var action = component.get('c.makeCalloutforCustomerDetails'); 

        action.setParams({

            "otp" : otp,

            "mobileNumber" : mobNumber,

            "clientId" : clintID

        });

        action.setCallback(this, function(a){

            var state = a.getState();        // get the response state

            if(state == 'SUCCESS') {

                

                console.log(a.getReturnValue());

                component.set("v.spinner", false); 

                component.set('v.aadharWrapper', a.getReturnValue());

                console.log(component.get('v.aadharWrapper'));

                

                //if(a.getReturnValue() == 200){

                   // component.set('v.aadharWrapper', a.getReturnValue());

                    

                    var toastEvent = $A.get("e.force:showToast");

                    toastEvent.setParams({

                        title : 'Success',

                        message: 'Aadhar Authentication Successful.',

                        duration:' 5000',

                        key: 'info_alt',

                        type: 'success',

                        mode: 'pester'

                    });

                    toastEvent.fire();                             

            }

            

            else

            {

                    var toastEvent = $A.get("e.force:showToast");

                    toastEvent.setParams({

                        title : 'Error',

                        message:'Aadhar Authentication Failed.',

                        duration:' 5000',

                        key: 'info_alt',

                        type: 'error',

                        mode: 'pester'

                    });

                    toastEvent.fire();

             }

        });

        $A.enqueueAction(action);

    }

   

})
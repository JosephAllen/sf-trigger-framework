# Salesforce Trigger Framework

Trigger Handler based on Chris Aldridge's [Lightweight Apex Trigger Framework](https://github.com/ChrisAldridge/Lightweight-Trigger-Framework)

See Chris' original blog post: [Lightweight Apex Trigger Framework](http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/)

Below are few things to keep in mind while implementing the framework and in general best practices.

## Naming Convention

* All the triggers should follow a consistent naming standard of SobjectName followed by keyword Trigger i.e. SojectNameTrigger. For example a trigger on Contact object should be named as ContactTrigger.
* All the trigger handlers should be named as TriggerName followed by keyword Handler. For example for Contact trigger, the handler should be named as ContactTriggerHandler.
* All the test classes should be  named as TriggerName followed by Test keyword. For example for ContactTrigger the test class should be declared as ContactTriggerTest.
* None of the components in the framework should contain org name or app name.

## Metadata Type

This package will create an mdt called Trigger Settings.   This mdt contains common levers to control the trigger handler functionality.

* Trigger Settings Name = Name of the Trigger
* isActive = Determines if the trigger is execute.  This should be read from the IsDisabled() function of the Trigger Handler class.
* ObjectName = SObject Type of the Trigger
* Recursion Check = Can be used to control recursion if needed.
* Max Loop Count = Used to control recursion if needed.

## Custom Permission

This package creates a Custom Permission called Bypass Trigger.  Check the user for this permission in the IsDisabled function to bypass the trigger. Use the FeatureManagment.CheckPermission method.

``` csharp
FeatureManagment.CheckPermission(Bypass_Trigger);
```

## Create a Trigger Handler

Create a single trigger handler class for each object.  This class will implement the Trigger Handler interface provided.  Add logic to retrieve the Custom Metadata record for that trigger as well has handle the IsDisabled flag.  For example, the Trigger Handler for Account would look like this:

```csharp
/**
 * Trigger handler using the TriggerHandler framework from
 * http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/
 * Implements ITriggerHandler Interface
 */
public with sharing class AccountTriggerHandler implements ITriggerHandler {

    public Trigger_Settings__mdt triggerMeta = new Trigger_Settings__mdt();

    /**
     * Default Constructor
     */
    public AccountTriggerHandler() {
        //Retrieve the metadata type
        triggerMeta = [SELECT DeveloperName, isActive__c, ObjectName__c, Recursion_Check__c, Max_Loop_Count__c
                       FROM Trigger_Settings__mdt
                       WHERE DeveloperName = 'Account_Trigger'
                                             LIMIT 1];
    }

    /**
     * Determines if a trigger is Disabled
     * @return   Boolean
     */
    public Boolean isDisabled() {

        if (!triggerMeta.isActive__c || FeatureManagement.checkPermission('Bypass_Trigger')) {
            return false;
        }

        return true;
    }

    public void beforeInsert(List<SObject> newItems) {
    }

    public void afterInsert(Map<Id, SObject> newMap) {
        doFuture(newMap.keyset());
    }

    public void beforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
    }

    public void afterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
    }

    public void beforeDelete(Map<Id, SObject> oldMap) {
    }

    public void afterDelete(Map<Id, SObject> oldMap) {
    }

    public void afterUndelete(Map<Id, SObject> oldMap) {
    }

    @future

    private static void doFuture(Set<Id> newIds) {
        Account[] objs = [SELECT Id FROM Account WHERE Id IN : newIds];

        for (Account objCur: objs) {
        }
    }
}
```

## Create One Trigger

Create one trigger on an object.  Include every trigger event.  Call the Trigger Dispatcher run() method.  For example, a Account trigger would look like this:

``` csharp
/**
 * Trigger for Account
 * Uses the TriggerHandler framework to handle logic
 * Based on: http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/
 */
trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    TriggerDispatcher.Run(new AccountTriggerHandler());
}
```

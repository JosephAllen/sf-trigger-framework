/**
 * Trigger handler using the TriggerHandler framework from
 * http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/
 * implements ITriggerHandler Interface
 */
public class AccountTriggerHandler implements ITriggerHandler {

    public Trigger_Settings__mdt triggerMeta = new Trigger_Settings__mdt();

    //create a constructor to get the metadatatype

    /**
     */
    public AccountTriggerHandler() {
        //Retrieve the metadata type
        triggerMeta = [SELECT DeveloperName, isActive__c, ObjectName__c, Recursion_Check__c, Max_Loop_Count__c
                       FROM Trigger_Settings__mdt
                       WHERE DeveloperName = 'Account_Trigger'
                                             LIMIT 1];
    }

    //read the custom metadata and look for the customer permission
    public Boolean IsDisabled() {
        // return IsDisabled= true if the metadata setting isActive = false or
        // the user has the Bypass Trigger custom permission
        if (!triggerMeta.isActive__c || FeatureManagement.checkPermission('Bypass_Trigger')) {
            return false;
        }
        else {
            return true;
        }
    }

    public void BeforeInsert(List<SObject> newItems) {
    }

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {

        system.debug('Before Update for Account');
    }

    public void BeforeDelete(Map<Id, SObject> oldItems) {
    }

    public void AfterInsert(Map<Id, SObject> newItems) {
    }

    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
    }

    public void AfterDelete(Map<Id, SObject> oldItems) {
    }

    public void AfterUndelete(Map<Id, SObject> oldItems) {
    }
}

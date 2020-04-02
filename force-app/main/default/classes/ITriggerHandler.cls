/**
 * Generic TriggerHandler Interface for triggers
 * Based on: http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/
 *
 * Interface containing methods Trigger Handlers must implement to enforce best practice
 * and bulkification of triggers.
 */
public interface ITriggerHandler {

    boolean isDisabled();

    void beforeInsert(List<SObject> newItems);

    void beforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap);

    void beforeDelete(Map<Id, SObject> oldMap);

    void afterInsert(Map<Id, SObject> newMap);

    void afterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap);

    void afterDelete(Map<Id, SObject> oldMap);

    void afterUndelete(Map<Id, SObject> oldMap);
}

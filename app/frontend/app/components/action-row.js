import Ember from 'ember';

import lookupValidator from 'ember-changeset-validations';
import Changeset from 'ember-changeset';
import { ActionValidations } from 'frontend/validations';

const { isArray, computed, computed: { mapBy, uniq, sort } } = Ember;

export default Ember.Component.extend({

  tagName: 'tr',

  record: null,

  ActionValidations,

  allRelationships: [],

  allAvailableEntities: mapBy('allRelationships', 'dependentEntity.content'),
  allAvailableUniqueEntities: uniq('allAvailableEntities'),

  availableEntitiesNotAddedToChangeset: computed('c.includedEntities.[]', 'allAvailableUniqueEntities.[]', function () {
    const
      includedEntities = this.get('c.includedEntities') || [],
      allAvailableUniqueEntities = this.get('allAvailableUniqueEntities') || [];

    return allAvailableUniqueEntities.reject(e => !!includedEntities.findBy('id', e.get('id')));
  }),

  sortByName: ['name'],
  sortedAvailableEntitiesNotAddedToChangeset: sort('availableEntitiesNotAddedToChangeset', 'sortByName'),

  c: computed('record.isLoaded', function () {
    let record = this.get('record');
    if (!record || !record.get('isLoaded')) {
      return null;
    }
    return new Changeset(record, lookupValidator(ActionValidations), ActionValidations)
  }),

  actions: {
    destroyRecord() {
      this.sendAction('destroyRecord', this.get('record'));
    },
    addIncludedEntity(entity) {
      let includedEntities = this.get('c.includedEntities');
      if (isArray(includedEntities)) {
        includedEntities.pushObject(entity);
      }
    },
    submit(c) {
      this.sendAction('submit', c);
    },
    removeIncludedEntity(entity) {
      (this.get('c.includedEntities') || []).removeObject(entity);
    }
  }


});

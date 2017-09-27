import Ember from 'ember';
import lookupValidator from 'ember-changeset-validations';
import Changeset from 'ember-changeset';
import { ActionValidations } from 'frontend/validations';

const { isArray, computed, computed: { mapBy, uniq, sort }, run } = Ember;

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

  copiedToClipboard: false,

  url: computed('record.{name,requestType}', 'record.contract.content.{server,client}',  function () {
    const
      action = this.get('record'),
      clientName = action.get('contract.content.client'),
      serverName = action.get('contract.content.server'),
      host = window.location.href.split('/').slice(0, 3).join('/');

    return `${host}/jsonspec/response?client=${clientName}&server=${serverName}&action_name=${action.get('name')}&status_code=200`;
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
    },
    showCopiedToClipboardMessage() {
      this.set('copiedToClipboard', true);
      run.later(this, () => this.set('copiedToClipboard', false), 3000);
    }
  }


});

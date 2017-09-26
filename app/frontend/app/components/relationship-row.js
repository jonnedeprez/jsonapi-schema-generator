import Ember from 'ember';

import { RelationshipValidations } from 'frontend/validations';

export default Ember.Component.extend({
  tagName: 'tr',
  relationship: {},

  RelationshipValidations,

  cardinalityOptions: [{ value: 'HAS_MANY', name: 'Has many' }, { value: 'BELONGS_TO', name: 'Belongs to' }],

  dependentEntityOptions: [],

  actions: {
    submit(c) {
      this.sendAction('submit', c);
    },

    destroyRecord() {
      this.sendAction('destroyRecord');
    }
  }
});

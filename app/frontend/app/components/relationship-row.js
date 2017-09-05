import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'tr',
  relationship: {},

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

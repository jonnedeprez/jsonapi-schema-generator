import Ember from 'ember';

const { set, get } = Ember;

export default Ember.Route.extend({

  breadCrumb: {},

  model(params) {
    return this.get('store').findRecord('contract', params.contract_id);
  },

  afterModel(model) {
    set(this, 'breadCrumb', { title: get(model, 'client') + ' to ' + get(model, 'server') });
  }

});

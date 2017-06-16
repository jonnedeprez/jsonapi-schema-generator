import Ember from 'ember';


export default Ember.Route.extend({

  breadCrumb: {},

  model(params) {
    return this.get('store').findRecord('entity', params.entity_id);
  },

  afterModel(model) {
    this.set('breadCrumb', { title: model.get('name') })
  },


});

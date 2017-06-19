import Ember from 'ember';


export default Ember.Route.extend({

  breadCrumb: {},

  model(params) {
    return this.get('store').findRecord('entity', params.entity_id);
  },

  setupController(controller, model) {
    this._super(controller, model);
    this.get('store').findAll('entity').then(entities => controller.set('dependentEntityOptions', entities));
  },

  afterModel(model) {
    this.set('breadCrumb', { title: model.get('name') });
  },


});

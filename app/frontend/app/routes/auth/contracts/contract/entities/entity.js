import Ember from 'ember';


export default Ember.Route.extend({

  breadCrumb: {},

  model(params) {
    return this.get('store').findRecord('entity', params.entity_id);
  },

  setupController(controller, model) {
    this._super(controller, model);
    controller.set('contract', this.modelFor('auth.contracts.contract'));
    this.get('store').findAll('entity').then(entities => controller.set('dependentEntityOptions', entities));

    controller.resetNewField();
    controller.resetNewRelationship();
    controller.resetNewAction();
  },

  afterModel(model) {
    this.set('breadCrumb', { title: model.get('name') });
  },


});

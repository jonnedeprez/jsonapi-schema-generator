import Ember from 'ember';

const { debug, inject, computed: { oneWay } } = Ember;

export default Ember.Controller.extend({

  contractController: inject.controller('auth.contracts.contract'),
  contract: oneWay('contractController.model'),

  actions: {
    addEntity() {
      const contract = this.get('contract');
      this.get('store').createRecord('entity', { name: 'RenameMe', contract }).save().then(entity => {
        this.transitionToRoute('auth.contracts.contract.entities.entity', entity);
      })
    },

    removeEntity(entity) {
      debug('called action removeEntity for ' + entity.get('name'))
    }
  }
});

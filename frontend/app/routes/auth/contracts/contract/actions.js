import Ember from 'ember';

const { inject } = Ember;

export default Ember.Route.extend({

  secondaryNavigation: inject.service(),

  model() {
    const contract = this.modelFor('auth.contracts.contract');
    return contract.get('actions');
  },

  activate() {
    this._super(arguments);
    this.get('secondaryNavigation').set('activeTab', 'actions');
  }

});

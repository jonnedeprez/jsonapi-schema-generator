import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    const contract = this.modelFor('auth.contracts.contract');
    return contract.get('entities');
  }
});

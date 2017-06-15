import Ember from 'ember';

export default Ember.Route.extend({

  model() {
    const user = this.get('sessionWrapper').get('user');
    return user.get('contracts');
  }

});

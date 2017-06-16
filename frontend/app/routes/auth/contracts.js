import Ember from 'ember';

export default Ember.Route.extend({

  breadCrumb: null,

  model() {
    const user = this.get('sessionWrapper').get('user');
    return user.get('contracts');
  }

});

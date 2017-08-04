import Ember from 'ember';

export default Ember.Route.extend({

  breadCrumb: null,

  model() {
    return this.get('sessionWrapper')
      .loadCurrentUser()
      .then(user => user ? user.get('contracts') : []);
  }

});

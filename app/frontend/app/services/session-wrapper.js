import Ember from 'ember';

const { inject: { service }, RSVP, isEmpty } = Ember;

export default Ember.Service.extend({
  session: service('session'),
  store: service(),

  user: null,

  loadCurrentUser() {
    if (this.get('user')) {
      return RSVP.resolve(this.get('user'));
    }

    const userId = this.get('session.data.authenticated.user_id');

    if (!isEmpty(userId)) {
      return this.get('store').find('user', userId).then((user) => {
        this.set('user', user);
        return user;
      });
    } else {
      RSVP.resolve(null);
    }
  }

});

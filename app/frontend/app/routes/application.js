import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';


const { inject: { service }, isArray } = Ember;

export default Ember.Route.extend(ApplicationRouteMixin, {
  routeAfterAuthentication: 'auth.index',

  sessionWrapper: service(),

  beforeModel() {
    return this._loadCurrentUser();
  },

  sessionAuthenticated() {
    this._super(...arguments);
    this._loadCurrentUser().catch(() => this.get('session').invalidate());
  },

  _loadCurrentUser() {
    return this.get('sessionWrapper').loadCurrentUser();
  },

  actions: {
    error(error/*, transition*/) {
      if (error.isAdapterError && isArray(error.errors) && error.errors.length > 0 && error.errors[0].status === '404') {
        this.transitionTo('unknown');
      }
    }
  }

});

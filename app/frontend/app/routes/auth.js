import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {

  breadCrumb: {
    title: 'Home'
  },

  routeIfAlreadyAuthenticated: 'auth.index'
});

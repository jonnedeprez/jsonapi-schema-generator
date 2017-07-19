import Ember from 'ember';

import lookupValidator from 'ember-changeset-validations';
import { LoginValidations } from 'frontend/validations';
import Changeset from 'ember-changeset';
import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin';

const LoginData = Ember.Object.extend({
  username: '',
  password: '',
  save() {
    return this.get('session').authenticate('authenticator:jwt', {
      identification: this.get('username'),
      password: this.get('password')
    });
  },
  reset() {
    this.set('password', '');
  }
});

export default Ember.Route.extend(UnauthenticatedRouteMixin, {

  routeIfAlreadyAuthenticated: 'auth.index',

  model() {
    return LoginData.create({ session: this.get('session') });
  },

  setupController(controller, model) {
    this._super(controller, model);

    controller.setProperties({
      changeset: new Changeset(model, lookupValidator(LoginValidations), LoginValidations)
    });
  }

});

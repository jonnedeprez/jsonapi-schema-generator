import Ember from 'ember';
import Base from 'ember-simple-auth/authorizers/base';
import ENV from '../config/environment';

const { inject, assign, get, isEmpty } = Ember;

export default Base.extend({
  session: inject.service('session'),

  init() {

    let settings = {
      authorizationPrefix: 'Bearer ',
      tokenPropertyName: 'token',
      authorizationHeaderName: 'Authorization'
    };

    let config = ENV['token-auth'] || {};

    assign(settings, config);
    this.setProperties(settings);
  },

  authorize(data = {}, block = () => {}) {
    const token = get(data, this.tokenPropertyName);
    const prefix = this.authorizationPrefix ? this.authorizationPrefix : '';

    if (this.get('session.isAuthenticated') && !isEmpty(token)) {
      block(this.authorizationHeaderName, prefix + token);
    }
  }
});

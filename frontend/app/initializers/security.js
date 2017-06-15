import JWTAuthenticator from 'frontend/security/jwt-authenticator';
import TokenAuthorizer from 'frontend/security/token-authorizer';

export function initialize(application) {
  application.register('authorizer:token', TokenAuthorizer);
  application.register('authenticator:jwt', JWTAuthenticator);
}

export default {
  name: 'security',
  before: 'ember-simple-auth',
  initialize
};

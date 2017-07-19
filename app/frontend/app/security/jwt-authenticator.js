import Ember from 'ember';
import Base from 'ember-simple-auth/authenticators/base';
import ENV from '../config/environment';

const { isEmpty, run, get, assign, RSVP, debug } = Ember;

export default Base.extend({

  _refreshTokenTimeout: null,

  init() {

    let settings = {
      serverTokenEndpoint: '/api/token-auth/',
      serverTokenRefreshEndpoint: '/api/token-refresh/',
      authorizationHeaderName: 'Authorization',
      authorizationPrefix: 'Bearer ',
      refreshLeeway: 100, // in seconds
      tokenExpireName: 'exp',
      identificationField: 'username',
      passwordField: 'password',
      tokenPropertyName: 'token',
      headers: {}
    };

    let config = ENV['token-auth'] || {};
    Ember.assign(settings, config);

    this.setProperties(settings);

  },

  /**
   * Try to restore the session from the store, or try to refresh the tokens if the token is near expiry or already expired.
   */
  restore(data) {
    const dataObject = Ember.Object.create(data);

    return new RSVP.Promise((resolve, reject) => {
      const now = this.resolveTime(this.getCurrentTime());
      const token = dataObject.get(this.tokenPropertyName);
      const refreshToken = dataObject.get(this.refreshTokenPropertyName) || dataObject.get(this.tokenPropertyName);
      let expiresAt = this.resolveTime(dataObject.get(this.tokenExpireName));

      if (isEmpty(token)) {
        return reject(new Error('empty token'));
      }

      if (isEmpty(expiresAt)) {
        // Fetch the expire time from the token data since `expiresAt`
        // wasn't included in the data object that was passed in.
        const tokenData = this.getTokenData(token);

        expiresAt = this.resolveTime(tokenData[this.tokenExpireName]);
        if (isEmpty(expiresAt)) {
          return resolve(data);
        }
      }

      if (expiresAt > now) {
        let wait = expiresAt - now - (this.refreshLeeway * 1000);

        if (wait > 0) {
          this.scheduleAccessTokenRefresh(expiresAt, refreshToken);
          return resolve(data);
        } else {
          return resolve(this.refreshAccessToken(refreshToken));
        }
      } else {
        return resolve(this.refreshAccessToken(refreshToken));
      }
    }, 'JWT Authenticator | restore');
  },

  authenticate(credentials, headers) {
    return new RSVP.Promise((resolve, reject) => {
      const data = this.getAuthenticateData(credentials);

      this.makeRequest(this.serverTokenEndpoint, data, headers).done(response => {
        run(() => {
          try {
            const sessionData = this.handleAuthResponse(response);
            return resolve(sessionData);
          } catch(error) {
            return reject(error);
          }
        });
      }).fail(xhr => {
        run(() => { return reject(xhr.responseJSON || xhr.responseText); });
      });
    }, 'JWT Authenticator | authenticate');
  },

  getAuthenticateData(credentials) {
    const authentication = {
      [this.passwordField]: credentials.password,
      [this.identificationField]: credentials.identification
    };

    return authentication;
  },

  scheduleAccessTokenRefresh(expiresAt, refreshToken) {

    const now = this.getCurrentTime();
    const wait = expiresAt - now - (this.refreshLeeway * 1000);

    if (!isEmpty(refreshToken) && !isEmpty(expiresAt) && wait > 0) {
      run.cancel(this._refreshTokenTimeout);

      delete this._refreshTokenTimeout;

      debug('Scheduling token refresh in ' + wait + 'ms');

      this._refreshTokenTimeout = run.later(this, this.refreshAccessToken, refreshToken, wait);
    }
  },

  refreshAccessToken(refreshToken, headers) {
    debug('Refreshing access token');
    return new RSVP.Promise((resolve, reject) => {
      Ember.$.ajax({
        url: this.serverTokenRefreshEndpoint,
        method: 'GET',
        beforeSend: (xhr, settings) => {
          xhr.setRequestHeader('Accept', settings.accepts.json);
          xhr.setRequestHeader(this.authorizationHeaderName, this.authorizationPrefix + refreshToken);

          if (headers) {
            Object.keys(headers).forEach(key => {
              xhr.setRequestHeader(key, headers[key]);
            });
          }
        }
      }).then(response => {
        run(() => {
          try {
            const sessionData = this.handleAuthResponse(response);
            this.trigger('sessionDataUpdated', sessionData);
            return resolve(sessionData);
          } catch(error) {
            return reject(error);
          }
        });
      }, (xhr, status, error) => {
        Ember.Logger.warn(`Access token could not be refreshed - server responded with ${error}.`);
        reject();
      });

    }, 'JWT Authenticator | refreshAccessToken');
  },

  getTokenData(token) {
    const payload = token.split('.')[1];
    const tokenData = decodeURIComponent(window.escape(atob(payload)));

    try {
      return JSON.parse(tokenData);
    } catch (e) {
      return tokenData;
    }
  },

  invalidate() {
    run.cancel(this._refreshTokenTimeout);

    delete this._refreshTokenTimeout;

    return new RSVP.resolve();
  },

  makeRequest(url, data, headers) {
    return Ember.$.ajax({
      url: url,
      method: 'POST',
      data: JSON.stringify(data),
      dataType: 'json',
      contentType: 'application/json',
      beforeSend: (xhr, settings) => {
        xhr.setRequestHeader('Accept', settings.accepts.json);

        if (headers) {
          Object.keys(headers).forEach(key => {
            xhr.setRequestHeader(key, headers[key]);
          });
        }
      }
    });
  },

  getCurrentTime() {
    return (new Date()).getTime(); // return milliseconds
  },

  resolveTime(time) {
    if (isEmpty(time)) {
      return time;
    }
    return new Date(time).getTime();
  },

  handleAuthResponse(response) {
    const token = get(response, this.tokenPropertyName);
    const refreshToken = get(response, this.refreshTokenPropertyName);

    if(isEmpty(token)) {
      throw new Error('Token is empty. Please check your backend response.');
    }

    const tokenData = this.getTokenData(token);
    const expiresAt = get(tokenData, this.tokenExpireName);
    const tokenExpireData = {};

    tokenExpireData[this.tokenExpireName] = expiresAt;

    this.scheduleAccessTokenRefresh(expiresAt, refreshToken);

    return assign(response, tokenExpireData);
  }
});

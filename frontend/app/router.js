import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('auth', function() {
    this.route('contracts', function() {
      this.route('new');
      this.route('contract', { path: '/:contract_id' }, function() {
        this.route('entities', function() {
          this.route('entity', { path: '/:entity_id' });
        });
        this.route('actions', function() {
          this.route('action', { path: '/:action_id' });
        });
      });
    });
  });

  this.route('login');
});

export default Router;

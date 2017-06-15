import Ember from 'ember';

const { inject } = Ember;

export default Ember.Route.extend({

  secondaryNavigation: inject.service(),

  activate() {
    this._super(arguments);
    this.get('secondaryNavigation').set('activeTab', 'domainModel');
  }

});

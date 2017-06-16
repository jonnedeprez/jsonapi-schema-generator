import Ember from 'ember';

const { inject } = Ember;

export default Ember.Route.extend({

  breadCrumb: {
    title: 'Domain model'
  },

  secondaryNavigation: inject.service(),

  activate() {
    this._super(arguments);
    this.get('secondaryNavigation').set('activeTab', 'domainModel');
  }

});

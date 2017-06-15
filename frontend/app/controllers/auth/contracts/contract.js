import Ember from 'ember';

const { inject, computed } = Ember;

export default Ember.Controller.extend({

  secondaryNavigation: inject.service(),

  activeTab: computed.alias('secondaryNavigation.activeTab')

});

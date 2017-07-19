import Ember from 'ember';

import lookupValidator from 'ember-changeset-validations';
import { ContractValidations } from 'frontend/validations';
import Changeset from 'ember-changeset';

export default Ember.Route.extend({

  breadCrumb: {
    title: 'New service contract'
  },

  model() {
    let user = this.get('sessionWrapper').get('user');
    return this.get('store').createRecord('contract', { user });
  },

  setupController(controller, model) {
    this._super(controller, model);

    controller.setProperties({
      changeset: new Changeset(model, lookupValidator(ContractValidations), ContractValidations)
    });
  },

  deactivate() {
    let model = this.get('controller').get('model');
    if (model.get('isNew') && !model.get('isSaving')) {
      model.deleteRecord();
    }
  }

});

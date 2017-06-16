import Ember from 'ember';
import { FieldValidations } from 'frontend/validations';

import { task } from 'ember-concurrency';

const { debug } = Ember;

export default Ember.Controller.extend({

  FieldValidations,

  required: true,

  safeUpdateRecord: task(function * (record) {
    try{
      if (record.get('hasDirtyAttributes')) {
        yield record.save();
      }
    } catch(e) {
      debug('Failed to update record: ' + JSON.stringify(e));
    }
  }).keepLatest(),

  actions: {
    updateRecord(record) {
      this.get('safeUpdateRecord').perform(record);
    }
  }

});

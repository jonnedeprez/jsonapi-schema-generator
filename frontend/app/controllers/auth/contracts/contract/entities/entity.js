import Ember from 'ember';
import { FieldValidations, RelationshipValidations } from 'frontend/validations';

import { task } from 'ember-concurrency';

const { debug } = Ember;

export default Ember.Controller.extend({

  FieldValidations,
  RelationshipValidations,

  cardinalityOptions: [{ value: 'HAS_MANY', name: 'Has many' }, { value: 'BELONGS_TO', name: 'Belongs to' }],

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
    },
    submit(changeset) {
      changeset.validate().then(() => {
        if (changeset.get('isValid')) {
          changeset.save();
        } else {
          changeset.rollback();
        }
      })
    }
  },



});

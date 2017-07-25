import Ember from 'ember';
import { EntityValidations, FieldValidations, RelationshipValidations } from 'frontend/validations';

import { task } from 'ember-concurrency';

const { debug, RSVP } = Ember;

const NewField = Ember.Object.extend({
  save() {
    const newField = this.get('store').createRecord('field', this.getProperties('name', 'fieldType', 'required', 'entity'));
    return newField.save();
  }
});

const NewRelationship = Ember.Object.extend({
  save() {
    const newRelationship = this.get('store').createRecord('relationship', this.getProperties('required', 'entity', 'dependentEntity'));
    return newRelationship.save();
  }
});

export default Ember.Controller.extend({

  EntityValidations,
  FieldValidations,
  RelationshipValidations,

  cardinalityOptions: [{ value: 'HAS_MANY', name: 'Has many' }, { value: 'BELONGS_TO', name: 'Belongs to' }],

  required: true,

  isEditingName: false,

  safeUpdateRecord: task(function * (record) {
    try{
      if (record.get('hasDirtyAttributes')) {
        yield record.save();
      }
    } catch(e) {
      debug('Failed to update record: ' + JSON.stringify(e));
    }
  }).keepLatest(),

  resetNewField() {
    this.set('newField', NewField.create({
      name: '', type: '', required: false, entity: this.get('model'), store: this.get('store')
    }));
  },

  resetNewRelationship() {
    this.set('newRelationship', NewRelationship.create({
      required: false, entity: this.get('model'), store: this.get('store'), dependentEntity: null
    }));
  },

  actions: {
    editName() {

    },

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
    },

    removeRelationship(relationship) {
      return relationship.destroyRecord();
    },

    removeField(field) {
      return field.destroyRecord();
    },

    submitNewField(changeset) {
      changeset.validate().then(() => {
        return changeset.get('isValid') ? changeset.save() : RSVP.resolve(false);
      }).then(savedField => {
        if (savedField) {
          this.resetNewField();
        }
      });
    },

    submitNewRelationship(changeset) {
      changeset.validate().then(() => {
        return changeset.get('isValid') ? changeset.save() : RSVP.resolve(false);
      }).then(savedRelationship => {
        if (savedRelationship) {
          this.resetNewRelationship();
        }
      });
    }
  }

});

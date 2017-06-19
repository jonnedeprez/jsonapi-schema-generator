import Ember from 'ember';
import DS from 'ember-data';

const { computed } = Ember;

export default DS.Model.extend({

  required: DS.attr('boolean'),

  cardinality: DS.attr('string'),

  entity: DS.belongsTo('entity', { inverse: 'relationships' }),
  dependentEntity: DS.belongsTo('entity', { inverse: 'sourceRelationships' }),

  dependentEntityLoaded: computed('dependentEntity.name', function() {
    let dependentEntity = this.belongsTo('dependentEntity').value();
    return dependentEntity !== null;
  })

});

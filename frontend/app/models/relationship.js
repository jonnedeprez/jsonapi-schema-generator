import DS from 'ember-data';

export default DS.Model.extend({

  required: DS.attr('boolean'),

  cardinality: DS.attr('string'),

  entity: DS.belongsTo('entity', { inverse: 'relationships' }),
  dependentEntity: DS.belongsTo('entity', { inverse: 'sourceRelationships' }),

});

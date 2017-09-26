import Ember from 'ember';
import DS from 'ember-data';

const { computed } = Ember;

export default DS.Model.extend({

  name: DS.attr('string'),
  description: DS.attr('string'),

  contract: DS.belongsTo('contract'),
  fields: DS.hasMany('field'),
  actions: DS.hasMany('action', { inverse: 'entity' }),
  relationships: DS.hasMany('relationship', { inverse: 'entity', async: false }),
  sourceRelationships: DS.hasMany('relationship', { inverse: 'dependentEntity' }),

  includedInActions: DS.hasMany('action', { inverse: 'includedEntities' }),

  belongsToRelationships: computed.filterBy('relationships', 'cardinality', 'BELONGS_TO'),
  belongsToEntities: computed.mapBy('belongsToRelationships', 'dependentEntity'),
  hasManyRelationships: computed.filterBy('relationships', 'cardinality', 'HAS_MANY'),
  hasManyEntities: computed.mapBy('hasManyRelationships', 'dependentEntity'),

});

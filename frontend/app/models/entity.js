import Ember from 'ember';
import DS from 'ember-data';

const { computed } = Ember;

export default DS.Model.extend({

  name: DS.attr('string'),
  description: DS.attr('string'),

  contract: DS.belongsTo('contract'),
  fields: DS.hasMany('field'),
  actions: DS.hasMany('action'),
  relationships: DS.hasMany('relationship', { inverse: 'entity', async: false }),
  sourceRelationships: DS.hasMany('relationship', { inverse: 'dependentEntity' }),

  belongsToRelationShips: computed.filterBy('relationships', 'cardinality', 'BELONGS_TO'),
  belongsToEntities: computed.mapBy('belongsToRelationShips', 'dependentEntity'),
  hasManyRelationShips: computed.filterBy('relationships', 'cardinality', 'HAS_MANY'),
  hasManyEntities: computed.mapBy('hasManyRelationShips', 'dependentEntity'),

});

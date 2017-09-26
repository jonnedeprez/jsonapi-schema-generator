import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  requestType: DS.attr('string'),

  entity: DS.belongsTo('entity', { inverse: 'actions' }),
  contract: DS.belongsTo('contract'),
  includedEntities: DS.hasMany('entity', { inverse: 'includedInActions', async: false })

});

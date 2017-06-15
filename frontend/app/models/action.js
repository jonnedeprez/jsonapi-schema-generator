import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  contract: DS.belongsTo('contract'),
  requestType: DS.attr('string'),

  entity: DS.belongsTo('entity'),

});

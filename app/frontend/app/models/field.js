import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  fieldType: DS.attr('string'),
  required: DS.attr('boolean'),

  entity: DS.belongsTo('entity')

});

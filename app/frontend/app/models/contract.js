import DS from 'ember-data';

export default DS.Model.extend({
  client: DS.attr('string'),
  server: DS.attr('string'),
  description: DS.attr('string'),

  user: DS.belongsTo('user'),
  actions: DS.hasMany('action'),
  entities: DS.hasMany('entity')
});

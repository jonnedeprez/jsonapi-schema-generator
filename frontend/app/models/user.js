import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  username: DS.attr('string'),
  password: DS.attr('string'),
  admin: DS.attr('boolean'),
  contracts: DS.hasMany('contract')
});

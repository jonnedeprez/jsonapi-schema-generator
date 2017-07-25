import ApplicationSerializer from './application';

export default ApplicationSerializer.extend({

  include: ['dependentEntity', 'dependentEntity.relationships']

});

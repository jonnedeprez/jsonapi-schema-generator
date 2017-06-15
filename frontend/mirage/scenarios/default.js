export default function(server) {

  /*
    Seed your development database using your factories.
    This data will not be loaded in your tests.

    Make sure to define a factory for each model you want to create.
  */

  // server.createList('post', 10);

  const adminUser = server.create('user', { name: 'Admin', username: 'admin', password: 'admin', admin: true });

  const contract = server.create('contract', { client: 'Frontend', server: 'Backend', user: adminUser });
  server.createList('contract', 3, { user: adminUser });

  const siteEntity  = server.create('entity', { name: 'Site', contract });
  const plantEntity = server.create('entity', { name: 'Plant', contract });
  const unitEntity  = server.create('entity', { name: 'Unit', contract });
  const accountEntity = server.create('entity', { name: 'Account', contract });

  server.create('action', { name: 'Read record', requestType: 'GET', contract, entity: accountEntity });
  server.create('action', { name: 'Read array', requestType: 'GET', contract, entity: accountEntity });

  server.create('field', { name: 'name', required: true, entity: accountEntity });
  server.create('field', { name: 'name', required: true, entity: siteEntity });
  server.create('field', { name: 'name', required: true, entity: plantEntity });
  server.create('field', { name: 'name', required: true, entity: unitEntity });

  server.create('relationship', { required: true, cardinality: 'BELONGS_TO', entity: plantEntity, dependentEntity: siteEntity });
  server.create('relationship', { required: true, cardinality: 'HAS_MANY', entity: accountEntity, dependentEntity: siteEntity });
  server.create('relationship', { required: true, cardinality: 'HAS_MANY', entity: siteEntity, dependentEntity: accountEntity });
  server.create('relationship', { required: true, cardinality: 'HAS_MANY', entity: siteEntity, dependentEntity: plantEntity });
  server.create('relationship', { required: true, cardinality: 'HAS_MANY', entity: plantEntity, dependentEntity: unitEntity });
  server.create('relationship', { required: true, cardinality: 'BELONGS_TO', entity: unitEntity, dependentEntity: plantEntity });

}

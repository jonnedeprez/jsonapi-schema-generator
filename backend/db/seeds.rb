# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(name: 'Admin', username: 'admin', password: 'admin', admin: true)

contract = Contract.create(client: 'Frontend', server: 'Backend', user: user)

account_entity = Entity.create(name: 'Account', contract: contract)
site_entity    = Entity.create(name: 'Site',    contract: contract)
plant_entity   = Entity.create(name: 'Plant',   contract: contract)
unit_entity    = Entity.create(name: 'Unit',    contract: contract)
service_event_entity = Entity.create(name: 'ServiceEvent',    contract: contract)


Action.create(name: 'Read single account', request_type: 'get_single',     contract: contract, entity: account_entity)
Action.create(name: 'Read account array',  request_type: 'get_collection', contract: contract, entity: account_entity)
Action.create(name: 'Read single ServiceEvent', request_type: 'get_single',     contract: contract, entity: service_event_entity)

Field.create(name: 'name',        required: true, entity: account_entity)
Field.create(name: 'created-at',  required: false, entity: account_entity)
Field.create(name: 'updated-at',  required: false, entity: account_entity)
Field.create(name: 'name', required: true, entity: site_entity)
Field.create(name: 'name', required: true, entity: plant_entity)
Field.create(name: 'name', required: true, entity: unit_entity)
Field.create(name: 'name', required: true, entity: service_event_entity)

Relationship.create(required: true, cardinality: 'BELONGS_TO', entity: plant_entity,   dependent_entity: site_entity)
Relationship.create(required: true, cardinality: 'HAS_MANY',   entity: account_entity, dependent_entity: site_entity)
Relationship.create(required: true, cardinality: 'HAS_MANY',   entity: site_entity,    dependent_entity: account_entity)
Relationship.create(required: true, cardinality: 'HAS_MANY',   entity: site_entity,    dependent_entity: plant_entity)
Relationship.create(required: true, cardinality: 'HAS_MANY',   entity: plant_entity,   dependent_entity: unit_entity)
Relationship.create(required: true, cardinality: 'BELONGS_TO', entity: unit_entity,    dependent_entity: plant_entity)
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(name: 'Admin', username: 'admin', password: 'admin', admin: true)

siemens_contract = Contract.create(client: 'Siemens Frontend', server: 'Siemens Backend', user: user)

account_entity       = Entity.create(name: 'Account', contract: siemens_contract)
site_entity          = Entity.create(name: 'Site',    contract: siemens_contract)
plant_entity         = Entity.create(name: 'Plant',   contract: siemens_contract)
unit_entity          = Entity.create(name: 'Unit',    contract: siemens_contract)
service_event_entity = Entity.create(name: 'ServiceEvent',    contract: siemens_contract)

Action.create(name: 'Read single account', request_type: 'get_single',     contract: siemens_contract, entity: account_entity)
Action.create(name: 'Read account array',  request_type: 'get_collection', contract: siemens_contract, entity: account_entity)
site_action = Action.create(name: 'Read a site',         request_type: 'get_single',     contract: siemens_contract, entity: site_entity)
site_action.included_entities << plant_entity
site_action.save

Action.create(name: 'Read single ServiceEvent', request_type: 'get_single',     contract: siemens_contract, entity: service_event_entity)

Field.create(name: 'name',        required: true, entity: account_entity)
Field.create(name: 'created-at',  required: false, entity: account_entity)
Field.create(name: 'updated-at',  required: false, entity: account_entity)
Field.create(name: 'name', required: true, entity: site_entity)
Field.create(name: 'name', required: true, entity: plant_entity)
Field.create(name: 'name', required: true, entity: unit_entity)
Field.create(name: 'name', required: true, entity: service_event_entity)

Relationship.create(required: true,  cardinality: 'BELONGS_TO', entity: plant_entity,   dependent_entity: site_entity)
Relationship.create(required: false, cardinality: 'HAS_MANY',   entity: account_entity, dependent_entity: site_entity)
Relationship.create(required: false, cardinality: 'HAS_MANY',   entity: site_entity,    dependent_entity: account_entity)
Relationship.create(required: false, cardinality: 'HAS_MANY',   entity: site_entity,    dependent_entity: plant_entity)
Relationship.create(required: false, cardinality: 'HAS_MANY',   entity: plant_entity,   dependent_entity: unit_entity)
Relationship.create(required: true,  cardinality: 'BELONGS_TO', entity: unit_entity,    dependent_entity: plant_entity)

own_contract = Contract.create(client: 'Own Frontend', server: 'Own Backend', user: user)

action_entity = Entity.create(name: 'Action', contract: own_contract)
contract_entity = Entity.create(name: 'Contract', contract: own_contract)
entity_entity = Entity.create(name: 'Entity', contract: own_contract)
field_entity = Entity.create(name: 'Field', contract: own_contract)
relationship_entity = Entity.create(name: 'Relationship', contract: own_contract)
user_entity = Entity.create(name: 'User', contract: own_contract)

Field.create(name: 'name',          required: true,  entity: action_entity)
Field.create(name: 'request-type',  required: true,  entity: action_entity)
Field.create(name: 'client',        required: true,  entity: contract_entity)
Field.create(name: 'server',        required: true,  entity: contract_entity)
Field.create(name: 'description',   required: false, entity: contract_entity)
Field.create(name: 'name',          required: true,  entity: entity_entity)
Field.create(name: 'description',   required: false, entity: entity_entity)
Field.create(name: 'name',          required: true,  entity: field_entity)
Field.create(name: 'field-type',    required: true,  entity: field_entity)
Field.create(name: 'required',      required: false, entity: field_entity, field_type: 'boolean')
Field.create(name: 'name',          required: false, entity: relationship_entity)
Field.create(name: 'cardinality',   required: true,  entity: relationship_entity)
Field.create(name: 'required',      required: false, entity: relationship_entity, field_type: 'boolean')
Field.create(name: 'name',          required: false, entity: user_entity)
Field.create(name: 'username',      required: true,  entity: user_entity)

Relationship.create(required: true,   cardinality: 'BELONGS_TO', entity: action_entity,   dependent_entity: contract_entity)
Relationship.create(required: true,   cardinality: 'BELONGS_TO', entity: action_entity,   dependent_entity: entity_entity)
Relationship.create(required: false,  cardinality: 'HAS_MANY',   entity: action_entity,   dependent_entity: entity_entity, name: 'included-entities')
Relationship.create(required: true,   cardinality: 'BELONGS_TO', entity: contract_entity, dependent_entity: user_entity)
Relationship.create(required: true,   cardinality: 'BELONGS_TO', entity: entity_entity,   dependent_entity: contract_entity)
Relationship.create(required: true,   cardinality: 'BELONGS_TO', entity: field_entity,    dependent_entity: entity_entity)
Relationship.create(required: true,   cardinality: 'BELONGS_TO', entity: relationship_entity, dependent_entity: entity_entity)
Relationship.create(required: true,   cardinality: 'BELONGS_TO', entity: relationship_entity, dependent_entity: entity_entity, name: 'dependent-entity')
Relationship.create(required: false,  cardinality: 'HAS_MANY',   entity: user_entity,     dependent_entity: contract_entity)
Relationship.create(required: false,  cardinality: 'HAS_MANY',   entity: contract_entity, dependent_entity: action_entity)
Relationship.create(required: false,  cardinality: 'HAS_MANY',   entity: contract_entity, dependent_entity: entity_entity)
Relationship.create(required: false,  cardinality: 'HAS_MANY',   entity: entity_entity,   dependent_entity: field_entity)
Relationship.create(required: false,  cardinality: 'HAS_MANY',   entity: entity_entity,   dependent_entity: action_entity)
Relationship.create(required: false,  cardinality: 'HAS_MANY',   entity: entity_entity,   dependent_entity: relationship_entity, name: 'source-relationships')
Relationship.create(required: false,  cardinality: 'HAS_MANY',   entity: entity_entity,   dependent_entity: action_entity, name: 'included-in-actions')

read_entity_action = Action.create(name: 'Read single entity', request_type: 'get_single',  contract: own_contract, entity: entity_entity)

read_entity_action.included_entities << relationship_entity
read_entity_action.save
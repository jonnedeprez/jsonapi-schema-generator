import { validatePresence } from 'ember-changeset-validations/validators';

const LoginValidations = {
  username: validatePresence({ presence: true, message: '{description} should not be blank' }),
  password: validatePresence({ presence: true, message: '{description} should not be blank' })
};

const ContractValidations = {
  client: validatePresence({ presence: true, message: '{description} should not be blank' }),
  server: validatePresence({ presence: true, message: '{description} should not be blank' })
};

const EntityValidations = {
  name: validatePresence({ presence: true, message: '{description} should not be blank' })
};

const FieldValidations = {
  name: validatePresence({ presence: true, message: '{description} should not be blank' }),
  fieldType: validatePresence({ presence: true, message: '{description} should not be blank' })
};

const RelationshipValidations = {
  cardinality: validatePresence({ presence: true, message: '{description} should not be blank' }),
  entity: validatePresence({ presence: true, message: '{description} should not be blank' }),
  dependentEntity: validatePresence({ presence: true, message: '{description} should not be blank' })
};

const ActionValidations = {
  contract: validatePresence({ presence: true, message: '{description} should not be blank' }),
  entity: validatePresence({ presence: true, message: '{description} should not be blank' }),
  name: validatePresence({ presence: true, message: '{description} should not be blank' }),
  requestType: validatePresence({ presence: true, message: '{description} should not be blank' })
};

export { LoginValidations, ContractValidations, EntityValidations, FieldValidations, RelationshipValidations,
  ActionValidations };

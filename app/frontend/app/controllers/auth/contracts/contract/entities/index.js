import Ember from 'ember';

const { debug, inject, computed: { oneWay }, RSVP: { all, hash } } = Ember;

export default Ember.Controller.extend({

  contractController: inject.controller('auth.contracts.contract'),
  contract: oneWay('contractController.model'),

  actions: {
    addEntity() {
      const contract = this.get('contract');
      this.get('store')
        .createRecord('entity', { name: 'RenameMe', contract })
        .save()
        .then(entity => {
          this.transitionToRoute('auth.contracts.contract.entities.entity', entity);
        })
    },

    removeEntity(entity) {
      debug('called action removeEntity for ' + entity.get('name'));

      hash({
        removeRelationships: all(
          entity.get('relationships').map(relationship => relationship.destroyRecord())
        ),
        removeActions: all(
          entity.get('actions').then(actions => actions.map(action => action.destroyRecord()))
        ),
        removeFields: all(
          entity.get('fields').then(fields => fields.map(field => field.destroyRecord()))
        )
      }).then(() => entity.destroyRecord()).catch(
        error => debug('Failed to delete a record: ' + JSON.stringify(error))
      );
    }
  }
});

import Ember from 'ember';

const { debug, isArray } = Ember;

export default Ember.Controller.extend({
  actions: {
    submit(changeset) {
      changeset.validate().then(() => {
        if (changeset.get('isValid')) {
          changeset.save()
            .then(() => this.transitionToRoute('auth.contracts.index'))
            .catch((errorResponse) => {
              const model = this.get('model');
              debug(`save failed: ${JSON.stringify(errorResponse)}`);
              model.rollback();

              if (isArray(errorResponse.errors)) {
                errorResponse.errors.forEach((error) => {
                  if (error.hasOwnProperty('meta') && error.meta.hasOwnProperty('key')) {
                    changeset.addError(error.meta.key, error.meta.message);
                  }
                });
              }
            });
        }
      });
    }
  }
});

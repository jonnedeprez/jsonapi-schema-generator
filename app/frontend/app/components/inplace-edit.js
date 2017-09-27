import Ember from 'ember';

const { observer, run } = Ember;

export default Ember.Component.extend({

  classNames: ['inplace-edit', 'd-inline-block'],

  isEditing: false,

  value: null,

  internalValue: null,

  isEditingChanged: observer('isEditing', function() {
    if (this.get('isEditing')) {
      run.scheduleOnce('render', () => {
        this.$('.form-control').get(0).select();
      });
    }
  }),

  actions: {
    save() {
      this.set('isEditing', false);
      if (this.get('value') !== this.get('internalValue')) {
        this.set('value', this.get('internalValue'));
        this.sendAction('save');
      }
    },


  },

  didReceiveAttrs() {
    this.set('internalValue', this.get('value'));
  }

});

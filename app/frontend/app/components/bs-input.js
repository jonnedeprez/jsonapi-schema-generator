import Ember from 'ember';
import { guid } from '../utils';

const { computed } = Ember;

export default Ember.Component.extend({

  classNames: ['form-group'],
  classNameBindings: ['hasDanger:has-danger', 'horizontal:row'],

  horizontal: true,

  hasDanger: false,

  changeset: null,
  fieldName: 'someField',
  textarea: false,
  password: false,
  showPassword: false,

  idInput: computed(function () {
    return 'input-' + guid();
  }),

  _setHasDanger() {
    this.set('hasDanger', !!this.get('changeset.error.' + this.get('fieldName')));
  },

  init() {
    this._super(...arguments);
    this.addObserver('changeset.error.' + this.get('fieldName'), this, '_setHasDanger');
  },

  willDestroyElement() {
    this._super(...arguments);
    this.removeObserver('changeset.error.' + this.get('fieldName'), this, '_setHasDanger');
  }

});


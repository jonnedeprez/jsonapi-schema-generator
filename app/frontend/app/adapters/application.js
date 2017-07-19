import DS from 'ember-data';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';

export default DS.JSONAPIAdapter.extend(DataAdapterMixin, {
  namespace: 'api',

  authorizer: 'authorizer:token',

  findHasMany: function(store, snapshot, url, relationship) {
    let modifiedUrl = url;
    if (url.endsWith('entities')) {
      modifiedUrl += '?include=relationships';
    }
    return this._super(store, snapshot, modifiedUrl, relationship);
  },

  findRecord(store, type, id, snapshot) {
    let url = this.buildURL(type.modelName, id, snapshot, 'findRecord');
    let query = this.buildQuery(snapshot);

    if (type.modelName === 'entity') {
      query.include = 'relationships';
    }

    return this.ajax(url, 'GET', { data: query });
  }


});

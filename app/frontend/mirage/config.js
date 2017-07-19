import Mirage from 'ember-cli-mirage';

import { createFakeToken } from 'frontend/utils';

const { Response } = Mirage;


export default function() {

  this.passthrough('/write-coverage');

  // These comments are here to help you get started. Feel free to delete them.

  /*
    Config (with defaults).

    Note: these only affect routes defined *after* them!
  */

  // this.urlPrefix = '';    // make this `http://localhost:8080`, for example, if your API is on a different server
  // this.namespace = '';    // make this `/api`, for example, if your API is namespaced
  this.timing = 20;      // delay for each request, automatically set to 0 during testing

  /*
    Shorthand cheatsheet:

    this.get('/posts');
    this.post('/posts');
    this.get('/posts/:id');
    this.put('/posts/:id'); // or this.patch
    this.del('/posts/:id');

    http://www.ember-cli-mirage.com/docs/v0.3.x/shorthands/
  */

  this.post('/auth/login', ({ users }, request) => {
    let params = JSON.parse(request.requestBody);
    let user = users.findBy(params);

    if (user) {
      return {
        access_token: createFakeToken({ user_id: user.id }),
        refresh_token: createFakeToken({ user_id: user.id, refresh: true }),
        user_id: user.id,
      };
    } else {
      return new Response(401, {/* headers */}, { errors: [{ meta: { key: 'password', message: 'Invalid password' }}]});
    }
  });

  this.get('/auth/refresh', (schema, request) => {
    let authorizationHeader = request.requestHeaders['Authorization'];
    let refreshToken = authorizationHeader.split('.')[1];
    let payload = JSON.parse(window.atob(refreshToken));
    return {
      accessToken: createFakeToken({user_id: payload.user_id}),
      refreshToken: createFakeToken({user_id: payload.user_id, refresh: true}),
      user_id: payload.user_id,
    };
  });

  this.get('/users');
  this.get('/users/:id');

  this.get('/contracts');
  this.post('/contracts');
  this.get('/contracts/:id');
  this.patch('/contracts/:id');
  this.delete('/contracts/:id');

  this.get('/entities');
  this.post('/entities');
  this.get('/entities/:id');
  this.patch('/entities/:id');
  this.delete('/entities/:id');

  this.get('/actions');
  this.post('/actions');
  this.get('/actions/:id');
  this.patch('/actions/:id');
  this.delete('/actions/:id');

  this.get('/fields');
  this.post('/fields');
  this.get('/fields/:id');
  this.patch('/fields/:id');
  this.delete('/fields/:id');

  this.get('/relationships');
  this.post('/relationships');
  this.get('/relationships/:id');
  this.patch('/relationships/:id');
  this.delete('/relationships/:id');



}

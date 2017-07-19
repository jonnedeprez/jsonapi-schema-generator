import { Factory, faker } from 'ember-cli-mirage';

export default Factory.extend({
  client() {
    return faker.lorem.word();
  },
  server() {
    return faker.lorem.word();
  }
});

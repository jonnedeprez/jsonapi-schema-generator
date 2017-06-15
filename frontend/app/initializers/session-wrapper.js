export function initialize(application) {
  application.inject('controller', 'sessionWrapper', 'service:session-wrapper');
  application.inject('route', 'sessionWrapper', 'service:session-wrapper');
}

export default {
  name: 'session-wrapper',
  initialize
};

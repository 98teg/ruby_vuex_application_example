import template from './index.pug';

export default Vue.extend({
  template: template(),
  data() {
    return {
      users: [
        {name: 'user1', email: 'user1@email.com'},
        {name: 'user2', email: 'user2@email.com'}
      ]
    };
  }
});

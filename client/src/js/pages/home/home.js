import PostListComponent from 'js/components/posts_list/posts_list.js';
import LogInComponent from 'js/components/log_in/log_in.js';

import template from './home.pug';

Vue.component('postslist-component', PostListComponent);
Vue.component('login-component', LogInComponent);

export default Vue.extend({
  template: template(),
  components: {
    PostListComponent,
    LogInComponent
  },
  data() {
    return {
    };
  },
  methods: {
  }
});

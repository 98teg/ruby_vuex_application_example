import PostListComponent from 'js/components/posts_list/index.js';
import LogInComponent from 'js/components/log_in/index.js';

import template from './index.pug';

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

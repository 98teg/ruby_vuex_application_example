import PostListComponent from 'js/components/posts_list/posts_list.js';

import template from './home.pug';

Vue.component('postslist-component', PostListComponent);

export default Vue.extend({
  template: template(),
  components: {
    PostListComponent
  },
  data() {
    return {
    };
  },
  methods: {
  }
});

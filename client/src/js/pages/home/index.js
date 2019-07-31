import PostListComponent from 'js/components/posts_list/index.js';

import template from './index.pug';

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

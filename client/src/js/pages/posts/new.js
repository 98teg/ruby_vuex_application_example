import Form from './_form.js';

import template from './new.pug';

Vue.component('form-component', Form);

export default Vue.extend({
  template: template(),
  components: {
    Form
  },
  data() {
    return {
    };
  },
  methods: {
    async createPost() {
      try {
        await API.posts.create({},
          {params: {data: {title: this.$children[0].title, content: this.$children[0].content}}});
      } catch (error) {
        this.error = 'Error';
      }
    }
  }
});

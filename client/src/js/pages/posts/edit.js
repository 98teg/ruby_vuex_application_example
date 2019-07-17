import Form from './_form.js';

import template from './edit.pug';

Vue.component('form-component', Form);

export default Vue.extend({
  template: template(),
  components: {
    Form
  },
  props: {
    id: String
  },
  data() {
    return {
    };
  },
  async created() {
    const post = await API.posts.show(this.id);

    this.$children[0].title = post.title;
    this.$children[0].content = post.content;
  },
  methods: {
    async savePost() {
      try {
        await API.posts.update(this.id, {},
          {params: {data: {title: this.$children[0].title, content: this.$children[0].content}}});
        this.$router.push({name: 'my posts'});
      } catch (error) {
        console.log(error);
        this.error = 'Error';
      }
    }
  }
});

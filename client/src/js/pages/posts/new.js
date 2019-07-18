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
        const formData = new FormData();

        formData.append('data[title]', this.$children[0].title);
        formData.append('data[content]', this.$children[0].content);
        formData.append('data[image]', this.$children[0].image);

        await API.posts.create(formData);
        this.$router.push({name: 'my posts'});
      } catch (error) {
        if (error.body.title != null) {
          this.$children[0].wrongTitle = true;
          this.$children[0].titleErrors = error.body.title;
        } else {
          this.$children[0].wrongTitle = false;
          this.$children[0].titleErrors = null;
        }

        if (error.body.content != null) {
          this.$children[0].wrongContent = true;
          this.$children[0].contentErrors = error.body.content;
        } else {
          this.$children[0].wrongContent = false;
          this.$children[0].contentErrors = null;
        }
      }
    }
  }
});

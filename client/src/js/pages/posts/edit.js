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
    if (localStorage.getItem('token') == null) {
      this.$router.push({name: 'home'});
    } else {
      const post = await API.posts.show(this.id);

      this.$children[0].title = post.title;
      this.$children[0].content = post.content;
      this.$children[0].image = post.image;
    }
  },
  updated() {
    if (localStorage.getItem('token') == null) {
      this.$router.push({name: 'home'});
    }
  },
  methods: {
    async savePost() {
      try {
        const formData = new FormData();

        formData.append('data[title]', this.$children[0].title);
        formData.append('data[content]', this.$children[0].content);
        if (this.$children[0].image != null) {
          formData.append('data[image]', this.$children[0].image);
        }

        await API.posts.update(this.id, formData);
        this.$router.push({name: 'myPosts'});
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

import template from './show.pug';

export default Vue.extend({
  template: template(),
  props: {
    id: String
  },
  data() {
    return {
      post: '',
      hasImage: false
    };
  },
  async created() {
    this.post = await API.posts.show(this.id);
    this.hasImage = this.post.image.url === '';
  },
  methods: {
  }
});

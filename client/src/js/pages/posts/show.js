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
    if (this.post.image.url != null) this.hasImage = true;
  },
  methods: {
  }
});

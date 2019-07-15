import template from './index.pug';

export default Vue.extend({
  template: template(),
  data() {
    return {
      posts: []
    };
  },
  methods: {
    async orderByTitle() {
      const {data} = await API.posts.index({}, {params: {sort: 'title'}});
    
      this.posts = data;
    },
    async orderByDate() {
      const {data} = await API.posts.index({}, {params: {sort: '-created_at'}});
    
      this.posts = data;
    },
    async orderByAuthor() {
      const {data} = await API.posts.index({}, {params: {sort: 'user_name'}});
    
      this.posts = data;
    }
  },
  async created() {
    const {data} = await API.posts.index();
    
    this.posts = data;
  }
});

import jwt_decode from 'jwt-decode';
import template from './index.pug';

export default Vue.extend({
  template: template(),
  data() {
    return {
      posts: []
    };
  },
  async created() {
    this.getPosts();
  },
  methods: {
    async getPosts(options = {}) {
      const {user_id} = jwt_decode(localStorage.getItem('token'));
      const {data} = await API.posts.index({},
        Object.assign({}, {params: {filter: {user_id}}}, options));

      this.posts = data;
    },

    async orderByTitle() {
      this.getPosts({params: {sort: 'title'}});
    },

    async orderByDate() {
      this.getPosts({params: {sort: '-created_at'}});
    },
    
    async DeletePost(id) {
      if (confirm('¿Realmente quiere eliminar este post?')) {
        await API.posts.destroy(id);

        this.getPosts();
      }
    }
  }
});

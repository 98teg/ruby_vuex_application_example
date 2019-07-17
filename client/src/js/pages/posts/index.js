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
    const {user_id} = jwt_decode(localStorage.getItem('token'));
    const {data} = await API.posts.index({}, {params: {filter: {user_id}}});

    this.posts = data;
  },
  methods: {
    async orderByTitle() {
      const {user_id} = jwt_decode(localStorage.getItem('token'));
      const {data} = await API.posts.index({}, {params: {sort: 'title', filter: {user_id}}});

      this.posts = data;
    },
    async orderByDate() {
      const {user_id} = jwt_decode(localStorage.getItem('token'));
      const {data} = await API.posts.index({}, {params: {sort: '-created_at', filter: {user_id}}});

      this.posts = data;
    }
  }
});

import template from './index.pug';

export default Vue.extend({
  template: template(),
  data() {
    return {
      posts: []
    };
  },
  async created() {
    const user = await API.users
      .index({}, {params: {filter: {email: window.localStorage.getItem('email')}}});
    const {data} = await API.posts.index({}, {params: {filter: {user_id: user.data[0].id}}});

    this.posts = data;
  },
  methods: {
    async orderByTitle() {
      const {data} = await API.posts.index({}, {params: {sort: 'title'}});

      this.posts = data;
    },
    async orderByDate() {
      const {data} = await API.posts.index({}, {params: {sort: '-created_at'}});

      this.posts = data;
    }
  }
});

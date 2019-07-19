import Vuex from 'vuex';
import jwt_decode from 'jwt-decode';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    user: null
  },
  mutations: {
    set_user(state, payload) {
      state.user = payload.user;
      console.log(state.user);
    }
  },
  actions: {
    async set_current_user(context) {
      const {user_id} = jwt_decode(localStorage.getItem('token'));
      const user = await API.users.show(user_id);
      context.commit({
        type: 'set_user',
        user
      });
    }
  },
  getters: {
    current_user: state => {
      return state.user;
    },
    user_name: (state, getters) => {
      if (getters.current_user != null) return getters.current_user.name;
      return '';
    }
  }
});

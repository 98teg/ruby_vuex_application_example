import VueResource from 'vue-resource';

import DefaultLayout from 'js/layouts/default';

import router from 'js/router.js';
import store from 'js/vuex/store.js';
import i18n from 'js/i18n.js';

require('scss/main.scss');

/* --- Vue-Resource --- */
Vue.router = router;
Vue.store = store;

Vue.use(VueResource);

Vue.http.options.root = API_HOST;

// Create and mount the root instance.
// Make sure to inject the router with the router option to make the
// whole app router-aware.
new Vue({
  router,
  store,
  i18n,
  components: {
    DefaultLayout,
  }
}).$mount('#app');

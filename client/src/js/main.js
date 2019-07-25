import VueResource from 'vue-resource';

import 'ns-icon';
import 'ns-dropdown';
import 'ns-select';
import 'ns-table';
import 'ns-field';
import 'ns-input';
import 'ns-button';
import 'ns-input-file';

import draggable from 'vuedraggable';

// import VuejsDialog from 'vuejs-dialog';

import DefaultLayout from 'js/layouts/default/default.js';
import ExampleLayout from 'js/layouts/example';

import router from 'js/router.js';
import store from 'js/vuex/store.js';
import i18n from 'js/i18n.js';

Vue.component('default-layout', DefaultLayout);
Vue.component('example-layout', ExampleLayout);

Vue.component('draggable', draggable);

// Vue.use(VuejsDialog.main.default, {
//   okText: 'OK',
//  cancelText: 'Cancelar'
// });

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
    DefaultLayout
  }
}).$mount('#app');

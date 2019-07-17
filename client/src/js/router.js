import VueRouter from 'vue-router';

// Pages
import Home from './pages/home/index.js';
import Posts from './pages/posts/index.js';
import Post from './pages/posts/show.js';
import NewPost from './pages/posts/new.js';
import Page from './pages/example/page.js';

// Le indicamos a Vue que use VueRouter
Vue.use(VueRouter);

// Componente vacio para usarlo en las rutas padres
const RouteParent = {render(c) { return c('router-view'); }};

// Each route should map to a component. The 'component' can
// either be an actual component constructor created via
// Vue.extend(), or just a component options object.
// We'll talk about nested routes later.
const routes = [
  {
    path: '/',
    name: 'home',
    component: Home,
    meta: {
      layout: 'default'
    }
  },
  {
    path: '/page',
    name: 'page',
    component: Page,
    meta: {
      layout: 'example'
    }
  },
  {
    path: '/posts',
    name: 'my posts',
    component: Posts,
    meta: {
      layout: 'example'
    }
  },
  {
    path: '/post/:id',
    name: 'post',
    component: Post,
    props: true,
    meta: {
      layout: 'example'
    }
  },
  {
    path: '/newpost',
    name: 'create post',
    component: NewPost,
    meta: {
      layout: 'example'
    }
  },
  {
    path: '*',
    redirect: '/'
  }
];

// Create the router instance and pass the `routes` option
// You can pass in additional options here, but let's
// keep it simple for now.
const router = new VueRouter({routes});

export default router;

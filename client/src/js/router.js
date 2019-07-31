import VueRouter from 'vue-router';

// Pages
import Home from './pages/home/index.js';
import Login from './pages/log_in/index.js';
import Posts from './pages/posts/index.js';
import Post from './pages/posts/show.js';
import NewPost from './pages/posts/new.js';
import EditPost from './pages/posts/edit.js';
import Example from './pages/example/index.js';

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
    path: '/login',
    name: 'login',
    component: Login,
    meta: {
      requiresNoAuth: true,
      layout: 'example'
    }
  },
  {
    path: '/example',
    name: 'example',
    component: Example,
    meta: {
      layout: 'default'
    }
  },
  {
    path: '/posts',
    name: 'myPosts',
    component: Posts,
    meta: {
      layout: 'default'
    }
  },
  {
    path: '/posts/new',
    name: 'createPost',
    component: NewPost,
    meta: {
      layout: 'default'
    }
  },
  {
    path: '/posts/:id',
    name: 'post',
    component: Post,
    props: true,
    meta: {
      layout: 'default'
    }
  },
  {
    path: '/posts/:id/edit',
    name: 'editPost',
    component: EditPost,
    props: true,
    meta: {
      layout: 'default'
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

router.beforeEach(
  (to, from, next) => {
    if (to.meta.requiresNoAuth) {
      // if route requires no auth
      if (localStorage.getItem('token')) {
        next(from);
        return;
      }
    }
    if (to.meta.requiresAuth) {
      // if route requires no auth
      if (!localStorage.getItem('token')) {
        next(from);
        return;
      }
    }
    next();
  }
);

export default router;

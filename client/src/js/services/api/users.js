export default {
  baseUrl: 'http://localhost:3000/users',

  mergeOptions(options) {
    // definimos el resource que será utilizado en el intersector para traducir los errores
    const DEFAULT_OPTIONS = {resource: 'users'};
    return Object.assign({}, DEFAULT_OPTIONS, options);
  },

  index(params = {}, options = {}) {
    return Vue.http.get(this.baseUrl, options).then(
      response => {
        return {
          data: response.data.data,
          meta: response.data.meta
        };
      }
    );
  },

  show(id, params = {}, options = {}) {
    return Vue.http
      .get(`${this.baseUrl}/${id}`, options, {Authorization: window.localStorage.getItem('token')})
      .then(response => { return response.body.data; });
  },

  update(id, data, options = {}) {
    const sendData = data instanceof FormData ? data : {data};

    return Vue.http.put(`${this.baseUrl}/${id}`, sendData, this.mergeOptions(options));
  },

  save(data, options = {}) {
    return data.id ? this.update(data.id, data, options) : this.create(data, options);
  },

  destroy(id, options = {}) {
    return Vue.http.delete(`${this.baseUrl}/${id}`, this.mergeOptions(options));
  }
};
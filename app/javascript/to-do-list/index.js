import React from 'react'  
import ReactDOM from 'react-dom'  

import App from '../app/App'
import { Provider } from 'react-redux';
import { store } from './store';

const todos = document.querySelector('#todos')  
ReactDOM.render(
  <Provider store={store}>
    <App todos={todos.dataset.todos} />
  </Provider>,
  todos
)

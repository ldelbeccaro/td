import React from 'react'  
import {  
  BrowserRouter as Router,
  Route
} from 'react-router-dom';

import ToDoListContainer from '../to-do-list/ToDoListContainer';

export default App = (props) => (  
  <Router todos={props.todos}>
    <div>
      <Route
        path='/'
        todos={props.todos}
        render={(routeProps) => <ToDoListContainer {...props} {...routeProps} />}
      />
    </div>
  </Router>
)

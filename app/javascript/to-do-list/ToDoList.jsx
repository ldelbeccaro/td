import React from 'react';

import AddToDo from './add-to-do/AddToDo'
import ToDoContainer from './to-do/ToDoContainer'

class ToDoList extends React.Component {
  render() {
    const todos = Object.values(this.props.todos).map(todo => (
      <ToDoContainer key={todo.id} todo={todo}></ToDoContainer>
    ));
    return (
      <div className='todo-list-container'>
        {todos}
        <AddToDo />
      </div>
    );
  }
}

export default ToDoList

import React from 'react'
import styles from './to-do.styl'

class ToDo extends React.Component {
  render() {
    const todo = this.props.todo;
    return (
      <div className='to-do-item-container'>
        <div
          className={`to-do-item-checkbox ${todo.completed ? `to-do-item-completed` : ``}`}
          onClick={() => this.props.updateTodo({completed: !todo.completed})}
        >
          {todo.completed}
        </div>
        <input
          className='to-do-item-text'
          defaultValue={todo.text}
          onChange={e => this.props.updateTodo({id: 1, text: e.target.value})}
        />
        <div className='to-do-item-due-date'>{todo.due_date}</div>
        <div
          className='to-do-item-delete'
          onClick={this.props.deleteTodo}
        ></div>
      </div>
    );
  }
}

export default ToDo

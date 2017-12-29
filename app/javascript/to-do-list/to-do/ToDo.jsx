import React from 'react'
import './to-do.styl'

class ToDo extends React.Component {
  render() {
    const todo = this.props.todo

    return (
      <div className={`to-do-item-container ${todo.completed ? `to-do-item-completed` : ``}`}>
        <div
          className='to-do-item-checkbox'
          onClick={() => this.props.updateTodo({id: todo.id, completed: !todo.completed})}
        />
        <input
          className='to-do-item-text'
          defaultValue={todo.text}
          onChange={e => this.props.updateTodo({id: todo.id, text: e.target.value})}
        />
        <div className='to-do-item-dates'>
          <div className='to-do-item-start-date'>{todo.start_date || `--`}</div>
          <div className='to-do-item-due-date'>{todo.due_date || `--`}</div>
        </div>
        <div
          className='to-do-item-delete'
          onClick={this.props.deleteTodo}
        ></div>
      </div>
    );
  }
}

export default ToDo

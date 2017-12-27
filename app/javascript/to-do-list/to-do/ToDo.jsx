import React from 'react';

class ToDo extends React.Component {
  render() {
    const todo = this.props.todo;
    return (
      <div className='to-do-container'>
        <div
          className={`to-do-checkbox ${todo.completed ? `completed` : ``}`}
          onClick={() => this.props.updateTodo({completed: !todo.completed})}
        >
          {todo.completed}
        </div>
        <input
          className='to-do-text'
          defaultValue={todo.text}
          onChange={e => this.props.updateTodo({id: 1, text: e.target.value})}
        />
        <div className='to-do-due-date'>{todo.due_date}</div>
        <div
          className='to-do-delete'
          onClick={this.props.deleteTodo}
        ></div>
      </div>
    );
  }
}

export default ToDo

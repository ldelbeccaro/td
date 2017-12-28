import React from 'react'
import { connect } from 'react-redux'

import ToDoList from './ToDoList'

import {
  addTodo
} from './actions'

const fetchRequest = url => {
  return fetch(url)
    .then(resp => {
      return resp.json()
    })
    .then(json => {
      return json
    })
}

const getToDos = (todos, props) => {
  if (!Object.keys(todos).length) {
    JSON.parse(props.todos).forEach(todo => {
      todos[todo.id] = todo;
    });
  }
  return todos
}

const mapStateToProps = (state, ownProps) => ({
  todos: getToDos(state.todos, ownProps),
  offlineTodos: state.offlineTodos
})

const ToDoListContainer = connect(mapStateToProps)(ToDoList)

export default ToDoListContainer

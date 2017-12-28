import {
  ADD_TODO_REQUEST,
  ADD_TODO_SUCCESS,
  ADD_TODO_FAILURE,
  UPDATE_TODO,
  DELETE_TODO
} from './constants';
import { API } from '../helpers/api/constants'
import { postRequest } from '../helpers/api/api'

function addTodo(tempTodo) {
  return dispatch => {
    dispatch(addTodoRequest(tempTodo))

    return postRequest(API.ADD_TODO, {tempTodo})
      .then(resp => resp.json())
      .then(newTodo => dispatch(addTodoSuccess(tempTodo, newTodo)))
      .catch(err => dispatch(addTodoFailure(tempTodo, err)))
  }
}

function addTodoRequest(todo) {
  return {
    type: ADD_TODO_REQUEST,
    todo
  }
}

function addTodoSuccess(tempTodo, newTodo) {
  return {
    type: ADD_TODO_SUCCESS,
    tempId: tempTodo.id,
    todo: newTodo
  }
}

function addTodoFailure(tempTodo, err) {
  return {
    type: ADD_TODO_FAILURE,
    err,
    todo
  }
}

function updateTodo(todo) {
  return {
    type: UPDATE_TODO,
    todo
  }
}

function deleteTodo(todo) {
  return {
    type: DELETE_TODO,
    todo
  }
}

export {
  addTodo,
  updateTodo,
  deleteTodo
}

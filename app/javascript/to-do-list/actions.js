import {
  ADD_TODO,
  UPDATE_TODO,
  DELETE_TODO
} from './constants';

export const addTodo = todo => ({
  type: ADD_TODO,
  todo
});

export const updateTodo = todo => ({
  type: UPDATE_TODO,
  todo
});

export const deleteTodo = todo => ({
  type: DELETE_TODO,
  todo
});

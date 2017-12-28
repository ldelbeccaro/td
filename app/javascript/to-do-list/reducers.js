import { combineReducers } from 'redux'

import {
  ADD_TODO_REQUEST,
  ADD_TODO_SUCCESS,
  UPDATE_TODO,
  DELETE_TODO
} from './constants';

export const offlineTodos = (state = {}, action) => {
  switch(action.type) {
    case ADD_TODO_REQUEST:
      const tempId = `temp_${Object.keys(state).length}`
      return {
        ...state,
        [tempId]: {
          ...action.todo,
          id: tempId
        }
      }
    case ADD_TODO_SUCCESS:
      let newTodos = {...state}
      delete newTodos[action.tempId]
      return newTodos
    default:
      return state
  }
}

export const todos = (state = {}, action) => {
  switch (action.type) {
    case ADD_TODO_SUCCESS:
    case UPDATE_TODO:
      return {
        ...state,
        [action.todo.id]: action.todo
      };
    case DELETE_TODO:
      let newTodos = {...state};
      delete newTodos[action.todo.id];
      return newTodos;
    default:
      return state
  }
};

export const reducers = combineReducers({
  offlineTodos,
  todos,
});

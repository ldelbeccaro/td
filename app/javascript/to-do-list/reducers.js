import { combineReducers } from 'redux'

import {
  ADD_TODO,
  UPDATE_TODO,
  DELETE_TODO
} from './constants';

export const todos = (state = {}, action) => {  
  switch (action.type) {
    case ADD_TODO:
      return {
        ...state,
        'temp': {
          ...action.todo,
          id: 'temp'
        }
      }
    case UPDATE_TODO:
      return {
        ...state,
        [action.todo.id]: action.todo
      };
    case DELETE_TODO:
      const newTodos = {...state};
      delete newTodos[action.todo.id];
      return newTodos;
    default:
      return state;
  }
};

export const reducers = combineReducers({
  todos,
});

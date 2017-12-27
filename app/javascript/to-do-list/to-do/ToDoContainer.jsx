import React from 'react';
import { connect } from 'react-redux';

import ToDo from './ToDo';

import {
  updateTodo,
  deleteTodo
} from '../actions';

const mapStateToProps = (state, ownProps) => ({
  todos: state.todos
});

const mapDispatchToProps = {
  updateTodo,
  deleteTodo
};

const ToDoContainer = connect(
  mapStateToProps,
  mapDispatchToProps
)(ToDo);

export default ToDoContainer;

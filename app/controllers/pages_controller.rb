class PagesController < ApplicationController
  def home
    @todos = Todo.all_todos.to_json
  end
end

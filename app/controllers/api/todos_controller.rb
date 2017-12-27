class Api::TodosController < ApplicationController
  def index
    @todos = Todo.all_tasks
  end
end

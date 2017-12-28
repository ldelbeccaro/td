class Api::TodosController < ApplicationController
  def show
    @todos = Todo.find(params[:id])
  end
end

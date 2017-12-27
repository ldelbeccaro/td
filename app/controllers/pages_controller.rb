class PagesController < ApplicationController
  def home
    @todos = Todo.all_tasks.to_json
  end
end

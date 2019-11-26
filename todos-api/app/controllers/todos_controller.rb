require_relative './concerns/batch_job_logger'

class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  # GET /todos
  def index
    @todos = Todo.all
    logger.submit_batch_job
    json_response(@todos)
  end

  # POST /todos
  def create
    @todo = Todo.create!(todo_params)
    logger.submit_batch_job
    json_response(@todo, :created)
  end

  # GET /todos/:id
  def show
    logger.submit_batch_job
    json_response(@todo)
  end

  # PUT /todos/:id
  def update
    @todo.update(todo_params)
    logger.submit_batch_job
    head :no_content
  end

  # DELETE /todos/:id
  def destroy
    @todo.destroy
    logger.submit_batch_job
    head :no_content
  end

  def logger
    BatchJobLogger.instance
  end

  private

  def todo_params
    params.permit(:title, :created_by)
  end

  def set_todo
    @todo = Todo.find(params[:id])
  end

end

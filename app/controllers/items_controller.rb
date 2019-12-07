require_relative './concerns/batch_job_submitter'

class ItemsController < ApplicationController
  before_action :set_todo
  before_action :submit_job
  before_action :set_todo_item, only: %i[show update destroy]

  # GET /todos/:todo_id/items
  def index
    json_response(@todo.items)
  end

  # GET /todos/:todo_id/items/:id
  def show
    json_response(@item)
  end

  # POST /todos/:todo_id/items
  def create
    @todo.items.create!(item_params)
    json_response(@todo, :created)
  end

  # PUT /todos/:todo_id/items/:id
  def update
    @item.update(item_params)
    head :no_content
  end

  # DELETE /todos/:todo_id/items/:id
  def destroy
    @item.destroy
    head :no_content
  end

  def submitter
    BatchJobSubmitter.instance
  end

  private

  def item_params
    params.permit(:name, :done)
  end

  def submit_job
    param_hash = { request_action: http_method(params[:action]) }
    submitter.submit_batch_job(:LOGGER, param_hash)
  end

  def set_todo
    @todo = Todo.find(params[:todo_id])
  end

  def set_todo_item
    @item = @todo.items.find_by!(id: params[:id]) if @todo
  end

end
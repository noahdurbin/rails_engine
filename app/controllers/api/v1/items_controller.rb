class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      merchant = Merchant.find(params[:merchant_id])
      render json: ItemSerializer.new(merchant.items)
    else
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
    item = Item.find_by(params[:item_id])
    render json: ItemSerializer.new(item)
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      render json: @item, status: 200
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.permit(:name, :unit_price, :description, :merchant_id)
  end
end

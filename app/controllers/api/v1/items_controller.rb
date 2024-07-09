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
end

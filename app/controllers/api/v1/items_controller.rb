class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      merchant = Merchant.find(params[:merchant_id])
      serialized_items = ItemSerializer.new(merchant.items).serializable_hash
      render json: serialized_items[:data]
    else
      serialized_items = ItemSerializer.new(Item.all)
      render json: serialized_items[:data]
    end
  end
end

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
    item = Item.new(item_params)
    if item.save
      render json: item, status: 200
    else  
      render json: { errors: item.errors.full_messages }, status: 422
    end
  end

  def update 
    item = Item.find(params[:id])

    if item.update!(item_params)
      render json: ItemSerializer.new(item), status: 200
    # else
    #   render json: { errors: item.errors.full_messages }, status: 422
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy

    render json: ItemSerializer.new(item), status: 204
  end

  def merchant 
    @item = Item.find(params[:item_id])
    # require 'pry'; binding.pry
    @merchant = @item.merchant

    if @merchant 
      render json: MerchantSerializer.new(@merchant), status: 200
    # else 
    #   render json: { errors: item.errors.full_messages }, status: 404
    end
  end

  private

  def item_params
    params.permit(:name, :unit_price, :description, :merchant_id)
  end
end

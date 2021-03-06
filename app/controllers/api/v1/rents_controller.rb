module Api
  module V1
    class RentsController < ApiController
      def index
        render_paginated rents, each_serializer: RentSerializer, status: :ok
      end

      def create
        new_rent = user.rents.new(create_rent_params)
        authorize new_rent

        if new_rent.save
          RentsMailer.send_new_rent_email(new_rent.id).deliver_later
          render json: new_rent, serializer: RentSerializer, status: :created
        else
          render json: { errors: new_rent.errors }, status: :unprocessable_entity
        end
      end

      private

      def rents
        user.rents
      end

      def user
        User.find(rent_params[:user_id])
      end

      def rent_params
        params.permit(:user_id)
      end

      def create_rent_params
        params.require(:rent).permit(:book_id, :start_date, :end_date, :returned_at)
      end
    end
  end
end

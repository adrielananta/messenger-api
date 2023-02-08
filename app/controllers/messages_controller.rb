class MessagesController < ApplicationController

    def index
        render json: "hi"
    end

    def create
        #@conversation = Conversation.new(params.require(:user_ids).permit(user_ids: [current_user.id, user_id]))
        #@conversation.save
        #render json: ConversationUser.all
        #@result = JSON.parse(request.params)
        @text = params[:message]
        @user_id = params[:user_id]
        @status = 201

        if @text.empty? || @text.nil?
            render status: 422
        else
            @conversation = Conversation.new
            @conversation.save()

            @sender_convo = ConversationUser.new
            @sender_convo.conversation_id = @conversation.id
            @sender_convo.user_id = current_user.id
            @sender_convo.save()

            @recipient_convo = ConversationUser.new
            @recipient_convo.conversation_id = @conversation_id
            @recipient_convo.user_id = @user_id
            @recipient_convo.save()
            
            @recipient = User.find(@recipient_convo.user_id)

            @message = Msg.new
            @message.conversation_id = @conversation.id
            @message.user_id = current_user.id
            @message.message = @text
            @message.save()

            @data = {
                id: @message.id,
                message: @message.message,
                sender: {
                id: @message.user_id,
                name: current_user.name
                },
                sent_at: @message.created_at,
                conversation: {
                id: @message.conversation_id,
                with_user: {
                    id: @recipient.id,
                    name: @recipient .name,
                    photo_url: @recipient.photo_url
                }
                }
            }

            json_response(@data, @status)
        end 
    end
end

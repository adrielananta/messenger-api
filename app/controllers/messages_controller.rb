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

        @conversation = Conversation.find_by_sql ["SELECT * FROM conversations as c INNER JOIN conversations_users AS cu1 ON c.id = cu1.conversation_id INNER JOIN conversations_users AS cu2 ON c.id = cu2.conversation_id WHERE cu1.user_id = ? AND cu2.user_id = ?", current_user.id, @user_id]

        @sender_convo = ConversationUser.new
        @recipient_convo = ConversationUser.new

        if @conversation.length == 0
            @conversation = Conversation.new
            @conversation.save()

            @sender_convo.conversation_id = @conversation.id
            @sender_convo.user_id = current_user.id
            @sender_convo.save()

            @recipient_convo.conversation_id = @conversation_id
            @recipient_convo.user_id = @user_id
            @recipient_convo.save()
        else
            @conversation = @conversation[0]

            @sender_convo = ConversationUser.select([:first]).where(user_id: current_user.id, conversation_id: @conversation.id)
            @recipient_convo = ConversationUser.select([:first]).where(user_id: @user_id, conversation_id: @conversation.id)
        end

        if @text.empty? || @text.nil?
            render status: 422
        else
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

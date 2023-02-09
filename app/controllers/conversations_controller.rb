class ConversationsController < ApplicationController
    
    def index
        @data = []
        Conversation.joins(:conversation_users).where(conversation_users: { user_id: current_user.id }).each do |convo|
            @convo_members = ConversationUser.where(conversation_id: convo.id).to_a()
            if @convo_members[0].user_id == current_user.id
                @sender_convo = @convo_members[0]
                @recipient_convo = @convo_members[1]
            else
                @sender_convo = @convo_members[1]
                @recipient_convo = @convo_members[0]
            end
            @recipient = User.find_by(id: recipient_convo.user_id)
            @latest = Msg.select([:first]).where(conversation_id: convo.id)
            @latest_sender = User.find_by(id: @latest.user_id)
            @temp = {
                id: convo.id,
                with_user: {
                    id: @recipient.id,
                    name: @recipient.name,
                    photo_url: @recipient.photo_url
                },
                last_message: {
                    id: @latest.id,
                    sender: {
                        id: @latest_sender.id,
                        name: @latest_sender.name
                    },
                    sent_at: @latest.created_at
                },
                unread_count: @sender_convo.unread
            }
            @data.push(@temp)
        end
        json_response(@data, 200)
    end
end

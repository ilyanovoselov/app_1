class MemoRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "memo_room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast "memo_room_channel", message: data["message"], author_name: data["name"], author_id: data["player_id"], messageID: data["messageID"]
  end

  def announce(data)
    ActionCable.server.broadcast "memo_room_channel", user_name: data["name"], type: data["type"], author_id: data["player_id"], messageID: data["messageID"]
  end
end

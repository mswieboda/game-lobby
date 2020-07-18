require './config/environment'
require './models/application_record'
require './models/game'
require './models/lobby'
require 'json'

class App < Roda
  plugin :all_verbs
  plugin :json_parser
  plugin :error_handler

  error do |e|
    message = e.message

    if e.is_a?(ActiveRecord::RecordNotFound)
      response.status = 404
      puts e
      puts e.backtrace
      message = "Not found"
    end

    message.to_json
  end

  route do |r|
    game_key = r.env['HTTP_GAME_KEY']
    game = Game.find_by!(key: game_key)

    r.on "lobbies" do
      # POST /lobbies/create
      r.post "create" do
        Lobby.find_or_create_by!(
          game_id: game.id,
          host: r.ip
        ).update(
          name: r.params['name'],
          peers: 1,
          status: "open",
          size: r.params['size']
        ).to_json
      end

      r.on Integer do |lobby_id|
        lobby = Lobby.where(game_id: game.id).find(lobby_id)

        # POST /lobbies/:id/join
        r.post "join" do
          lobby.update!(peers: lobby.peers + 1)
          lobby.to_json
        end

        # POST /lobbies/:id/start
        r.post "start" do
          lobby.update!(status: "active")
          lobby.to_json
        end

        # POST /lobbies/:id/stop
        r.post "stop" do
          lobby.update!(status: "open")
          lobby.to_json
        end

        # DELETE /lobbies/:id/leave
        r.delete "leave" do
          lobby.update!(peers: lobby.peers - 1)
          lobby.to_json
        end

        # DELETE /lobbies/:id/end
        r.delete "end" do
          lobby.update(status: "ended")
          lobby.to_json
        end

        r.is do
          r.get do
            lobby.to_json
          end
        end
      end

      # GET /lobbies
      r.is do
        r.get do
          Lobby
            .all
            .where(game_id: game.id)
            .where.not(status: "ended")
            .order(updated_at: :desc)
            .to_a
            .to_json
        end
      end
    end
  end
end

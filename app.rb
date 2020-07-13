require './config/environment'
require './models/application_record'
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
    r.on "lobbies" do
      # POST /lobbies/create
      r.post "create" do
        Lobby.create(
          name: r.params['name'],
          host: r.host,
          peers: 1,
          status: "open",
          size: r.params['size']
        ).to_json
      end

      r.on Integer do |lobby_id|
        lobby = Lobby.find(lobby_id)

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
          lobby.destroy.to_json
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
          Lobby.all.to_a.to_json
        end
      end
    end
  end
end
